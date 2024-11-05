import 'package:another_flutter_splash_screen/another_flutter_splash_screen.dart';
import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:mealmate/pages/authpages/login.dart';
import 'package:mealmate/pages/navpages/home.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';





class SplashScreen extends StatefulWidget {
  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
bool isLoggedIn = false;
  final GoogleSignIn _googleSignIn = GoogleSignIn();
  Future CheckSignedIn() async{
    if( await _googleSignIn.isSignedIn()){
      setState(() {
        isLoggedIn = true;
      });
    }
    else{
      setState(() {
        isLoggedIn = false;
      });
    }
  }

  @override
  initState() {
    super.initState();
    CheckSignedIn();
  }

  @override
  Widget build(BuildContext context) {
    return FlutterSplashScreen(
      duration: const Duration(seconds: 10),
      nextScreen: isLoggedIn ? const Home() :
      Login(),
      backgroundColor: Colors.white,
      splashScreenBody: Center(
          child: Padding(
        padding: const EdgeInsets.all(8.0),
        child:  Center(
          child: Builder(
            builder: (context) {

              return  Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Center(child: Image(image: AssetImage('assets/Announcements/OrderNow.png'), height: 250.h, width: double.infinity.w)),

                  Padding(
                    padding: const EdgeInsets.only(left: 20, right: 20),
                    child: LottieBuilder.asset('assets/Icon/loading.json'),
                  ),
                  RichText(text: TextSpan(
                      children: [
                        TextSpan(text: "Meal", style: TextStyle(color: Colors.black, fontSize: 30, fontWeight: FontWeight.bold,fontFamily: 'Righteous',)),
                        TextSpan(text: "Mate", style: TextStyle(color: Colors.deepOrangeAccent, fontSize: 30, fontWeight: FontWeight.bold,fontFamily: 'Righteous',)),


                      ]
                  )),
                ],
              );
            }
          ),
        ),
      )),
    );

  }
}
