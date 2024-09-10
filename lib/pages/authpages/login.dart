import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:mealmate/AdminPanel/Pages/adminlogin.dart';
import 'package:mealmate/UserLocation/LocationProvider.dart';
import 'package:mealmate/components/Notify.dart';
import 'package:mealmate/pages/authpages/signup.dart';
import 'package:mealmate/pages/authpages/Otp_VerificationPage.dart';
import 'package:mealmate/pages/navpages/home.dart';
import 'package:phone_text_field/phone_text_field.dart';
import 'package:provider/provider.dart';

class Login extends StatefulWidget {
  const Login({super.key});

  @override
  State<Login> createState() => _LoginState();
}

class _LoginState extends State<Login> {
  TextEditingController _phoneNumberController = TextEditingController();
  bool _isPhoneNumberValid = true;

  @override


  Future<User?> signInWithGoogle(BuildContext context) async {
    FirebaseAuth auth = FirebaseAuth.instance;
    User? user;

    final GoogleSignIn googleSignIn = GoogleSignIn();

    try {
      final GoogleSignInAccount? googleSignInAccount = await googleSignIn.signIn();

      if (googleSignInAccount != null) {
        final GoogleSignInAuthentication googleSignInAuthentication =
        await googleSignInAccount.authentication;

        final AuthCredential credential = GoogleAuthProvider.credential(
          accessToken: googleSignInAuthentication.accessToken,
          idToken: googleSignInAuthentication.idToken,
        );

        try {
          final UserCredential userCredential =
          await auth.signInWithCredential(credential);

          user = userCredential.user;

          // If sign-in was successful, navigate to Home
          if (user != null) {
            await Navigator.pushReplacement(
                context,
                MaterialPageRoute(builder: (context) => Home())
            );
          }
        } on FirebaseAuthException catch (e) {
          if (e.code == 'account-exists-with-different-credential') {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text('The account already exists with a different credential.'),
              ),
            );
          } else if (e.code == 'invalid-credential') {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text('Error occurred while accessing credentials. Try again.'),
              ),
            );
          }
        } catch (e) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('Error occurred using Google Sign-In. Try again.'),
            ),
          );
        }
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Error occurred using Google Sign-In. Try again.'),
        ),
      );
    }

    return user;
  }

  void dispose() {
    _phoneNumberController.dispose();
    super.dispose();
  }

  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      body: Center(
        child: SafeArea(
          child: SingleChildScrollView(
            child: Column(
              children: [
                Padding(
                  padding: EdgeInsets.all(25),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Image(
                        image: AssetImage('assets/images/logo.png'),
                        width: 150.w,
                      ),
                      SizedBox(
                        height: 10.h,
                      ),
                      Text(
                        '     Welcome ! ',
                        style: TextStyle(
                            letterSpacing: 4,
                            fontSize: 20.sp,
                            fontWeight: FontWeight.bold,
                            color: Colors.black87),
                      ),
                      Text(
                        'Discover new amazing recipies',
                        style: TextStyle(
                            fontSize: 15, color: Colors.deepOrangeAccent),
                      ),
                      SizedBox(
                        height: 20.h,
                      ),

                      Padding(
                        padding: EdgeInsets.all(10),
                        child: TextField(
                          style: TextStyle(color: Colors.black),
                          keyboardType: TextInputType.numberWithOptions(),
                          decoration: InputDecoration(
                              prefixIcon:
                              Icon(Icons.phone, color: Colors.red),
                              border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(10),
                                  borderSide: BorderSide(color: Colors.deepOrangeAccent)),
                              enabledBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(10),
                                borderSide: BorderSide(color: Colors.deepOrangeAccent),
                              ),
                              hintText: "Enter number: 0542169225 ",
                              hintStyle: TextStyle(color: Colors.grey,fontSize: 14.sp,fontStyle: FontStyle.italic)),
                        ),
                      ),



                      /*///THIS IS THE PHONE TEXT FIELD WIDGET
                      ///IT IS A CUSTOM WIDGET THAT I CREATED TO MAKE IT EASY TO GET THE PHONE NUMBER
                      ///IT IS A CUSTOM TEXT FIELD THAT TAKES THE PHONE NUMBER AND COUNTRY CODE
                      Padding(
                        padding: EdgeInsets.all(0),
                        child: PhoneTextField(
                          showCountryCodeAsIcon: true,
                          autovalidateMode: AutovalidateMode.disabled,
                          locale: const Locale('en'),
                          decoration: const InputDecoration(
                            filled: true,
                            fillColor: Colors.white,
                            contentPadding: EdgeInsets.zero,
                            enabledBorder: OutlineInputBorder(
                              borderRadius:
                                  BorderRadius.all(Radius.circular(10.0)),
                              borderSide: BorderSide(),
                            ),
                            focusedBorder: OutlineInputBorder(
                              borderRadius:
                                  BorderRadius.all(Radius.circular(10.0)),
                              borderSide: BorderSide(),
                            ),
                            labelText: "Phone number",
                            labelStyle: TextStyle(
                              color: Colors.black,
                            ),
                          ),
                          dropdownIcon: Icon(
                            Icons.arrow_drop_down,
                            color: Colors.black,
                          ),
                          textStyle: TextStyle(
                              color: Colors.black,
                              fontSize: 15.sp,
                              fontWeight: FontWeight.bold),
                          searchFieldInputDecoration: const InputDecoration(
                            filled: true,
                            enabledBorder: OutlineInputBorder(
                              borderRadius:
                                  BorderRadius.all(Radius.circular(10.0)),
                              borderSide: BorderSide(),
                            ),
                            focusedBorder: OutlineInputBorder(
                              borderRadius:
                                  BorderRadius.all(Radius.circular(10.0)),
                              borderSide: BorderSide(),
                            ),
                            suffixIcon: Icon(Icons.search),
                            hintText: "Search country",
                          ),
                          initialCountryCode: "GH",
                          onChanged: (phone) {
                            setState(() {
                              if (phone.isValidNumber())
                                _phoneNumberController.text =
                                    phone.completeNumber;
                              _isPhoneNumberValid = true;

                              return;
                            });
                          },
                        ),
                      ),*/

                      SizedBox(
                        width: double.infinity,
                        height: 50.h,
                        child: ElevatedButton(
                          style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.white),
                          onPressed: () {
                          /*  if (_isPhoneNumberValid) {
                         signInWithGoogle(context);

                            } else {
                              Notify(context, 'Enter Correct Number',Colors.red);
                            }*/
Navigator.push(context, MaterialPageRoute(builder: (context)=> Home()));
                          },
                          child: Row(
                            children: [
                              Text(
                                "Continue with Google ",
                                style: TextStyle(
                                  letterSpacing: 2,
                                  color: Colors.black,

                                  fontSize: 15.sp,
                                ),
                              ),

                            ],
                          ),
                        ),
                      ),
                      SizedBox(
                        height: 20.h,
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            " Are you an Admin ?  ",
                            style: TextStyle(
                                color: Colors.black, fontStyle: FontStyle.italic, fontSize: 12.sp),
                          ),
                          GestureDetector(
                            onTap: () {
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: ((context) => AdminLogin())));
                            },
                            child: Text(
                              ' Click here',
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                color: Colors.deepOrangeAccent,
                              ),
                            ),
                          ),
                        ],
                      ),

                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}


