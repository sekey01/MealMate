import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';

import '../../models&ReadCollectionModel/SendOrderModel.dart';

class IncomingOrdersProvider extends ChangeNotifier{

 int OrderedIndex = 0 ;

  /// Function to read all admin uploads based on the ID provided
  Stream<List<OrderInfo>> fetchOrders(int id) async *{

    int retryCount = 3;
    int attempt = 0;
    while (attempt < retryCount) {
      try {
        QuerySnapshot snapshot = (await FirebaseFirestore.instance
            .collection('OrdersCollection')
            .where('vendorId', isEqualTo: id)

            .get()) as QuerySnapshot<Object?>;
        List<OrderInfo> orders = snapshot.docs
            .map((doc) =>
            OrderInfo.fromMap(doc.data() as Map<String, dynamic>, doc.id))
            .toList();


          OrderedIndex = orders.length;

        yield orders;
        await Future.delayed(Duration(seconds: 30));
       // gotIncomingOrdersIndex = true;

        notifyListeners();

      } on SocketException {
        attempt++;
        if (attempt >= retryCount) {
         // print("Internet Problem: $e");
          yield <OrderInfo>[];
        }
        await Future.delayed(Duration(seconds: 5)); // wait before retrying
      } catch (e) {
        //print("Error fetching food items: $e");
        yield <OrderInfo>[];
      }
    }

    yield  <OrderInfo>[];
  }

  void notifyListeners() {
    super.notifyListeners();
  }
}