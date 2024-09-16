import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:mealmate/AdminPanel/Pages/adminlogin.dart';
import 'package:mealmate/Local_Storage/Locall_Storage_Provider/StoreCredentials.dart';
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
  final _formKey = GlobalKey<FormState>();

  final GoogleSignIn _googleSignIn = GoogleSignIn();

  GoogleSignInAccount? _user;

  @override
  void initState() {
    super.initState();
    _googleSignIn.onCurrentUserChanged.listen((GoogleSignInAccount? account) {
      setState(() {
        _user = account;

      });
    });
    _googleSignIn.signInSilently(); // Auto sign-in if the user is already signed in
  }

  Future<void> _handleSignIn() async {
    try {
      final userCredential = await _googleSignIn.signIn();

      if (userCredential != null) {
        // Assuming userCredential contains user information
        final user = userCredential; // Replace with actual user information if needed

        Provider.of<LocalStorageProvider>(context,listen: false).storeEmail(user.email);
        Provider.of<LocalStorageProvider>(context,listen: false).storeUsername(user.displayName.toString());
        Provider.of<LocalStorageProvider>(context,listen: false).storeImageUrl(user.photoUrl.toString());


        /* print('${user.email} uuuuuuuuuuuuuuuuuuuuuuuuuuuuuuuuu');
        print(user.photoUrl);
        print(user.displayName);*/// Print user email for debugging
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => Home()),
        );
        Notify(context, 'Login Successfully', Colors.green);
      } else {
        // Handle the case where the sign-in was canceled by the user
        Notify(context, 'Sign-in was canceled', Colors.red);
      }
    } catch (error) {
      // Handle other potential errors
      print(error);
      Notify(context, 'Error Logging in', Colors.red);
    }
  }


 /* Future<void> _handleSignOut() async {
    await _googleSignIn.signOut();
    Navigator.pushReplacement(context, MaterialPageRoute(builder: (context)=>Login()));
  }*/

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
                      ///LOGO DISPLAYED HERE
                      Image(
                        image: AssetImage('assets/images/logo.png'),
                        width: 150.w,
                      ),
                      SizedBox(
                        height: 20.h,
                      ),
                      Text(
                        '     Welcome ! ',
                        style: TextStyle(
                            letterSpacing: 4,
                            fontSize: 20.sp,
                            fontWeight: FontWeight.bold,
                            color: Colors.black87),
                      ),
                      SizedBox(
                        height: 20.h,
                      ),
                      Text(
                        'Discover new amazing recipies',
                        style: TextStyle(
                            fontSize: 15.sp, color: Colors.blueGrey),
                      ),
                      SizedBox(
                        height: 20.h,
                      ),



                      ///TEXTFORMFIELD   HERE
                      Padding(
                        padding: EdgeInsets.all(10),
                        child: Form(
                          key: _formKey,

                          child: TextFormField(
 onFieldSubmitted: (value){
   Provider.of<LocalStorageProvider>(context,listen: false).storeNumber(value);

 },
                            maxLength: 10,
                            style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold,fontSize: 20.sp),
                            keyboardType: TextInputType.numberWithOptions(),

                            decoration: InputDecoration(
                                prefixIcon:
                                Icon(Icons.phone, color: Colors.red),
                                border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(10.r),
                                    borderSide: BorderSide(color: Colors.deepOrangeAccent)),
                                enabledBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(10.r),
                                  borderSide: BorderSide(color: Colors.deepOrangeAccent),
                                ),
                                hintText: "Enter number: 0542169225 ",
                                hintStyle: TextStyle(color: Colors.grey,fontSize: 14.spMin,fontStyle: FontStyle.italic)),
                            validator: (value) {
                              if (value == null || value.trim().isEmpty) {
                                return '   This field cannot be empty';
                              }
                              return null; // return null if the input is valid
                            },

                          ),

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

                      ///GOOGLE SIGN IN BUTTON HERE
                      SizedBox(
                        width: double.infinity,
                        height: 50.h,
                        child: ElevatedButton(
                          style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.white),
    onPressed: ()  {
      if (_formKey.currentState?.validate() ?? false) {
        _handleSignIn();

      }

      /*Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => Home()),
      );*/





                          },
                          child: Row(
                            children: [
                              Text(
                                "Continue with Google ",
                                style: TextStyle(
                                  letterSpacing: 2,
                                  color: Colors.black,

                                  fontSize: 15.spMin,
                                ),
                              ),
 Image(image: AssetImage('assets/Icon/google.png'),height: 50.sp,width: 40.spMin,)
                              //ImageIcon(AssetImage('assets/Icon/google.png'), size: 30.sp,color: Colors.blue,)

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


