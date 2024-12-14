import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
//import http
import 'package:http/http.dart' as http;


class Notification {
  final notificationId;
  final String notification;
  final String time;
  final String route;
  final String notificationImgUrl;


  Notification({
    required this.notificationId,
    required this.notification,
    required this.time,
    required this.route,
    required this.notificationImgUrl,
  });

  // Factory method to create a Notification from a Map
  factory Notification.fromFactory(Map<String, dynamic> data) {
    return Notification(
      notificationId: data['notificationId'] ?? '',
      notification: data['notification'] ?? '',
      time: data['time'] ??'',
      route: data['route'] ?? '',
      notificationImgUrl: data['notificationImgUrl'] ?? '',
    );
  }

  // Method to convert a Notification to a Map
  Map<String, dynamic> toMap() {
    return {
      'notificationId': notificationId,
      'notification': notification,
      'time': time,
      'route': route,
    };
  }
}

class NotificationProvider extends ChangeNotifier{

  int userNotificationLength = 0 ;
  int adminNotificationLength = 0 ;


  Future<List<Notification>> getUserNotifications() async {
    try {
      QuerySnapshot snapshot = await FirebaseFirestore.instance
          .collection('Notifications')
          .get();

      List<Notification> notifications = snapshot.docs
          .map((doc) => Notification.fromFactory(doc.data() as Map<String, dynamic>))
          .toList();
      userNotificationLength = notifications.length;
      return notifications;
    } catch (e) {
      print(e.toString());
      return [];
    }
  }

  Future<List<Notification>> getAdminNotifications() async {
    try {
      QuerySnapshot snapshot = await FirebaseFirestore.instance
          .collection('AdminNotifications')
          .get();

      List<Notification> adminNotifications = snapshot.docs
          .map((doc) => Notification.fromFactory(doc.data() as Map<String, dynamic>))
          .toList();

      adminNotificationLength = adminNotifications.length;
      return adminNotifications;
    } catch (e) {
      print(e.toString());
      return [];
    }
  }

  void requestNotificationPermissions() async {
    FirebaseMessaging messaging = FirebaseMessaging.instance;
    NotificationSettings settings = await messaging.requestPermission(
      alert: true,
      badge: true,
      sound: true,
    );

    if (settings.authorizationStatus == AuthorizationStatus.authorized) {
      print('User granted permission to receive notifications');
    } else {
      print('User declined or has not accepted permission');
    }
  }

  void configureFirebaseListeners() {
    FirebaseMessaging.onMessage.listen((RemoteMessage message) {
      print('Received a message while in the foreground!');
      print('Message data: ${message.data}');

      if (message.notification != null) {
        print('Message also contained a notification: ${message.notification}');
      }
    });

    FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) {
      print('Message clicked!');
    });
  }

 //subscribe to topic
  void subscribeToTopic(String topic) async {
    await FirebaseMessaging.instance.subscribeToTopic(topic);
    //print('Subscribed to $topic');
  }



  //send message with mNotify
  Future<void> sendSms(String to, String content) async {
    final String url = '${dotenv.env['SMS_URL']}';
    final String apiKey = '${dotenv.env['SMS_API_KEY']}';
    final String toNumber = to;
    final String message = content;
    final String senderId = 'MealMate';

    final Uri uri = Uri.parse('$url?key=$apiKey&to=$toNumber&msg=${Uri.encodeComponent(message)}&sender_id=$senderId');

    try {
      final response = await http.get(uri);

      if (response.statusCode == 200) {
        print('Message sent successfully');
        print('Response: ${response.body}');
      } else {
        print('Failed to send message: ${response.statusCode}');
        print('Response body: ${response.body}');
      }
    } catch (e) {
      print('Error sending message: $e');
    }
  }



}
