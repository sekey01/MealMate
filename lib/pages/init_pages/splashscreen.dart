import 'dart:ui';

import 'package:another_flutter_splash_screen/another_flutter_splash_screen.dart' as another;
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:lottie/lottie.dart';
import 'package:mealmate/Local_Storage/Locall_Storage_Provider/StoreCredentials.dart';
import 'package:mealmate/Notification/notification_Provider.dart';
import 'package:mealmate/UserLocation/LocationProvider.dart';
import 'package:provider/provider.dart';
import '../authpages/login.dart';
import '../navpages/home.dart';

class SplashScreen extends StatefulWidget {
  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  ///check if user is logged in
  ///set this initial to true when testing on simulator since it will not have any user logged in
  bool isLoggedIn = false;
  final GoogleSignIn _googleSignIn = GoogleSignIn();

  Future CheckSignedIn() async {
    if (await _googleSignIn.isSignedIn()) {
      setState(() {
        isLoggedIn = true;
      });
    }
  }

  /// Get the token, save it to the database for current user
  void _getToken() async {
    FirebaseMessaging messaging = FirebaseMessaging.instance;
    String? token = await messaging.getToken();;
   print("FCM Token: $token");
    await Provider.of<LocalStorageProvider>(context, listen: false).storeToken(token!);
  }
  @override
  initState() {

    CheckSignedIn();
    //_getToken();
    Provider.of<NotificationProvider>(context,listen: false).configureFirebaseListeners();
    Provider.of<NotificationProvider>(context,listen: false).requestNotificationPermissions();
    Provider.of<LocationProvider>(context,listen: false).enableLocation();
  }




  @override
  Widget build(BuildContext context) {
    return another.FlutterSplashScreen(
      duration: const Duration(seconds: 10),
      nextScreen: isLoggedIn ? const Home() : const Login(),
      backgroundColor: Colors.redAccent,
      splashScreenBody: Center(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Center(
            child: Builder(
              builder: (context) {
                return Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [

                    RichText(
                      text: const TextSpan(
                        children: [
                          TextSpan(
                            text: "Meal",
                            style: TextStyle(
                              color: Colors.black,
                              fontSize: 30,
                              fontWeight: FontWeight.bold,
                              fontFamily: 'Righteous',
                            ),
                          ),
                          TextSpan(
                            text: "Mate",
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 30,
                              fontWeight: FontWeight.bold,
                              fontFamily: 'Righteous',
                            ),
                          ),
                        ],
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(left: 20, right: 20),
                      child: LottieBuilder.asset(
                        'assets/Icon/loading.json',
                        width: 150.w,
                        height: 100.h,
                      ),
                    ),
                  ],
                );
              },
            ),
          ),
        ),
      ),
    );
  }
}