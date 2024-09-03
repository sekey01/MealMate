import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:mealmate/AdminPanel/Pages/IncomingOrdersPage.dart';

import '../../models&ReadCollectionModel/SendOrderModel.dart';

class IncomingOrdersProvider extends ChangeNotifier{

late bool gotIncomingOrdersIndex = false ;

  /// Function to read all admin uploads based on the ID provided
  Stream<List<OrderInfo>> fetchOrders(int id) async *{
    int retryCount = 1;
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

        yield orders;
        gotIncomingOrdersIndex = true;
        await Future.delayed(Duration(seconds: 2));
        notifyListeners();

      } on SocketException catch (e) {
        attempt++;
        if (attempt >= retryCount) {
         // print("Internet Problem: $e");
          yield <OrderInfo>[];
        }
        await Future.delayed(Duration(seconds: 15)); // wait before retrying
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