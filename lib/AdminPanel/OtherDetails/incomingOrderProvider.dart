import 'dart:async';
import 'dart:io';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';
import '../../models&ReadCollectionModel/SendOrderModel.dart';

class IncomingOrdersProvider extends ChangeNotifier {

  ///INITIALIZE VARIABLES AND STREAM CONTROLLERS
  int OrderedIndex = 0;
  int InCompleteOrderedIndex = 0;
  String TotalPrice = '0.00';



  final _connectivity = Connectivity();
  StreamController<List<OrderInfo>> _ordersController = StreamController<List<OrderInfo>>.broadcast();
  StreamController<List<OrderInfo>> _CompletedordersController = StreamController<List<OrderInfo>>.broadcast();

  Future<bool> _checkConnectivity() async {
    var connectivityResult = await _connectivity.checkConnectivity();
    return connectivityResult != ConnectivityResult.none;
  }


  /// FETCH INCOMPLETE OR CURRENT INCOMING ORDERS
  ///
  ///
  Stream<List<OrderInfo>> fetchOrders(dynamic id) {
    _startFetchingOrders(id);
    return _ordersController.stream;
  }

  void _startFetchingOrders(dynamic id) async {
    int retryCount = 0;
    const maxRetries = 3;
    const retryDelay = Duration(seconds: 60);

    while (true) {
      try {
        if (!await _checkConnectivity()) {
          throw SocketException('No internet connection');
        }

        // Ensure id is an int
        int vendorId = (id is int) ? id : int.tryParse(id.toString()) ?? 0;
        if (vendorId == 0) {
          throw FormatException('Invalid vendor ID: $id');
        }

        QuerySnapshot snapshot = await FirebaseFirestore.instance
            .collection('OrdersCollection')
            .where('vendorId', isEqualTo: vendorId)
            .where('delivered', isEqualTo: false)
            .get();

        List<OrderInfo> orders = snapshot.docs
            .map((doc) {
          try {
            return OrderInfo.fromMap(doc.data() as Map<String, dynamic>, doc.id);
          } catch (e) {
            // print('Error parsing order: $e');
            return null;
          }
        })
            .where((order) => order != null)
            .cast<OrderInfo>()
            .toList();

        InCompleteOrderedIndex  = orders.length;
        _ordersController.add(orders);

        retryCount = 0; // Reset retry count on successful fetch
        await Future.delayed(Duration(seconds: 15));
      } catch (e) {
        if (e is SocketException || e is FirebaseException || e is FormatException) {
          retryCount++;
          if (retryCount >= maxRetries) {
            _ordersController.addError('Failed to fetch orders after $maxRetries attempts');
            //  print('MAX ENTRIES REACHED');
            return;
          }
          print('Error fetching orders, retrying in ${retryDelay.inSeconds} seconds...');
          await Future.delayed(retryDelay);
        } else {
          _ordersController.addError('An unexpected error occurred: $e');
          //print('ERROR: $e');
          return;
        }
      }
    }
  }









/// FETCH COMPLETED  ORDERS
///
///
///
  Stream<List<OrderInfo>> fetchCompleteOrders(dynamic id) {
    _startFetchingCompleteOrders(id);
    return _CompletedordersController.stream;
  }
  void _startFetchingCompleteOrders(dynamic id) async {
    int retryCount = 0;
    const maxRetries = 3;
    const retryDelay = Duration(seconds: 60);

    while (true) {
      try {
        if (!await _checkConnectivity()) {
          throw SocketException('No internet connection');
        }

        // Ensure id is an int
        int vendorId = (id is int) ? id : int.tryParse(id.toString()) ?? 0;
        if (vendorId == 0) {
          throw FormatException('Invalid vendor ID: $id');
        }

        QuerySnapshot snapshot = await FirebaseFirestore.instance
            .collection('OrdersCollection')
            // set two conditions to get the completed orders
            .where('vendorId', isEqualTo: vendorId)
            .where('delivered', isEqualTo: true)

            .get();

        List<OrderInfo> orders = snapshot.docs
            .map((doc) {
          try {
            return OrderInfo.fromMap(doc.data() as Map<String, dynamic>, doc.id);
          } catch (e) {
            // print('Error parsing order: $e');
            return null;
          }
        })
            .where((order) => order != null)
            .cast<OrderInfo>()
            .toList();

        OrderedIndex = orders.length;
        _CompletedordersController.add(orders);

        retryCount = 0; // Reset retry count on successful fetch
        await Future.delayed(Duration(seconds: 15));
      } catch (e) {
        if (e is SocketException || e is FirebaseException || e is FormatException) {
          retryCount++;
          if (retryCount >= maxRetries) {
            _CompletedordersController.addError('Failed to fetch orders after $maxRetries attempts');
            //  print('MAX ENTRIES REACHED');
            return;
          }
          print('Error fetching orders, retrying in ${retryDelay.inSeconds} seconds...');
          await Future.delayed(retryDelay);
        } else {
          _CompletedordersController.addError('An unexpected error occurred: $e');
          //print('ERROR: $e');
          return;
        }
      }
    }
  }



  @override
  void dispose() {
    _ordersController.close();
    super.dispose();
  }


}