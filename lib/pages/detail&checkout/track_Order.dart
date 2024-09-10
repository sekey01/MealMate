
import 'package:card_loading/card_loading.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:mealmate/Local_Storage/Locall_Storage_Provider/storeOrderModel.dart';
import 'package:mealmate/components/CustomLoading.dart';
import 'package:mealmate/components/Notify.dart';
import 'package:mealmate/pages/navpages/home.dart';
import 'package:provider/provider.dart';
import 'package:rflutter_alert/rflutter_alert.dart';

import '../../Local_Storage/Locall_Storage_Provider/StoreCredentials.dart';
import '../../models&ReadCollectionModel/SendOrderModel.dart';

class TrackOrder extends StatefulWidget {
  final int vendorId;
  final DateTime time;
  final String restaurant;
  const TrackOrder({super.key,required this.vendorId,required this.time, required this.restaurant} );

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

  Stream<OrderInfo> trackOrder(int id, String phoneNumber, DateTime time) {
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
  Future<void> switchDelivered(BuildContext context, int id, String phoneNumber, bool isDelivered,DateTime time ) async {
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

    return  Material(
      child: Scaffold(
        appBar: AppBar(title: Text('Track Order'),centerTitle: true,backgroundColor: Colors.white,titleTextStyle: TextStyle(color: Colors.blueGrey, fontSize: 20, fontWeight: FontWeight.bold),),
        body: StreamBuilder<OrderInfo>(
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
Text('Order progress...', style: TextStyle(color: Colors.blueGrey, fontSize: 25, fontWeight: FontWeight.bold),),

              ///TIMER
            /*  Padding(padding: EdgeInsets.all(16), child: CustomLoGoLoading(),),

              StreamBuilder<int>(
                stream: countdownTimer(60), // Countdown from 60 seconds
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return Text(
                      'Starting...',
                      style: TextStyle(fontSize: 48, fontWeight: FontWeight.bold),
                    );
                  } else if (snapshot.hasData) {
                    return Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: RichText(text: TextSpan(
                          children: [
                            TextSpan(text: "Order will be received in r", style: TextStyle(color: Colors.black, fontSize: 10.sp,)),
                            TextSpan(text: "${snapshot.data} seconds , ", style: TextStyle(color: Colors.deepOrangeAccent, fontSize: 20.sp,)),
                            TextSpan(text: "if the Order Served is not ticked green", style: TextStyle(color: Colors.black, fontSize: 10.sp,)),


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
              ),*/
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
                child: ImageIcon(AssetImage(('assets/Icon/courier.png'),), size: Order.courier?80:30,color:Order.courier?Colors.green: Colors.grey,),
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
    color: Colors.deepOrangeAccent,
    elevation: 3,
    child: TextButton(onPressed: (){


      ///
      ///
      ///
      /// DON'T FORGET TO USE THE ID IMPORTED FROM THE VENDOR HERE ALSO
      ///
      ///
      ///
     /* switchDelivered(context, widget.vendorId,Provider.of<LocalStorageProvider>(context, listen: false)
          .phoneNumber,true,widget.time);*/
      Notify(context, 'Thanks for Using MealMate 😊', Colors.green);

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


    }, child: Text('Received', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold,letterSpacing: 3),)))







            ],),
        );}
        })
        ,
      ),
    );
  }
}
