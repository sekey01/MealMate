import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/cupertino.dart';
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


}
