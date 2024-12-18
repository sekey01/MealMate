import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import '../../models&ReadCollectionModel/SendOrderModel.dart';
import 'package:http/http.dart' as http;
import 'package:emailjs/emailjs.dart' as emailjs;


class IncomingOrdersProvider extends ChangeNotifier {
  int OrderedIndex = 0;
  int InCompleteOrderedIndex = 0;
  String TotalPrice = '0.00';

  final _connectivity = Connectivity();
  final FirebaseMessaging _firebaseMessaging = FirebaseMessaging.instance;
  StreamController<List<OrderInfo>> _ordersController = StreamController<List<OrderInfo>>.broadcast();
  StreamController<List<OrderInfo>> _CompletedordersController = StreamController<List<OrderInfo>>.broadcast();

  IncomingOrdersProviderNotification() {
    _initializeFCM();
  }

  void _initializeFCM() {
    _firebaseMessaging.requestPermission();
    _firebaseMessaging.getToken().then((token) {
      print("FCM Token: $token");
      // Save the token to your server or use it as needed
    });

    FirebaseMessaging.onMessage.listen((RemoteMessage message) {
      //print('Received a message while in the foreground!');
     // print('Message data: ${message.data}');
      if (message.notification != null) {
       _firebaseMessaging.subscribeToTopic('all users');
        print('Message also contained a notification: ${message.notification}');
      }
    });

    FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) {
      print('A new onMessageOpenedApp event was published! $message.data');
    });
  }




  Future<bool> _checkConnectivity() async {
    var connectivityResult = await _connectivity.checkConnectivity();
    return connectivityResult != ConnectivityResult.none;
  }

  Stream<List<OrderInfo>> fetchOrders(String id) {
    _startFetchingOrders(id);
    return _ordersController.stream;
  }

  void _startFetchingOrders(String id) async {
    int retryCount = 0;
    const maxRetries = 2;
    const retryDelay = Duration(seconds: 60);

    while (true) {
      try {
        if (!await _checkConnectivity()) {
          throw SocketException('No internet connection');
        }

        QuerySnapshot snapshot = await FirebaseFirestore.instance
            .collection('OrdersCollection')
            .where('vendorId', isEqualTo: id)
            .where('delivered', isEqualTo: false)
            .get();

        List<OrderInfo> orders = snapshot.docs
            .map((doc) {
          try {
            return OrderInfo.fromMap(doc.data() as Map<String, dynamic>, doc.id);
          } catch (e) {
            return null;
          }
        })
            .where((order) => order != null)
            .cast<OrderInfo>()
            .toList();

        if (orders.length > InCompleteOrderedIndex) {
          _firebaseMessaging.subscribeToTopic('new_order');
        }

        InCompleteOrderedIndex = orders.length;
        _ordersController.add(orders);

        retryCount = 0;
        await Future.delayed(Duration(seconds: 60));
      } catch (e) {
        if (e is SocketException || e is FirebaseException || e is FormatException) {
          retryCount++;
          if (retryCount >= maxRetries) {
            _ordersController.addError('Failed to fetch orders after $maxRetries attempts');
            return;
          }
          await Future.delayed(retryDelay);
        } else {
          _ordersController.addError('An unexpected error occurred: $e');
          return;
        }
      }
    }
  }
  Stream<List<OrderInfo>> fetchCompleteOrders(String id) async* {
    const int maxRetries = 3;
    const Duration retryDelay = Duration(seconds: 45);

    int retryCount = 0;

    while (retryCount < maxRetries) {
      try {
        // Check for internet connectivity
        if (!await _checkConnectivity()) {
          throw SocketException('No internet connection');
        }

        // Fetch data from Firestore
        QuerySnapshot snapshot = await FirebaseFirestore.instance
            .collection('OrdersCollection')
            .where('vendorId', isEqualTo: id)
            .where('delivered', isEqualTo: true)
            .get();

        // Map Firestore documents to OrderInfo objects
        List<OrderInfo> orders = snapshot.docs
            .map((doc) {
          try {
            return OrderInfo.fromMap(doc.data() as Map<String, dynamic>, doc.id);
          } catch (e) {
            // Handle mapping errors gracefully
            return null;
          }
        })
            .where((order) => order != null)
            .cast<OrderInfo>()
            .toList();

        // Emit the orders to the stream
        yield orders;

        // Reset retry count after successful fetch
        retryCount = 0;

        // Wait before fetching again (e.g., polling every 60 seconds)
        await Future.delayed(Duration(seconds: 60));
      } catch (e) {
        // Handle specific retriable exceptions
        if (e is SocketException || e is FirebaseException || e is FormatException) {
          retryCount++;
          if (retryCount >= maxRetries) {
            // Emit an error if max retries are reached
            yield* Stream.error('Failed to fetch orders after $maxRetries attempts: $e');
            return;
          }
          await Future.delayed(retryDelay);
        } else {
          // Emit an error for unexpected exceptions and terminate
          yield* Stream.error('An unexpected error occurred: $e');
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