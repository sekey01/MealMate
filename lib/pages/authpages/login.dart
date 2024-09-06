import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:mealmate/AdminPanel/Pages/adminlogin.dart';
import 'package:mealmate/UserLocation/LocationProvider.dart';
import 'package:mealmate/pages/authpages/signup.dart';
import 'package:mealmate/pages/authpages/verifyNumber.dart';
import 'package:phone_text_field/phone_text_field.dart';
import 'package:provider/provider.dart';

class Login extends StatefulWidget {
  const Login({super.key});

  @override
  State<Login> createState() => _LoginState();
}

class _LoginState extends State<Login> {
  TextEditingController _phoneNumberController = TextEditingController();
  bool _isPhoneNumberValid = false;

  @override

  void dispose() {
    // Dispose of the controller when the widget is disposed
    _phoneNumberController.dispose();
    super.dispose();
  }

  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            children: [
              SizedBox(
                height: 20,
              ),
              Padding(
                padding: EdgeInsets.all(25),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Image(
                      image: AssetImage('assets/images/logo.png'),
                      width: 170,
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    Text(
                      '     Welcome ! ',
                      style: TextStyle(
                          letterSpacing: 4,
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          color: Colors.black87),
                    ),
                    Text(
                      'Discover new amazing recipies',
                      style: TextStyle(
                          fontSize: 15, color: Colors.deepOrangeAccent),
                    ),
                    SizedBox(
                      height: 20,
                    ),

                    ///THIS IS THE PHONE TEXT FIELD WIDGET
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
                            fontSize: 15,
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
                    ),
                    Padding(
                      padding: EdgeInsets.only(),
                      child: TextButton(
                        onPressed: () {},
                        child: Text(
                          'Enjoy your meal',
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            color: Colors.black,
                          ),
                        ),
                      ),
                    ),
                    SizedBox(
                      width: double.infinity,
                      height: 50,
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.deepOrangeAccent),
                        onPressed: () {
                          if (_isPhoneNumberValid) {
                            /// BELLOW CODE STORES THE VALID NUMBER THE USER ENTERED AND SAVES IT TO LOCAL STORAGE
                            ///
                            /*
                            setState(() {
                              Provider.of<LocalStorageProvider>(context,
                                      listen: false)
                                  .StorePhoneNumber(
                                      _phoneNumberController.text.toString());
                            });*/

                            /// AFTER THE NUMBER IS SAVED,WE PUSH TO THE OTP PAGE FOR VERIFICATION
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => verifyOTP(
                                          phoneNumber: _phoneNumberController
                                              .text
                                              .trim(),
                                        )));
                          } else {
                            ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                                content: Center(
                                    child: Text(
                              "Invalid Phone Number",
                              style: TextStyle(
                                  color: Colors.deepOrangeAccent,
                                  fontSize: 20.sp,
                                  fontWeight: FontWeight.w600),
                            ))));
                          }

                          // signIn();
                        }, //_signInWithEmailAndPassword,
                        child: Text(
                          "Continue",
                          style: TextStyle(
                            letterSpacing: 2,
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                            fontSize: 15.sp,
                          ),
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
    );
  }
}
