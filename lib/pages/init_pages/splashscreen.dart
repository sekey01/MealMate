import 'package:another_flutter_splash_screen/another_flutter_splash_screen.dart';
import 'package:flutter/material.dart';
import 'package:mealmate/components/CustomLoading.dart';
import 'package:mealmate/pages/authpages/login.dart';
import 'package:provider/provider.dart';

import '../../Local_Storage/Locall_Storage_Provider/StoreCredentials.dart';

class SplashScreen extends StatefulWidget {
  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override


  @override Widget build(BuildContext context) {
    return FlutterSplashScreen(
      duration: const Duration(seconds: 2),
      nextScreen: const Login(),
      backgroundColor: Colors.white,
      splashScreenBody: Center(
          child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Center(child: Image(image: AssetImage('assets/Announcements/OrderNow.png'))),
              RichText(text: TextSpan(
                  children: [
                    TextSpan(text: "Meal", style: TextStyle(color: Colors.black, fontSize: 20, fontWeight: FontWeight.bold)),
                    TextSpan(text: "Mate", style: TextStyle(color: Colors.deepOrangeAccent, fontSize: 20, fontWeight: FontWeight.bold)),


                  ]
              )),

              SizedBox(
                height: 20,
              ),
            ],
          ),
        ),
      )),
    );
  }
}
