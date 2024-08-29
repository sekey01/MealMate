import 'dart:async';
import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:mealmate/AdminPanel/OtherDetails/ID.dart';
import 'package:mealmate/UserLocation/LocationProvider.dart';
import 'package:mealmate/components/CustomLoading.dart';
import 'package:mealmate/components/NoFoodFound.dart';
import 'package:provider/provider.dart';

import '../../models&ReadCollectionModel/SendOrderModel.dart';

class IncomingOrders extends StatefulWidget {
  const IncomingOrders({super.key});

  @override
  State<IncomingOrders> createState() => _IncomingOrdersState();
}

class _IncomingOrdersState extends State<IncomingOrders> {
  //@override
  final Completer<GoogleMapController> _Usercontroller = Completer<GoogleMapController>();

  // Function to read all admin uploads based on the ID provided
  Future<List<OrderInfo>> fetchOrders(id) async {
    int retryCount = 3;
    int attempt = 0;
    while (attempt < retryCount) {
      try {
        QuerySnapshot snapshot = (await FirebaseFirestore.instance
            .collection('OrdersCollection')
            .where('vendorId', isEqualTo: id)
            .get()) as QuerySnapshot<Object?>;
        return snapshot.docs
            .map((doc) =>
                OrderInfo.fromMap(doc.data() as Map<String, dynamic>, doc.id))
            .toList();
      } on SocketException catch (e) {
        attempt++;
        if (attempt >= retryCount) {
          print("Internet Problem: $e");
          return <OrderInfo>[];
        }
        await Future.delayed(Duration(seconds: 2)); // wait before retrying
      } catch (e) {
        print("Error fetching food items: $e");
        return <OrderInfo>[];
      }
    }
    return <OrderInfo>[];
  }

  @override
  Widget build(BuildContext context) {
    final adminId = Provider.of<AdminId>(context, listen: false).id;

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        titleTextStyle: TextStyle(
          letterSpacing: 3,
          fontSize: 20,
        ),
        backgroundColor: Colors.deepOrangeAccent.shade100,
        centerTitle: true,
        title: Consumer<AdminId>(
          builder: (context, value, child) {
            return Center(
              child: Text(
                'ID: ${value.id}',
                style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 15.sp,
                    color: Colors.black),
              ),
            );
          },
        ),
        actions: [
          IconButton(
            onPressed: () {
              setState(() {}); // Refresh the page
            },
            icon: Image(image: AssetImage('assets/Icon/refresh.png')),
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(4.0),
        child: FutureBuilder<List<OrderInfo>>(
          future: fetchOrders(adminId),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return Center(
                child: CustomLoGoLoading(),
              );
            } else if (snapshot.hasError) {
              return Center(child: Text('Error: Try again later'));
            } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
              return Center(
                child: noFoodFound(),
              );
            } else {
              return ListView.builder(
                itemCount: snapshot.data!.length,
                itemBuilder: (context, index) {
                  final Orders = snapshot.data![index];

                  return Material(
                    borderRadius: BorderRadius.circular(10),
                    color: Colors.white,
                    shadowColor: Colors.deepOrange,
                    elevation: 4,
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: ExpansionTile(
                        shape: Border.all(color: Colors.black),
                        textColor: Colors.black,
                        collapsedBackgroundColor: Colors.deepOrange.shade100,
                        collapsedTextColor: Colors.black,
                        backgroundColor: Colors.white,
                        trailing: Text(
                          "Quantity Ordered: ${Orders.quantity}",
                          style: TextStyle(
                            color: Colors.black,
                          ),
                        ),
                        title: Text(
                          ' ${Orders.foodName} ',
                          style: TextStyle(
                              fontWeight: FontWeight.bold, fontSize: 15),
                        ),
                        subtitle: Text(
                          '${Orders.time}',
                          style: TextStyle(
                              letterSpacing: 2,
                              fontWeight: FontWeight.w300,
                              fontSize: 14.sp),
                        ),
                        children: <Widget>[
                          ListTile(
                            title: FutureBuilder(
                                future: Provider.of<LocationProvider>(context,
                                        listen: false)
                                    .determinePosition(),
                                builder: (context, snapshot) {
                                  if (snapshot.hasData) {
                                    return Text(snapshot.data.toString(),
                                        style: TextStyle(
                                            overflow: TextOverflow.ellipsis,
                                            color: Colors.deepOrangeAccent,
                                            fontSize: 10.sp));
                                  }
                                  return Text(
                                    'Getting location of buyer...',
                                    style: TextStyle(color: Colors.black),
                                  );
                                }),
                          ),
                          ListTile(
                            leading: Text(
                                'Location : ${LatLng(Orders.Latitude, Orders.Longitude)}',
                                style: TextStyle(
                                  color: Colors.black,
                                  fontSize: 10.sp,
                                  fontWeight: FontWeight.bold,
                                )),
                            trailing: Text(
                              '${Orders.vendorId}',
                              style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 15.sp,
                                  color: Colors.black),
                            ),
                          ),
                          ListTile(
                            leading: Icon(
                              Icons.call,
                              color: Colors.black,
                            ),
                            titleTextStyle:
                                TextStyle(fontWeight: FontWeight.bold),
                            title: Text(
                              '${Orders.phoneNumber}',
                              style: TextStyle(color: Colors.black),
                            ),
                            subtitle: Text(
                              '${Orders.message}',
                              style: TextStyle(
                                  color: Colors.black, fontSize: 10.sp),
                            ),
                            trailing: Text(
                              'Total Price: GHC${Orders.price}',
                              style: TextStyle(
                                  color: Colors.black,
                                  fontSize: 10.sp,
                                  fontWeight: FontWeight.bold),
                            ),
                          ),
                          Container(
                              height: 200,
                              width: double.infinity,
                              child: GoogleMap(
                                liteModeEnabled: true,
                                compassEnabled: true,
                                mapToolbarEnabled: true,
                                padding: EdgeInsets.all(12),
                                scrollGesturesEnabled: true,
                                zoomControlsEnabled: true,
                                myLocationEnabled: true,
                                myLocationButtonEnabled: true,
                                mapType: MapType.normal,
                                onMapCreated: (GoogleMapController controller) {
                                  _Usercontroller.complete(_Usercontroller
                                      as FutureOr<GoogleMapController>?);
                                },
                                gestureRecognizers: Set(),
                                initialCameraPosition: CameraPosition(
                                  bearing: 192.8334901395799,
                                  target: LatLng(
                                    Orders.Latitude,
                                    Orders.Longitude,
                                  ),
                                  tilt: 9.440717697143555,
                                  zoom: 11.151926040649414,
                                ),
                              ))
                        ],
                      ),
                    ),
                  );
                },
              );
            }
          },
        ),
      ),
    );
  }
}
