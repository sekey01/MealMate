import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:easy_url_launcher/easy_url_launcher.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:lottie/lottie.dart';
import 'package:mealmate/components/CustomLoading.dart';
import 'package:provider/provider.dart';

import '../../Courier/courier_model.dart';
import '../../UserLocation/LocationProvider.dart';
import '../../components/Notify.dart';
import '../../components/mainCards/verticalCard.dart';

class CouriersAvailable extends StatefulWidget {
  const CouriersAvailable({super.key});

  @override
  State<CouriersAvailable> createState() => _CouriersAvailableState();
}

Future<List<CourierModel>> getNearbyCouriers(BuildContext context, double maxDistance) async {
  try {
    FirebaseFirestore firestore = FirebaseFirestore.instance;
    QuerySnapshot querySnapshot = await firestore
        .collection('CourierId')
        .where('isCourierOnline', isEqualTo: true)
        .get();

    List<CourierModel> nearbyCouriers = [];
    LatLng currentLocation = await Provider.of<LocationProvider>(context, listen: false).getPoints();

    for (var doc in querySnapshot.docs) {
      CourierModel courier = CourierModel.fromMap(doc.data() as Map<String, dynamic>, doc.id);
      LatLng courierLocation = LatLng(courier.CourierLatitude, courier.CourierLongitude);
      double distance = Provider.of<LocationProvider>(context, listen: false).calculateDistance(currentLocation, courierLocation);

      if (distance <= maxDistance) {
        nearbyCouriers.add(courier);
      }
    }

    return nearbyCouriers;
  } catch (e) {
    Notify(context, 'Error retrieving courier details', Colors.red);
    print('Error retrieving courier details: $e');
    return [];
  }
}

class _CouriersAvailableState extends State<CouriersAvailable> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        leading: IconButton(
          onPressed: () {
            Navigator.pop(context);
          },
          icon: Icon(Icons.arrow_back_ios),
          color: Colors.blueGrey,
        ),
        backgroundColor: Colors.white,
        title: RichText(
          text: TextSpan(
            children: [
              TextSpan(
                text: "Available",
                style: TextStyle(
                  color: Colors.black,
                  fontSize: 20.spMin,
                  fontWeight: FontWeight.bold,
                  fontFamily: 'Righteous',
                ),
              ),
              TextSpan(
                text: "Couriers",
                style: TextStyle(
                  color: Colors.deepOrangeAccent,
                  fontSize: 20.spMin,
                  fontWeight: FontWeight.bold,
                  fontFamily: 'Righteous',
                ),
              ),
            ],
          ),
        ),
        centerTitle: true,
      ),

      bottomSheet: Container(
        height: 5.sh,
        width: 1.sw,
        decoration: BoxDecoration(
          color: Colors.grey.shade200,
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(30.sp),
            topRight: Radius.circular(30.sp),
          ),
        ),
        child: SingleChildScrollView(
          child: Column(
            children: [
              Padding(
                padding: EdgeInsets.only(top: 20.sp),
                child: Text(
                  'Couriers Available',
                  style: TextStyle(
                    color: Colors.black,
                    fontSize: 15.sp,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              FutureBuilder(
                future: getNearbyCouriers(context, 10.0),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return Center(
                      child: CustomLoGoLoading(),
                    );
                  } else if (snapshot.hasError) {
                    return Center(
                      child: Text(
                        'No Courier Available',
                        style: TextStyle(
                          color: Colors.black,
                          fontSize: 15.sp,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    );
                  } else if (snapshot.hasData) {
                    List<CourierModel> couriers = snapshot.data as List<CourierModel>;

                    if (couriers.isEmpty) {
                      return NoCouriersFound();
                    }

                    return Padding(
                      padding: const EdgeInsets.only(top: 20, right: 10, left: 10),
                      child: Column(
                        children: couriers.map((courier) {
                          return Container(
                            margin: EdgeInsets.only(bottom: 10),
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(10),
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.grey,
                                  offset: Offset(0.0, 1.0), //(x,y)
                                  blurRadius: 6.0,
                                ),
                              ],
                            ),
                            child: Column(
                              children: [
                                ListTile(
                                  leading: CircleAvatar(
                                    radius: 30.r,
                                    backgroundImage: NetworkImage(courier.CourierGhanaCardPictureUrl),
                                  ),
                                  title: Text(
                                    courier.CourierName,
                                    style: TextStyle(
                                      color: Colors.black,
                                      fontWeight: FontWeight.bold,
                                      fontSize: 15.sp,
                                      fontFamily: 'Righteous',
                                    ),
                                  ),
                                  subtitle: Text(
                                    courier.CourierEmail,
                                    style: TextStyle(
                                      color: Colors.black,
                                      fontWeight: FontWeight.bold,
                                      fontSize: 12.sp,
                                      fontFamily: 'Poppins',
                                    ),
                                  ),
                                  trailing: Lottie.asset('assets/Icon/online.json', height: 50.h, width: 50.w),
                                ),
                                Column(
                                  children: [
                                    Padding(
                                      padding: EdgeInsets.all(8),
                                      child: Text(
                                        'Call Or Text the courier if he is on his way to deliver another order or ready to pick up your order',
                                        textAlign: TextAlign.center,
                                        style: TextStyle(
                                          fontSize: 12.sp,
                                          color: Colors.grey.shade600,
                                        ),
                                      ),
                                    ),
                                    Row(
                                      mainAxisAlignment: MainAxisAlignment.center,
                                      children: [
                                        GestureDetector(
                                          onTap: () async {
                                            EasyLauncher.sendToWhatsApp(
                                              phone: '+233${courier.CourierContact}',
                                              message: 'Hello, Can you deliver my order to a buyer?',
                                            );
                                          },
                                          child: Column(
                                            children: [
                                              Image(
                                                image: AssetImage('assets/Icon/whatsapp.png'),
                                                height: 30.h,
                                                width: 30.w,
                                              ),
                                              Text(
                                                'Whatsapp',
                                                style: TextStyle(
                                                  color: Colors.black,
                                                  fontSize: 10.sp,
                                                  fontWeight: FontWeight.bold,
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                        SizedBox(width: 30.w),
                                        ElevatedButton(
                                          style: ElevatedButton.styleFrom(
                                            elevation: 3,
                                            backgroundColor: Colors.redAccent,
                                            shape: RoundedRectangleBorder(
                                              borderRadius: BorderRadius.circular(10),
                                            ),
                                          ),
                                          onPressed: () async {
                                            EasyLauncher.call(number: courier.CourierContact.toString());
                                          },
                                          child: Text(
                                            'Call Courier',
                                            style: TextStyle(
                                              color: Colors.white,
                                              fontWeight: FontWeight.bold,
                                              fontFamily: 'Righteous',
                                              fontSize: 15.sp,
                                              letterSpacing: 2,
                                            ),
                                          ),
                                        ),
                                        SizedBox(width: 30.w),
                                        GestureDetector(
                                          onTap: () async {
                                            EasyLauncher.sms(number: courier.CourierContact.toString());
                                          },
                                          child: Column(
                                            children: [
                                              Image(
                                                image: AssetImage('assets/Icon/sms.png'),
                                                height: 30.h,
                                                width: 30.w,
                                              ),
                                              Text(
                                                'SMS',
                                                style: TextStyle(
                                                  color: Colors.black,
                                                  fontSize: 10.sp,
                                                  fontWeight: FontWeight.bold,
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          );
                        }).toList(),
                      ),
                    );
                  } else {
                    return Center(
                      child: Text(
                        'No Courier Available',
                        style: TextStyle(
                          color: Colors.black,
                          fontSize: 15.sp,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    );
                  }
                },
              ),
            ],
          ),
        ),
      ),
    );
  }


}