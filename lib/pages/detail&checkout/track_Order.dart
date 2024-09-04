
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';

import '../../Local_Storage/Locall_Storage_Provider/StoreCredentials.dart';
import '../../models&ReadCollectionModel/SendOrderModel.dart';

class TrackOrder extends StatefulWidget {
  const TrackOrder({super.key});

  @override
  State<TrackOrder> createState() => _TrackOrderState();
}

class _TrackOrderState extends State<TrackOrder> {

  Stream<OrderInfo> trackOrder(int id, String phoneNumber) {
    return FirebaseFirestore.instance
        .collection('OrdersCollection')
        .where('vendorId', isEqualTo: id)
        .where('phoneNumber', isEqualTo: phoneNumber)
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
  Future<void> switchDelivered(BuildContext context, int id, String phoneNumber, bool isDelivered, ) async {
    final CollectionReference collectionRef = FirebaseFirestore.instance.collection('OrdersCollection');

    try {
      // First, get the documents that match the criteria
      QuerySnapshot querySnapshot = await collectionRef
          .where('vendorId', isEqualTo: id)
          .where('phoneNumber', isEqualTo: phoneNumber)
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
            stream: trackOrder(54348,Provider.of<LocalStorageProvider>(context, listen: false)
                .phoneNumber),
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
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
Text('Order progress...', style: TextStyle(color: Colors.blueGrey, fontSize: 25, fontWeight: FontWeight.bold),),
              /// ORDER RECEIVED
              Padding(padding: EdgeInsets.all(8),
              child: ImageIcon(AssetImage(('assets/Icon/orderReceived.png'),), size: 60,color: Colors.green,),
              ),
              Text('Order Sent', style: TextStyle(color: Colors.green, fontSize: 10.spMin, fontWeight: FontWeight.bold),),
 SizedBox(height: 10.h,),
              Icon(Icons.arrow_downward, color: Colors.green,),
              //SizedBox(height: 10.h,),

              ///ORDER SERVED
              Padding(padding: EdgeInsets.all(8),
                child: ImageIcon(AssetImage(('assets/Icon/orderServed.png'),), size: 60,color:Order!.served?Colors.green: Colors.red,),
              ),
              Text('Order Served', style: TextStyle(color: Order.served?Colors.green: Colors.red, fontSize: 10.spMin, fontWeight: FontWeight.bold),),
              SizedBox(height: 10.h,),
              Icon(Icons.arrow_downward, color: Order.served?Colors.green: Colors.red,),
             // SizedBox(height: 10.h,),

             /// ORDER GIVEN TO COURIER
              Padding(padding: EdgeInsets.all(8),
                child: ImageIcon(AssetImage(('assets/Icon/courier.png'),), size: 60,color:Order.courier?Colors.green: Colors.red,),
              ),
              Text(' Courier almost at your location', style: TextStyle(color: Order.courier?Colors.green: Colors.red, fontSize: 10.spMin, fontWeight: FontWeight.bold),),
              SizedBox(height: 10.h,),
              Icon(Icons.arrow_downward, color: Order.courier?Colors.green: Colors.red,),
              //SizedBox(height: 10.h,),

              /// ORDER COMPLETE
              Padding(padding: EdgeInsets.all(8),
                child: ImageIcon(AssetImage(('assets/Icon/orderComplete.png'),), size: 70,color: Order.delivered?Colors.green: Colors.red,),
              ),
              Text(' Delivered ', style: TextStyle(color: Order.delivered?Colors.green: Colors.red, fontSize: 10.spMin, fontWeight: FontWeight.bold),),
              SizedBox(height: 10.h,),

Material(  borderRadius: BorderRadius.circular(10),
    color: Colors.white,
    elevation: 3,
    child: TextButton(onPressed: (){

      ///
      ///
      ///
      /// DON'T FORGET TO USE THE ID IMPORTED FROM THE VENDOR HERE ALSO
      ///
      ///
      ///
      switchDelivered(context, 54348,Provider.of<LocalStorageProvider>(context, listen: false)
          .phoneNumber,true );

    }, child: Text('Done', style: TextStyle(color: Colors.green, fontWeight: FontWeight.bold,letterSpacing: 3),)))







            ],),
        );}
        })
        ,
      ),
    );
  }
}
