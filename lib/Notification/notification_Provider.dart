import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/cupertino.dart';


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



  Future<void> subscribeToTopic(String topic) async {
    final FirebaseMessaging _firebaseMessaging = FirebaseMessaging.instance;
    try {
      await _firebaseMessaging.subscribeToTopic(topic);
      print('Subscribed to $topic');
    } catch (e) {
      print('Failed to subscribe to $topic: $e');
    }
  }

/*  Future<void> sendMessageWithTwilio() async {
    var accountSid= 'AC475cf9a7b128d3f4b611052ac2ebc1ce';
   var authToken= 'c89360a6fa6028e8c240881c87e08515';
    var url = Uri.parse('https://api.twilio.com/2010-04-01/Accounts/$accountSid/Messages.json');

    try {
      final response = await http.post(
        url,
        headers: <String, String>{
          'Authorization': 'Basic ' + base64Encode(utf8.encode('$accountSid:$authToken')),
          'Content-Type': 'application/x-www-form-urlencoded',
        },
        body: {
          'From': '(541) 803-6196',
          'To': '+233553767177',
          'Body': 'You have an appointment with Owl, Inc. on Friday, November 3 at 4:00 PM. Reply C to confirm.',
        },
      );

      if (response.statusCode == 201) {
        print('Message sent successfully');
      } else {
        print('Failed to send message: ${response.statusCode}');
        print('Response body: ${response.body}');
      }
    } catch (e) {
      print('Error sending message: $e');
    }
  }

  Future<void> sendTwilioMessage() async {
    TwilioFlutter twilioFlutter = TwilioFlutter(
      accountSid: 'SK68c99c87e3587790d699638fda4c33b6',
      authToken: 'NXoKyHTixcYC129gVJB0F8JxHjdAavSg',
      twilioNumber: '+233553767177',
    );

    await twilioFlutter.sendWhatsApp(
      toNumber: '+233542169225',
      messageBody: 'You have an appointment with Owl, Inc. on Friday, November 3 at 4:00 PM. Reply C to confirm.',
    ).then((value) {
      print('Message sent successfully');
    }).catchError((error) {
      print('Failed to send message: $error');
    });
  }

  Future<void> sendSmsWithArkesel() async {
    var apiKey = 'RlRPU2hKQ3ZzanVjS2VKS3NmWmc';
    var toNumber = '233553767177';
    var from = '0553767177';
    var message = 'Hello world. Spreading peace and joy only. Remember to put on your face mask. Stay safe!';

    var url = Uri.parse('https://sms.arkesel.com/sms/api?action=send-sms&api_key=$apiKey&to=$toNumber&from=$from&sms=${Uri.encodeComponent(message)}');

    try {
      final response = await http.get(url);

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
  }*/


/*
  var accountSid = 'AC4a15ca68ff6f0e04d667da4abf2c0d15';
  var authToken = '70ff00ea7b1f9e5631dee46ff007f219';
  Future<void> sendMessageWithTwilio( ) async {
    var url = Uri.parse('https://api.twilio.com/2010-04-01/Accounts/$accountSid/Messages.json');

    try {
      final response = await http.post(
        url,
        headers: <String, String>{
          'Authorization': 'Basic ' + base64Encode(utf8.encode('$accountSid:$authToken')),
          'Content-Type': 'application/x-www-form-urlencoded',
        },
        body: {
          'From': '0553767177',
          'To':'0542169225',
          'Body': 'Test message',
        },
      );

      if (response.statusCode == 201) {
        print('Message sent successfully');
      } else {
        print('Failed to send message: ${response.statusCode}');
      }
    } catch (e) {
      print('Error sending message: $e');
    }}*/



}
