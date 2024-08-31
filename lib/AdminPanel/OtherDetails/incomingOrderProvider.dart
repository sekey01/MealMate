import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';

import '../../models&ReadCollectionModel/SendOrderModel.dart';

class IncomingOrdersProvider extends ChangeNotifier{
   int  IncomingOrdersIndex = 0;

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
        IncomingOrdersIndex = snapshot.docs.length;
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

}