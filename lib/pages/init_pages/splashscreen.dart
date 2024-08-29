import 'package:another_flutter_splash_screen/another_flutter_splash_screen.dart';
import 'package:flutter/material.dart';
import 'package:mealmate/components/CustomLoading.dart';
import 'package:mealmate/pages/authpages/login.dart';

class SplashScreen extends StatelessWidget {
  const SplashScreen({
    super.key,
  });

  @override

  Widget build(BuildContext context) {
    return FlutterSplashScreen(
      duration: const Duration(seconds: 2),
      nextScreen: const Login(),
      backgroundColor: Colors.white,
      splashScreenBody: Center(
          child: Padding(
        padding: const EdgeInsets.all(48.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Center(child: Image(image: AssetImage('assets/images/logo.png'))),
            SizedBox(
              height: 50,
            ),
            Center(
              child: CustomLoGoLoading(),
            ),
            SizedBox(
              height: 20,
            ),
          ],
        ),
      )),
    );
  }
}
