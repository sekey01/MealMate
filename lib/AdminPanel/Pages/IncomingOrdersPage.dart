import 'dart:async';
import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:lite_rolling_switch/lite_rolling_switch.dart';
import 'package:mealmate/AdminPanel/OtherDetails/ID.dart';
import 'package:mealmate/AdminPanel/OtherDetails/incomingOrderProvider.dart';
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
  @override
  final Completer<GoogleMapController> _Usercontroller = Completer<GoogleMapController>();



  @override
  Widget build(BuildContext context) {
    final adminId = Provider.of<AdminId>(context, listen: false).id;

    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      appBar: AppBar(
        automaticallyImplyLeading: false,
        leading: IconButton(onPressed: (){
          Navigator.pop(context);
        }, icon: Icon(Icons.arrow_back_ios), color: Colors.blueGrey,),
        titleTextStyle: TextStyle(
          letterSpacing: 3,
          fontSize: 20,
        ),
        backgroundColor: Colors.white,
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
            icon: Image(image: AssetImage('assets/Icon/refresh.png'), color: Colors.blueGrey,),
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(4.0),
        child: StreamBuilder<List<OrderInfo>>(
          stream: Provider.of<IncomingOrdersProvider>(context, listen: false).fetchOrders(adminId),
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
                  return Badge(
                    alignment: Alignment.topCenter,
                    backgroundColor: Colors.red,
                    label: Text('Incomplete Order', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),),
                    child: Padding(
                      padding: const EdgeInsets.all(4.0),
                      child: Material(
                        borderRadius: BorderRadius.circular(10),
                        color: Orders.served ? Colors.green : Colors.red,
                        shadowColor: Colors.green,
                        elevation: 2,
                        child: Padding(
                          padding: const EdgeInsets.all(4.0),
                          child: ExpansionTile(
                    
                            shape: Border.all(color: Colors.black),
                            textColor: Colors.black,
                            collapsedBackgroundColor: Colors.white,
                            collapsedTextColor: Colors.black,
                            backgroundColor: Colors.white,
                            trailing: Text(
                              "Quantity: ${Orders.quantity}",
                              style: TextStyle(
                                color: Colors.black,
                                fontWeight: FontWeight.bold
                              ),
                            ),
                            title: Text(
                              ' ${Orders.foodName} ',
                              style: TextStyle(
                                  fontWeight: FontWeight.bold, fontSize: 10.spMin),
                            ),
                            subtitle: Text(
                              '${Orders.time}',
                              style: TextStyle(
                                  letterSpacing: 2,
                                  fontWeight: FontWeight.w300,
                                  fontSize: 10.spMin),
                            ),
                            children: <Widget>[
                              ListTile(
                                title: FutureBuilder(
                                    future: Provider.of<LocationProvider>(context,
                                            listen: false)
                                        .getAddressFromLatLng(Orders.Latitude, Orders.Longitude),
                                    builder: (context, snapshot) {
                                      if (snapshot.hasData) {
                    
                                        return Text(snapshot.data.toString(),
                                            style: TextStyle(
                                                overflow: TextOverflow.ellipsis,
                                                color: Colors.deepOrangeAccent
                    
                    
                      ,
                                                fontSize: 10.sp));
                                      }
                                      return Text(
                                        'Getting location of buyer...',
                                        style: TextStyle(color: Colors.blueGrey, fontSize: 10.sp),
                                      );
                                    }),
                              ),
                              ListTile(
                                leading: Text(
                                    'Comment : ${Orders.message}',
                                    style: TextStyle(
                                      color: Colors.black,
                                      fontSize: 10.spMin,
                                     // fontWeight: FontWeight.bold,
                                    )),
                                trailing: Text(
                                  '${Orders.vendorId}',
                                  style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 10.sp,
                                      color: Colors.black),
                                ),
                              ),
                              ListTile(
                                leading: ImageIcon(AssetImage('assets/Icon/profile.png')),
                                titleTextStyle:
                                    TextStyle(fontWeight: FontWeight.bold),
                                title: Text(
                                  '${Orders.phoneNumber}',
                                  style: TextStyle(color: Colors.black, fontSize: 10.spMin, ),
                                ),
                                subtitle: Text(
                                  '${Orders.message}',
                                  style: TextStyle(
                                      color: Colors.black, fontSize: 10.spMin),
                                ),
                                trailing: Text(
                                  'Total Price: GHC${Orders.price}',
                                  style: TextStyle(
                                      color: Colors.black,
                                      fontSize: 10.spMin,
                                      fontWeight: FontWeight.bold),
                                ),
                              ),
                              ///GOOGLE MAP HERE 
                              ///
                              Padding(
                                padding: const EdgeInsets.all(4.0),
                                child: Container(
                                    height: 250.spMin,
                                    width: double.infinity,
                                    child: GoogleMap(
                                      //liteModeEnabled: true,
                                      compassEnabled: true,
                                      mapToolbarEnabled: true,
                                      padding: EdgeInsets.all(12),
                                      scrollGesturesEnabled: true,
                                      zoomControlsEnabled: true,
                                      myLocationEnabled: true,
                                      myLocationButtonEnabled: true,
                                      mapType: MapType.terrain,
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
                                    )),
                              ),
                    SizedBox(height: 10,),
                    
                    /// ROW FOR SERVED AND COURIER
                              ///
                    
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                    
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                        LiteRollingSwitch(
                          //initial value
                          value: false,
                          width: 120.spMin,
                          textOn: 'Served',
                          textOnColor: Colors.white,
                          textOff: 'Not-Served',
                          textOffColor: Colors.white,
                          colorOn: CupertinoColors.activeGreen,
                          colorOff: Colors.redAccent,
                          iconOn: Icons.done,
                          iconOff: Icons.remove_circle_outline,
                          textSize: 8.0,
                          onChanged: (bool state) {
                            print('Served');
                    
                            ///Use it to manage the different states
                            //print('Current State of SWITCH IS: $state');
                          },
                          onTap: () {
                          },
                          onDoubleTap: () {},
                          onSwipe: () {},
                        ), LiteRollingSwitch(
                          //initial value
                          value: false,
                          width: 120.spMin,
                          textOn: 'Courier',
                          textOnColor: Colors.white,
                          textOff: 'N-Courier',
                          textOffColor: Colors.white,
                          colorOn: CupertinoColors.activeGreen,
                          colorOff: Colors.redAccent,
                          iconOn: Icons.done,
                          iconOff: Icons.remove_circle_outline,
                          textSize: 8.0,
                          onChanged: (bool state) {
                            print('Given to Courier');
                    
                            ///Use it to manage the different states
                            //print('Current State of SWITCH IS: $state');
                          },
                          onTap: () {
                          },
                          onDoubleTap: () {},
                          onSwipe: () {},
                        ),
                      ],),
                    ),
                    
                            ],
                          ),
                        ),
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
