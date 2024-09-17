import 'dart:async';
import 'dart:math';

import 'package:card_loading/card_loading.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:mealmate/UserLocation/LocationProvider.dart';
import 'package:provider/provider.dart';
import 'package:rflutter_alert/rflutter_alert.dart';

import '../../Local_Storage/Locall_Storage_Provider/StoreCredentials.dart';
import '../../components/Notify.dart';
import '../../models&ReadCollectionModel/SendOrderModel.dart';
import '../../models&ReadCollectionModel/cartmodel.dart';
import '../../models&ReadCollectionModel/sendOrderFunctionProvider.dart';
import 'orderSent.dart';

class DetailedCard extends StatefulWidget {
  final String imgUrl;
  final String restaurant;
  final String foodName;
  final double price;
  final String location;
  final int vendorid;
  final String time;
  final double latitude;
  final double longitude;
  final String adminEmail;
  final int adminContact;



  DetailedCard({
    required this.imgUrl,
    required this.restaurant,
    required this.foodName,
    required this.price,
    required this.location,
    required this.vendorid,
    required this.time,
    required this.latitude,
    required this.longitude,
    required this.adminEmail,
    required this.adminContact,

  });

  @override



  _DetailedCardState createState() => _DetailedCardState();
}

class _DetailedCardState extends State<DetailedCard> {



  final Completer<GoogleMapController> _controller =
      Completer<GoogleMapController>();
  double tPrice = 0.0;
  TextEditingController messageController = TextEditingController();

  @override
  void initState() {
    super.initState();
    tPrice = widget.price;

  }

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,

      body: SingleChildScrollView(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Container(
              color: Colors.white,
              height: 200.h,
              width: 350.h,
              child: widget.imgUrl.isEmpty
                  ? Center(
                      child: Icon(
                        Icons.image_not_supported_outlined,
                        color: Colors.deepOrange,
                        size: 120.sp,
                      ),
                    )
                  : ClipRRect(
                      borderRadius: BorderRadius.circular(13),
                      child: Image(
                        fit: BoxFit.fill,
                        image: NetworkImage(widget.imgUrl),
                        height: 90.h,
                        width: 120.w,
                      ),
                    ),
            ),
            SizedBox(height: 10.h),
            Text(
              widget.restaurant,
              style: TextStyle(
                fontSize: 20.sp,
                fontWeight: FontWeight.w500,
                color: Colors.black,
                letterSpacing: 1,
              ),
            ),
            SizedBox(height: 5.h),
            Text(
              widget.foodName,
              style: TextStyle(
                fontSize: 15.sp,
                fontWeight: FontWeight.w600,
                color: Colors.black,
                letterSpacing: 2,
              ),
            ),
            Text(
              'GHC ${widget.price}0',
              style: TextStyle(
                fontSize: 20.sp,
                letterSpacing: 3,
                fontWeight: FontWeight.bold,
                color: Colors.deepOrangeAccent,
              ),
            ),
            SizedBox(height: 10.h),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      Icons.location_on,
                      color: Colors.deepOrangeAccent,
                      size: 15.sp,
                    ),
                    SizedBox(width: 10.h),
                    Text(
                      widget.location,
                      style: TextStyle(
                        color: Colors.deepOrangeAccent,
                        fontSize: 15.sp,
                        overflow: TextOverflow.ellipsis,
                        letterSpacing: 3,
                      ),
                    ),
                  ],
                ),
                SizedBox(width: 10.h),
              ],
            ),
            SizedBox(height: 20.h),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      Icons.timelapse_rounded,
                      color: Colors.black,
                    ),
                    Text(
                      widget.time,
                      style: TextStyle(
                        color: Colors.black,
                        fontSize: 15.sp,
                      ),
                    ),
                    SizedBox(width: 10),
                  ],
                ),
                SizedBox(width: 15.w),
                Icon(
                  Icons.phone_callback_outlined,
                  color: Colors.black,
                ),
                Text(
                  widget.adminContact.toString(),
                  style: TextStyle(
                    color: Colors.deepOrangeAccent,
                    fontSize: 15.sp,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
            SizedBox(height: 10.h),
            Consumer<CartModel>(
              builder: (context, CartModel, child) {
                tPrice = CartModel.getQuantity * widget.price;
                return Text(
                  'Total: GHC${tPrice}0',
                  style: TextStyle(
                    color: Colors.red,
                    fontSize: 20.sp,
                    fontWeight: FontWeight.bold,
                  ),
                );
              },
            ),
            SizedBox(height: 10),
            Consumer<CartModel>(
              builder: (context, value, child) => ElevatedButton(
                style: ElevatedButton.styleFrom(
                  elevation: 3,
                  backgroundColor: Colors.deepOrangeAccent,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
                onPressed: () {
                  value.add(CartFood(
                    imgUrl: widget.imgUrl,
                    restaurant: widget.restaurant,
                    foodName: widget.foodName,
                    price: widget.price,
                    id: widget.vendorid,
                  ));

                  Alert(
                    context: context,
                    style: AlertStyle(
                      backgroundColor: Colors.transparent,
                      alertPadding: EdgeInsets.all(88),
                      isButtonVisible: true,
                      descStyle: TextStyle(
                        color: Colors.green,
                        fontSize: 15,
                      ),
                    ),
                    desc: "Food added to Cart",
                    buttons: [
                      DialogButton(
                        child: CardLoading(
                          height: 25,
                          child: Text(
                            '  Okay  ',
                            style: TextStyle(color: Colors.deepOrange),
                          ),
                        ),
                        onPressed: () => Navigator.pop(context),
                        width: 100,
                      ),
                    ],
                  ).show();
                },
                child: Text(
                  'Add to Cart',
                  style: TextStyle(color: Colors.white,fontWeight: FontWeight.bold),
                ),
              ),
            ),
            SizedBox(height: 20.h),
            Consumer<CartModel>(
              builder: (context, value, child) => Container(
                margin: EdgeInsets.all(10),
                height: 700.h,
                width: double.infinity,
                child: Center(
                  child: Column(
                    children: [
                      SizedBox(height: 5),

                      ///INCREMENT AND DECREEMENT BUTTONS
                      ///
                      ///
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          GestureDetector(
                            onTap: () {
                              value.decrementQuantity();
                            },
                            child: Material(
                              color: Colors.deepOrangeAccent,
                              borderRadius: BorderRadius.circular(7),
                              elevation: 3,
                              child: Text(
                                '  -  ',
                                style: TextStyle(
                                  fontSize: 20.sp,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.white,
                                ),
                              ),
                            ),
                          ),
                          SizedBox(width: 15.w),
                          Material(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(7),
                            elevation: 3,
                            child: Text(
                              value.getQuantity.toString(),
                              style: TextStyle(
                                fontSize: 20.sp,
                                letterSpacing: 3,
                                fontWeight: FontWeight.bold,
                                color: Colors.black,
                              ),
                            ),
                          ),
                          SizedBox(width: 15.w),
                          GestureDetector(
                            onTap: () {
                              value.incrementQuantity();
                            },
                            child: Material(
                              color: Colors.deepOrangeAccent,
                              borderRadius: BorderRadius.circular(7),
                              elevation: 3,
                              child: Text(
                                '  +  ',
                                style: TextStyle(
                                  fontSize: 20.sp,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.white,
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                      SizedBox(height: 15.h),
                      ///MAP
                      ///
                      ///
                      Padding(
                        padding: const EdgeInsets.all(4.0),
                        child: Material(
                          borderRadius: BorderRadius.circular(20),
                          color: Colors.white,
                          ///MAP CONATAINER
                          child: Container(
                            decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(10),
                                border: Border.all(
                                    color: Colors.black,
                                    style: BorderStyle.solid)),
                            height: 260.h,
                            width: double.infinity,

                            ///MAP HERE
                            ///
                            child: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: FutureBuilder(
                                  future: Provider.of<LocationProvider>(context,
                                          listen: false)
                                      .determinePosition(),
                                  builder: (context, snapshot) {
                                    if (snapshot.hasData) {
                                      return GoogleMap(
                                        markers: {
                                          Marker(
                                              markerId: MarkerId('User'),
                                              visible: true,
                                              position: LatLng(
                                                  widget.latitude,
                                                  widget.longitude)), 
                                        },
                                        circles: Set(),
                                        mapToolbarEnabled: true,
                                        padding: EdgeInsets.all(12),
                                        scrollGesturesEnabled: true,
                                        zoomControlsEnabled: true,
                                        myLocationEnabled: true,
                                        myLocationButtonEnabled: true,
                                        mapType: MapType.normal,
                                        onMapCreated:
                                            (GoogleMapController controller) {
                                          _controller.complete(_controller
                                              as FutureOr<GoogleMapController>?);
                                        },
                                        initialCameraPosition: CameraPosition(
                                          bearing: 192.8334901395798,
                                          target: LatLng(
                                              Provider.of<LocationProvider>(
                                                      context,
                                                      listen: false)
                                                  .Lat,
                                              Provider.of<LocationProvider>(
                                                      context,
                                                      listen: false)
                                                  .Long),
                                          tilt: 9.440717697143555,
                                          zoom: 11.151926040649414,
                                        ),
                                      );
                                    }
                                    return Text(
                                      'locating you...',
                                      style: TextStyle(color: Colors.black),
                                    );
                                  }),
                            ),

                          ),
                        ),
                      ),
                   /*   Padding(padding: EdgeInsets.all(8),
                        child: Builder(builder: (context) {
                          Provider.of<LocationProvider>(context,listen: false).calculateDistance(
                              LatLng(widget.latitude,widget.longitude),
                              LatLng(Provider.of<LocationProvider>(context).Lat, Provider.of<LocationProvider>(context).Lat)
                          );
                          return Text('data',style: TextStyle(color: Colors.black),);
                        },

                        )
                      ),*/


                      /// TEXTFIELDFOR USER TO ENTER EXTRA INFORMATION
                      ///
                      ///
                      ///
                      Padding(padding: EdgeInsets.all(8),
                        child: Text('Note:  Always make sure the map loads before you Order; '
                            'Tap on the Red Marker  on the Map to see the distance between you the the vendor is less than 15 Km before ordering ...',
                          style: TextStyle(
                            fontSize: 10.sp,
                            color: Colors.black
                          ),),),
                      SizedBox(height: 30.h,),

                      Padding(
                        padding: const EdgeInsets.all(18.0),
                        child: TextField(
                          enableSuggestions: true,
                          scrollPadding: EdgeInsets.all(8),
                          scrollPhysics: BouncingScrollPhysics(),
                          style: TextStyle(color: Colors.black),
                          decoration: InputDecoration(
                            label: Text('Leave a message here ...'),
                            labelStyle: TextStyle(
                              color: Colors.black,
                              fontSize: 15.sp,
                            ),
                            filled: true,
                            fillColor: Colors.grey.shade200,
                            hintText: 'Leave a message for Us / other details here... ',
                            hintStyle: TextStyle(
                              color: Colors.black,
                              fontSize: 11.sp,
                            ),
                            border: OutlineInputBorder(
                              borderSide: BorderSide(),
                            ),
                          ),
                          controller: messageController,
                        ),
                      ),

SizedBox(height: 30.h,),
                      Padding(padding: EdgeInsets.all(8),
                        child: Text('Note:  Make sure your number displays bellow; '
                            'Go to your profile page to add number ...',
                          style: TextStyle(
                              fontSize: 10.sp,
                              color: Colors.black
                          ),),),

                      SizedBox(height: 30.h,),

                      Text(
                        " Your Telephone: ${Provider.of<LocalStorageProvider>(context, listen: false).phoneNumber}",
                        style: TextStyle(
                          color: Colors.black,
                        ),
                      ),
                      SizedBox(height: 15.h),
                      ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          elevation: 3,
                          backgroundColor: Colors.deepOrangeAccent,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                        ),
                        onPressed: () {
    if(!Provider.of<LocalStorageProvider>(context, listen: false).phoneNumber.isEmpty){
      DateTime time = DateTime.now();
      //  print(time);

      Provider.of<SendOrderProvider>(context, listen: false)
          .sendOrder(
        OrderInfo(
            time: time,
            foodName: widget.foodName,
            quantity: Provider.of<CartModel>(context, listen: false).getQuantity,
            price: widget.price,
            message: messageController.text.toString(),
            Latitude: Provider.of<LocationProvider>(context, listen: false).Lat,
            Longitude: Provider.of<LocationProvider>(context, listen: false).Long,
            phoneNumber: Provider.of<LocalStorageProvider>(context, listen: false).phoneNumber,
            vendorId: widget.vendorid,
            served: false,
            courier : false,
            delivered: false,
            adminEmail: widget.adminEmail,
            adminContact: widget.adminContact
        ),
      );

      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => OrderSent(vendorId: widget.vendorid,time: time, restaurant: widget.restaurant,adminEmail:  widget.adminEmail,adminContact:  widget.adminContact),
        ),
      );


    } else {
    Notify(context, 'Please add Telephone number', Colors.red);}

  },

                        child: Text(
                          'CheckOut',
                          style:
                              TextStyle(color: Colors.white, fontSize: 20.spMin , fontWeight: FontWeight.bold),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
