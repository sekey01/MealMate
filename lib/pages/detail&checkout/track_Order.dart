
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:easy_url_launcher/easy_url_launcher.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:lottie/lottie.dart';
import 'package:mealmate/Local_Storage/Locall_Storage_Provider/storeOrderModel.dart';
import 'package:mealmate/components/CustomLoading.dart';
import 'package:provider/provider.dart';
import 'package:rflutter_alert/rflutter_alert.dart';
import '../../Courier/courierInit.dart';
import '../../Courier/courier_model.dart';
import '../../Local_Storage/Locall_Storage_Provider/StoreCredentials.dart';
import '../../components/Notify.dart';
import '../../models&ReadCollectionModel/SendOrderModel.dart';

class TrackOrder extends StatefulWidget {
  final String vendorId;
  final DateTime time;
  final String restaurant;
  final adminEmail;
  final adminContact;
  const TrackOrder({super.key,required this.vendorId,required this.time, required this.restaurant, required this.adminEmail,required this.adminContact} );

  @override
  State<TrackOrder> createState() => _TrackOrderState();
}

class _TrackOrderState extends State<TrackOrder> {

  Stream<int> countdownTimer(int start) async* {
    for (int i = start; i >= 0; i--) {
      await Future.delayed(Duration(seconds: 1));
      yield i;
    }
  }

  Stream<OrderInfo> trackOrder(String id, String phoneNumber, DateTime time) {
    return FirebaseFirestore.instance
        .collection('OrdersCollection')
        .where('vendorId', isEqualTo: id)
        .where('phoneNumber', isEqualTo: phoneNumber)
        .where('time', isEqualTo: time )
    ///token id is the Id given to every user when he or she signs up or logs in
    ///
        //.Where('tokenid',isEqualTo: tokenid)
        .limit(1)
        .snapshots()
        .map((snapshot) {
      if (snapshot.docs.isNotEmpty) {
        final doc = snapshot.docs.first;
        return OrderInfo.fromMap(doc.data(), doc.id);
      } else {
        throw Exception("No matching order found");

      }
    })
        .handleError((error) {
      print("Error in stream: $error");
      throw error; // Re-throw the error to be handled by StreamBuilder
    })
        .where((orderInfo) => orderInfo != null); // This line is technically unnecessary now, but kept for safety
  }

/// THIS CHANGES TOGGLES THE BOOL OF DELIVERED TO TRUE AND CHANGES THE INCOMPLETE ORDER FROM THE ADMIN TO TRUE AND ALERTS THE ADMIN THAT THE BUYER HAS RECEIVED
  /// THE FOOD OR ITEM 😊😊😊😊😊😊😊😊😊
  Future<void> switchDelivered(BuildContext context, String id, String phoneNumber, bool isDelivered,DateTime time ) async {
    final CollectionReference collectionRef = FirebaseFirestore.instance.collection('OrdersCollection');

    try {
      // First, get the documents that match the criteria
      QuerySnapshot querySnapshot = await collectionRef
          .where('vendorId', isEqualTo: id)
          .where('phoneNumber', isEqualTo: phoneNumber)
      .where('time', isEqualTo:time )
          .get();

      // Check if any documents were found
      if (querySnapshot.docs.isEmpty) {
        print('No matching documents found');
        return;
      }

      // Update each matching document
      for (QueryDocumentSnapshot doc in querySnapshot.docs) {
        await doc.reference.update({'delivered': isDelivered});
      }

      print('isDelivered updated successfully');
    } catch (e) {
      print('Error updating document(s): $e');
      // You might want to show an error message to the user here
    }
  }
  @override
  Widget build(BuildContext context) {

    return  Scaffold(
      appBar: AppBar(title: RichText(text: TextSpan(
          children: [
            TextSpan(text: "Tracking ", style: TextStyle(color: Colors.black, fontSize: 20.spMin, fontWeight: FontWeight.bold,fontFamily: 'Righteous')),
            TextSpan(text: "Order ...", style: TextStyle(color: Colors.deepOrangeAccent, fontSize: 20.spMin, fontWeight: FontWeight.bold,fontFamily: 'Righteous') ,),


          ]
      )),centerTitle: true,backgroundColor: Colors.white,titleTextStyle: TextStyle(color: Colors.blueGrey, fontSize: 20, fontWeight: FontWeight.bold),),
      body: SingleChildScrollView(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            StreamBuilder<OrderInfo>(
              ///
              ///
              ///
              /// I HAVE TO MOVE THE ADMIN ID HERE IN ORDER TO GET ACCESS TO THE ACTUAL DOCUMENT
              ///
              /// ALSO DON'T FORGET TO ADD THE TOKEN ID FOR MORE ACCURACY
              ///
              ///
              ///
              ///
                stream: trackOrder(widget.vendorId,Provider.of<LocalStorageProvider>(context, listen: false)
                    .phoneNumber, widget.time),
                builder: (context, snapshot){
              if(snapshot.connectionState == ConnectionState.waiting )
              { return Center(child: Text('Collecting Updates...', style: TextStyle(color: Colors.deepOrangeAccent, fontWeight: FontWeight.bold, fontSize: 20),));
              }
              else if (snapshot.hasError){return Center(child: Text('Please wait while we connect you...'),);
              }
              else if (!snapshot.hasData ) {
                return Center(
                  child: Text('Can not Track Order, call the restaurant ...'),
                );
              } else {
            final Order = snapshot.data;

              return Center(

              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
             ///MEALMATE HERE
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        ImageIcon(AssetImage('assets/Icon/cedi.png'),size: 20.sp,color: Colors.deepOrangeAccent,),
                        Text( '${Order?.price.toString()}''0', style: TextStyle(color: Colors.black, fontSize: 15.spMin, fontWeight: FontWeight.bold)),

                      ],
                    ),
                  ),

                  ///VENDOR CONTACT
                  ///


                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: GestureDetector(
                      onTap: () async{
                        ///THIS IS THE CALL FUNCTION TO CALL THE VENDOR
                        EasyLauncher.call(number: widget.adminContact.toString());
                      },
                      child: Center(
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,

                          children: [

                            Text('Tap here to Call Vendor ', style:TextStyle(color: Colors.blueGrey, fontSize: 15.sp, fontFamily: 'Poppins') ,),
                            ImageIcon(AssetImage('assets/Icon/customer-service.png'),size: 25.sp,color: Colors.green,)
                          ],
                        ),
                      ),
                    ),
                  ),
            Text('Order In progress...', style: TextStyle(color: Colors.blueGrey, fontSize: 25, fontWeight: FontWeight.bold,fontFamily: 'Righteous'),),

                  ///TIMER
                  Padding(padding: EdgeInsets.all(16), child: CustomLoGoLoading(),),

                  StreamBuilder<int>(
                    stream: countdownTimer(90), // Countdown from 60 seconds
                    builder: (context, snapshot) {
                      if (snapshot.connectionState == ConnectionState.waiting) {
                        return Text(
                          'Starting...',
                          style: TextStyle(fontSize: 48, fontWeight: FontWeight.bold),
                        );
                      } else if (snapshot.hasData) {
                        return Padding(
                          padding: const EdgeInsets.all(16.0),
                          child: RichText(textAlign: TextAlign.center,text: TextSpan(
                              children: [
                                TextSpan(text: " Order will be served in :  ", style: TextStyle(color: Colors.blueGrey, fontSize: 10.sp,)),
                                TextSpan(text: "${snapshot.data} seconds \n ", style: TextStyle(color: Colors.deepOrangeAccent, fontSize: 15.sp,fontWeight: FontWeight.bold,fontFamily: 'Righteous')),
                                TextSpan(text: "if the Order Served  Icon is not ticked green, try calling the vendor ", style: TextStyle(color: Colors.blueGrey, fontSize: 10.sp,fontFamily: 'Poppins')),


                              ]
                          )),
                        );
                      } else if (snapshot.hasError) {
                        return Text(
                          'Error: ${snapshot.error}',
                          style: TextStyle(fontSize: 48, fontWeight: FontWeight.bold),
                        );
                      } else {
                        return Text(
                          'Done!',
                          style: TextStyle(fontSize: 48, fontWeight: FontWeight.bold),
                        );
                      }
                    },
                  ),
                  /// ORDER RECEIVED
                  Padding(padding: EdgeInsets.all(8),
                  child: ImageIcon(AssetImage(('assets/Icon/orderReceived.png'),), size: 80,color: Colors.green,),
                  ),
                  Text('Order Sent', style: TextStyle(color: Colors.green, fontSize: 10.spMin, fontWeight: FontWeight.bold),),
             SizedBox(height: 10.h,),
                  Icon(Icons.arrow_downward, color: Colors.green,),
                  //SizedBox(height: 10.h,),

                  ///ORDER SERVED
                  Padding(padding: EdgeInsets.all(8),
                    child: ImageIcon(AssetImage(('assets/Icon/orderServed.png'),), size: Order!.served?80:30,color:Order.served?Colors.green: Colors.grey,),
                  ),
                  Text('Order Served', style: TextStyle(color: Order.served?Colors.green: Colors.grey, fontSize: 10.spMin, fontWeight: FontWeight.bold),),
                  SizedBox(height: 10.h,),
                  Icon(Icons.arrow_downward, color: Order.served?Colors.green: Colors.grey,),
                 // SizedBox(height: 10.h,),

                 /// ORDER GIVEN TO COURIER
                  Padding(padding: EdgeInsets.all(8),
                    child: Column(
                      children: [
                        Builder(
                            builder: (context) {
                              return FutureBuilder(future: getCourierDetails(context, Order.CourierId.toString()),
                                  builder: (context,snapshot){
                                    if(snapshot.connectionState == ConnectionState.waiting){
                                      return CustomLoGoLoading();
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
                                                blurRadius: 2.0,
                                              ),
                                            ],
                                          ),
                                          child: Badge(
                                            backgroundColor: Colors.red,
                                            label: Text('Courier On his way...', style: TextStyle(color: Colors.white, fontSize: 10.sp, fontWeight: FontWeight.bold),),
                                            alignment: Alignment.topCenter,
                                            child: Column(
                                              children: [
                                                ListTile(
                                                  leading: CircleAvatar(radius: 30.r,backgroundImage: NetworkImage(courier.CourierGhanaCardPictureUrl),),
                                                  title: Text(courier.CourierName,style: TextStyle(color: Colors.black,fontWeight: FontWeight.bold,fontSize: 15.sp,fontFamily: 'Righteous'),),
                                                  subtitle: Text(courier.CourierEmail,style: TextStyle(color: Colors.black,fontWeight: FontWeight.bold,fontSize: 10.sp, fontFamily: 'Poppins'),),
                                                  trailing: courier.isCourierOnline ? LottieBuilder.asset('assets/Icon/online.json', height: 50.h, width: 30.w,): Icon(Icons.offline_bolt, color: Colors.red),

                                                ),
                                                InkWell(
                                                  onTap: (){
                                                    //call the courier
                                                    EasyLauncher.call(number: courier.CourierContact.toString());
                                                  },
                                                  child: ListTile(
                                                    leading: Icon(Icons.call, color: Colors.green,),
                                                    title: Text('+233' + courier.CourierContact.toString(),style: TextStyle(color: Colors.black,fontWeight: FontWeight.bold,fontSize: 15.sp,fontFamily: 'Poppins'),),
                                                    subtitle: Text('Tap  to call courier',style: TextStyle(color: Colors.blueGrey,fontWeight: FontWeight.bold,fontSize: 12.sp, fontFamily: 'Poppins'),),

                                                  ),
                                                ),


                                              ],
                                            ),
                                          ),
                                        ),
                                      );
                                    }
                                    return Column(
                                      children: [
                                        ImageIcon(AssetImage(('assets/Icon/courier.png'),), size: 30,color:Order.courier?Colors.green: Colors.grey,),
                                        Text('Courier details will be displayed soon ...', style: TextStyle(color: Colors.grey,fontSize: 10,fontFamily: 'Poppins'),),
                                      ],
                                    );
                                  });
                            }
                        ),
                      ],
                    ),
                  ),
                  Text(' Courier almost at your location', style: TextStyle(color: Order.courier?Colors.green: Colors.grey, fontSize: 10.spMin, fontWeight: FontWeight.bold),),
                  SizedBox(height: 10.h,),
                  Icon(Icons.arrow_downward, color: Order.courier?Colors.green: Colors.grey,),
                  //SizedBox(height: 10.h,),

                  /// ORDER COMPLETE
                  Padding(padding: EdgeInsets.all(8),
                    child: ImageIcon(AssetImage(('assets/Icon/orderComplete.png'),), size: Order.delivered?80:30,color: Order.delivered?Colors.green: Colors.grey,),
                  ),
                  Text(' Order Delivered ', style: TextStyle(color: Order.delivered?Colors.green: Colors.grey, fontSize: 10.spMin, fontWeight: FontWeight.bold),),
                  SizedBox(height: 20.h,),



            Material(  borderRadius: BorderRadius.circular(10),
                color: Colors.green,
                elevation: 3,
                child: TextButton(onPressed: (){
                  if(
                  Order.courier && Order.served
                  ){
                    switchDelivered(context, widget.vendorId,Provider.of<LocalStorageProvider>(context, listen: false)
                        .phoneNumber,true,widget.time);
                    Alert(
                      context: context,
                      style: AlertStyle(
                        backgroundColor: Colors.deepOrangeAccent,
                        alertPadding: EdgeInsets.all(88),
                        isButtonVisible: true,
                        descStyle: TextStyle(
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                          fontSize: 15.sp,
                        ),
                      ),
                      desc: "Do you want to store order ? ",
                      buttons: [
                        DialogButton(
                          child: Text('Yes', style: TextStyle(color: Colors.deepOrangeAccent,fontWeight: FontWeight.bold),),
                          onPressed: () {
                            // print(DateTime.timestamp());
                            Provider.of<LocalStorageProvider>(context,listen: false).addOrder( StoreOrderLocally(id:widget.restaurant , item: Order.foodName, price: Order.price,time: DateTime.timestamp().toString()));
                            Navigator.pop(context);
                            Navigator.pop(context);
                            Navigator.pop(context);


                            // print('DATA STORED');
                          },
                          width: 100.w,
                        ),
                      ],
                    ).show();
                    Notify(context, 'Thanks for Using MealMate 😊', Colors.green);


                  } else{
                    Notify(context, 'Order Not received yet', Colors.red);
                  }




                }, child: Text('Order Received', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold,letterSpacing: 1,fontFamily: 'Righteous'),))),


            SizedBox(height: 30.h,)




                ],),
            );}
            }),
          ],
        ),
      )
      ,
    );
  }
}
