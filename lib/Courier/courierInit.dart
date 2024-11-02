import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:lite_rolling_switch/lite_rolling_switch.dart';
import 'package:lottie/lottie.dart';
import 'package:mealmate/Courier/courier_model.dart';
import 'package:mealmate/Courier/trackbuyer.dart';
import 'package:mealmate/Courier/update_details.dart';
import 'package:mealmate/Local_Storage/Locall_Storage_Provider/StoreCredentials.dart';
import 'package:mealmate/components/CustomLoading.dart';
import 'package:provider/provider.dart';

import '../UserLocation/LocationProvider.dart';
import '../components/Notify.dart';
import '../components/card1.dart';
import '../components/mainCards/promotion_ads_card.dart';

class CourierInit extends StatefulWidget {
  const CourierInit({super.key,});

  @override
  State<CourierInit> createState() => _CourierInitState();
}

Future<CourierModel?> getCourierDetails(BuildContext context, String courierId) async {
  try {
    // Get a reference to the Firestore instance
    FirebaseFirestore firestore = FirebaseFirestore.instance;

    // Query the 'CourierId' collection for the document with matching ID
    QuerySnapshot querySnapshot = await firestore
        .collection('CourierId')
        .where('CourierId', isEqualTo: courierId)
        .limit(1)
        .get();

    // Check if any documents were found
    if (querySnapshot.docs.isNotEmpty) {
      Notify(context, 'Courier found', Colors.green);
      // Create a CourierModel from the document data
      var doc = querySnapshot.docs.first;
      CourierModel courier = CourierModel.fromMap(doc.data() as Map<String, dynamic>, doc.id);
      return courier;
    } else {
      Notify(context, 'Courier not found', Colors.red);
      return null;
    }
  } catch (e) {
    Notify(context, 'Error retrieving courier details', Colors.red);
    print('Error retrieving courier details: $e');
    return null;
  }
}


Future<void> switchCourierOnlineStatus(String courierId) async {
  try {
    FirebaseFirestore firestore = FirebaseFirestore.instance;

    // Query the 'CourierId' collection for the document with matching CourierId
    QuerySnapshot querySnapshot = await firestore
        .collection('CourierId')
        .where('CourierId', isEqualTo: courierId)
        .limit(1)
        .get();

    // Check if any documents were found
    if (querySnapshot.docs.isNotEmpty) {
      var doc = querySnapshot.docs.first;
      bool currentStatus = doc['isCourierOnline'] ?? false;

      // Update the isCourierOnline field with the toggled value
      await doc.reference.update({'isCourierOnline': !currentStatus});
      print('Courier online status updated successfully');
    } else {
      print('Courier not found');
    }
  } catch (e) {
    print('Error updating courier online status: $e');
  }
}
class _CourierInitState extends State<CourierInit> {
  final _formKey = GlobalKey<FormState>();

  final TextEditingController LatitudeController = TextEditingController();
  final TextEditingController LongitudeController = TextEditingController();
  final TextEditingController PhoneNumberController = TextEditingController();
@override
  void initState() {
    // TODO: implement initState
    super.initState();
    Provider.of<LocalStorageProvider>(context, listen: false).getCourierID();


}

  @override
  Widget build(BuildContext context) {
final CourierID = Provider.of<LocalStorageProvider>(context, listen: false).courierId;
    ///I RUN THE DETERMIN LOCATION HERE TO GET THE LAT AND LONG QUICKLY
    Provider.of<LocationProvider>(
        context,
        listen: false).determinePosition();

    return  Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      appBar: AppBar(
        automaticallyImplyLeading: false,
        leading: IconButton(onPressed: (){
          Navigator.pop(context);
        }, icon: Icon(Icons.arrow_back_ios), color: Colors.blueGrey,),
        backgroundColor: Colors.white,
        title: RichText(text: TextSpan(
            children: [
              TextSpan(text: "Courier", style: TextStyle(color: Colors.black, fontSize: 20.spMin,fontWeight: FontWeight.bold,fontFamily: 'Righteous',)),
              TextSpan(text: "Panel", style: TextStyle(color: Colors.deepOrangeAccent, fontSize: 20.spMin,fontWeight: FontWeight.bold,fontFamily: 'Righteous',)),

            ]
        )),
        centerTitle: true,
        actions: [
          InkWell(
              onTap: (){
Navigator.push(context, MaterialPageRoute(builder: (context)=>UpdateDetails()));
              },
              child: ImageIcon(AssetImage('assets/Icon/refresh.png'),size: 30.sp,color: Colors.blueGrey,)),
          SizedBox(width: 10.w,),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Center(
          child: SingleChildScrollView(
            scrollDirection: Axis.vertical,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                ///LOCATION DISPLAYED HERE
                ///
                ///
                SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      Icon(Icons.location_on_outlined, size: 20.sp,color: Colors.blueGrey,),
                      FutureBuilder(
                          future:
                          Provider.of<LocationProvider>(context, listen: false).determinePosition(),
                          builder: (context, snapshot) {
                            if (snapshot.hasData) {
                              return Padding(
                                padding: const EdgeInsets.all(2.0),
                                child: Text(snapshot.data.toString(),
                                    overflow: TextOverflow.ellipsis,
                                    style: TextStyle(
                                        overflow: TextOverflow.ellipsis,
                                        color: Colors.black,
                                        fontWeight: FontWeight.bold,
                                        fontSize: 12.sp)),
                              );
                            }
                            return Text(
                              'locating you...',
                              style: TextStyle(color: Colors.blueGrey,fontWeight: FontWeight.normal,fontSize: 10.spMin),
                            );
                          }),
                    ],
                  ),
                ),

                ///FUTURE BUILDER TO GET COURIER DETAILS
                ///
                ///

                FutureBuilder(future: getCourierDetails(context, CourierID),
                        builder: (context,snapshot){
                if(snapshot.connectionState == ConnectionState.waiting){
                  return CourierDetailsLoading();
                }
                if(snapshot.hasError){
                  return Text('Error: ${snapshot.error}');
                }
                if(snapshot.hasData){
                  CourierModel courier = snapshot.data as CourierModel;
                  return Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Container(
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
                            leading: CircleAvatar(radius: 30.r,backgroundImage: NetworkImage(courier.CourierGhanaCardPictureUrl),),
                            title: Text(courier.CourierName,style: TextStyle(color: Colors.black,fontWeight: FontWeight.bold,fontSize: 15.sp,fontFamily: 'Righteous'),),
                            subtitle: Text(courier.CourierEmail,style: TextStyle(color: Colors.black,fontWeight: FontWeight.bold,fontSize: 10.sp, fontFamily: 'Poppins'),),
                            trailing: courier.isCourierOnline ? LottieBuilder.asset('assets/Icon/online.json', height: 50.h, width: 30.w,): Icon(Icons.offline_bolt, color: Colors.red),

                          ),
                          ListTile(
                            leading: Icon(Icons.phone_android_outlined, color: Colors.blueGrey,),
                            title: Text('+233' + courier.CourierContact.toString(),style: TextStyle(color: Colors.black,fontWeight: FontWeight.bold,fontSize: 15.sp,fontFamily: 'Poppins'),),
                            subtitle: Text('Contact',style: TextStyle(color: Colors.blueGrey,fontWeight: FontWeight.bold,fontSize: 12.sp, fontFamily: 'Poppins'),),

                          ),
                          ListTile(
                            leading: Icon(Icons.connect_without_contact, color: Colors.blueGrey,),
                            title: LiteRollingSwitch(
                              //initial value
                              value: courier.isCourierOnline,
                              width: 250.w,
                              textOn: 'Online',
                              textOnColor: Colors.white,
                              textOff: 'Offline',
                              textOffColor: Colors.white,
                              colorOn: CupertinoColors.activeGreen,
                              colorOff: Colors.redAccent,
                              iconOn: Icons.done,
                              iconOff: Icons.remove_circle_outline,
                              textSize: 20.0,
                              onChanged: (bool state) {
                                switchCourierOnlineStatus(courier.CourierId);
                              },
                              onTap: () {

                              },
                              onDoubleTap: () {},
                              onSwipe: () {},
                            ),
                            subtitle: Text('   Toggle to switch Online and Offline',style: TextStyle(color: Colors.blueGrey,fontWeight: FontWeight.bold,fontSize: 12.sp, fontFamily: 'Poppins'),),

                          ),

                        ],
                      ),
                    ),
                  );
                }
                return Text('No data');
    }),




               // initCourierCard(),
                SizedBox(height: 10.h,),
                Padding(padding: EdgeInsets.only(top: 20,bottom: 20),
                    child: PromotionAdsCard(
                      image: 'assets/images/MealmateDress.png',
                      heading:'Welcome to Courier Panel',
                      content: 'Track buyer by entering the phone number and the latitude and longitude of the buyer',
                      contentColor: Colors.white70,
                      headingColor: Colors.white,
                      backgroundColor: Colors.redAccent,

                    )),

                SizedBox(height: 20.h,),
                
                /// CONTAINER SHOWING LIST OF RESTAURANTS THAT HAVE ORDER TO DELIVER TO BUYER 
                Container(
                  height: 0.5.sh,
                  width: 1.sw,
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
                  
                  child: Expanded(child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Padding(
                        padding: const EdgeInsets.only(bottom: 50,top: 20),
                        child: RichText(
                          text: TextSpan(
                            children: [
                              TextSpan(
                                text: 'Restaurants',
                                style: TextStyle(
                                  color: Colors.black,
                                  fontSize: 20.sp,
                                  fontWeight: FontWeight.bold,
                                  fontFamily: 'Righteous',
                                ),
                              ),
                              TextSpan(
                                text: ' Requesting Delivery',
                                style: TextStyle(
                                  color: Colors.deepOrangeAccent,
                                  fontSize: 20.sp,
                                  fontWeight: FontWeight.bold,
                                  fontFamily: 'Righteous',
                                ),
                              ),
                            ],
                          ),
                        ),
                        ),
                    Image(
                      image: AssetImage("assets/Icon/no_food_found.png"),
                      height: 200, width: 200,

                    )

                    ],
                  )),
                ),

SizedBox(height: 20.h,),
                ///TRACK BUYER ROUTE ALERT
                ///
                SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: RichText(
                    text: TextSpan(
                      children: [
                        TextSpan(
                          text: 'Track Buyer',
                          style: TextStyle(
                            color: Colors.black,
                            fontSize: 20.sp,
                            fontWeight: FontWeight.bold,
                            fontFamily: 'Righteous',
                          ),
                        ),
                        TextSpan(
                          text: ' Route',
                          style: TextStyle(
                            color: Colors.deepOrangeAccent,
                            fontSize: 20.sp,
                            fontWeight: FontWeight.bold,
                            fontFamily: 'Righteous',
                          ),
                        ),

                        TextSpan(
                          text: ' By Entering:',
                          style: TextStyle(
                            color: Colors.black,
                            fontSize: 20.sp,
                            fontWeight: FontWeight.bold,
                            fontFamily: 'Righteous',
                          ),
                        ),

                      ],
                    ),
                  ),
                ),

                ///FORM TO TRACK BUYER
            Form(
                key: _formKey,
                child: Column(
              children: [
                ///TEXTFIELD FOR BUYER PHONE NUMBER
                Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: TextFormField(
                        keyboardType: TextInputType.numberWithOptions(decimal: true, signed: true),
                        maxLength: 10,
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Please enter phone number';
                          }
                          double? phoneNumber = double.tryParse(value);
                          if (phoneNumber == null) {
                            return 'Please enter a valid number';
                          }
                          if (phoneNumber < 0 ) {
                            return 'Phone number must be positive';
                          }
                          //if phone number is not up to 10 digits
                          if (value.length < 10) {
                            return 'Phone number must be 10 digits';
                          }
                          return null;
                        },
                        style: TextStyle(color: Colors.black),
                        controller: PhoneNumberController,
                        decoration: InputDecoration(
                          filled: true,
                          fillColor: Colors.deepOrange.shade50,
                          hintStyle: TextStyle(color: Colors.black),
                          //label: Text('Restaurant Name'),
                          labelStyle: TextStyle(color: Colors.black),
                          labelText: 'Receive\'s Phone Number',
                          hintText: ' Telephone Number',

                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10),
                            borderSide: BorderSide(
                                color: Colors.deepOrangeAccent


                            ),),))),

                ///TEXTFIELD FOR LATITUDE
                Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: TextFormField(
                        keyboardType: TextInputType.numberWithOptions(decimal: true, signed: true),
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Please enter latitude';
                          }
                          double? longitude = double.tryParse(value);
                          if (longitude == null) {
                            return 'Please enter a valid number';
                          }
                          if (longitude < -180 || longitude > 180) {
                            return 'Latitude must be between -180 and 180';
                          }
                          return null;
                        },
                        style: TextStyle(color: Colors.black),
                        controller: LatitudeController,
                        decoration: InputDecoration(
                          filled: true,
                          fillColor: Colors.deepOrange.shade50,
                          hintStyle: TextStyle(color: Colors.black),
                          //label: Text('Restaurant Name'),
                          labelStyle: TextStyle(color: Colors.black),
                          labelText: 'Latitude',
                          hintText: ' Latitude',

                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10),
                            borderSide: BorderSide(
                                color: Colors.deepOrangeAccent


                            ),),))),

                ///TEXTFIELD FOR LONGITUDE
                Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: TextFormField(
                        keyboardType: TextInputType.numberWithOptions(decimal: true, signed: true),
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Please enter longitude';
                          }
                          double? longitude = double.tryParse(value);
                          if (longitude == null) {
                            return 'Please enter a valid number';
                          }
                          if (longitude < -180 || longitude > 180) {
                            return 'Longitude must be between -180 and 180';
                          }
                          return null;
                        },
                        style: TextStyle(color: Colors.black),
                        controller: LongitudeController,
                        decoration: InputDecoration(
                            filled: true,
                            fillColor: Colors.deepOrange.shade50,
                            hintStyle: TextStyle(color: Colors.black),
                            //label: Text('Restaurant Name'),
                            labelStyle: TextStyle(color: Colors.black),
                            labelText: 'Longitude',
                            hintText: ' Longitude',

                            border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(10),
                                borderSide: BorderSide(
                                    color: Colors.deepOrangeAccent)
                            ))
                    )
                ),
                SizedBox(height: 20.h,),
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    elevation: 3,
                    backgroundColor: Colors.redAccent,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                  onPressed: () {
                    if (_formKey.currentState!.validate()) {
                      Navigator.push(context,
                          MaterialPageRoute(builder: (context)=>
                              TrackBuyer(
                                  phoneNumber: int.parse(PhoneNumberController.text.toString()),
                                  Latitude: double.parse(LatitudeController.text.toString()),
                                  Longitude: double.parse(LongitudeController.text.toString())))
                      );

                    }
                  },
                  child: Text('Track Route ',style: TextStyle(fontSize: 20.sp,fontWeight: FontWeight.bold,color: Colors.white,fontFamily: 'Righteous', letterSpacing: 2),),

                ),
                SizedBox(height: 50.h,),

              ],
            )),





              ],
            ),
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          setState(() {

          });
        },
        child: Icon(Icons.refresh_outlined),
        backgroundColor: Colors.white,
      ),
    );
  }
}
