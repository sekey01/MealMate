import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:mealmate/AdminPanel/Pages/adminlogin.dart';
import 'package:mealmate/Courier/courierLogin.dart';
import 'package:mealmate/Local_Storage/Locall_Storage_Provider/StoreCredentials.dart';
import 'package:mealmate/components/CustomLoading.dart';
import 'package:mealmate/components/Notify.dart';
import 'package:mealmate/pages/navpages/home.dart';
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

  bool signInLoading = false;

  @override
  void initState() {
    super.initState();
    _googleSignIn.onCurrentUserChanged.listen((GoogleSignInAccount? account) {
      setState(() {
        _user = account;

      });
    });
  //  CheckSignedIn();
   // _googleSignIn.signInSilently(); // Auto sign-in if the user is already signed in
  }
/*  Future CheckSignedIn() async{
    if( await _googleSignIn.isSignedIn()){
      Navigator.pushReplacement(context, MaterialPageRoute(builder: (context)=> Home()));
    }
  }*/
  Future<void> _handleSignIn() async {
  setState(() {
    signInLoading = true;
  });
    try {

      final userCredential = await _googleSignIn.signIn();

      if (userCredential != null) {
        // Assuming userCredential contains user information
        final user = userCredential; // Replace with actual user information if needed

        Provider.of<LocalStorageProvider>(context,listen: false).storeEmail(user.email);
        Provider.of<LocalStorageProvider>(context,listen: false).storeUsername(user.displayName.toString());
        Provider.of<LocalStorageProvider>(context,listen: false).storeImageUrl(user.photoUrl.toString());



        /* print('${user.email} uuuuuuuuuuuuuuuuuuuuuuuuuuuuuuu');
        print(user.photoUrl);
        print(user.displayName);*/// Print user email for debugging
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => Home()),
        );
        setState(() {
          signInLoading = false;
        });
        Notify(context, 'Login Successfully', Colors.green);
      } else {
        setState(() {
          signInLoading = false;
        });
        // Handle the case where the sign-in was canceled by the user
        Notify(context, 'Sign-in was canceled', Colors.red);
      }
    } catch (error) {
      setState(() {
        signInLoading = false;
      });
      // Handle other potential errors
      print(error);
      Notify(context, 'Please Check Your Internet...', Colors.red);
    }
  }



  Widget build(BuildContext context) {

    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      body: Center(
        child: SafeArea(
          child: SingleChildScrollView(
            child: signInLoading ? SearchLoadingOutLook(): Column(
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
                      RichText(text: TextSpan(
                          children: [
                            TextSpan(text: "Wel", style: TextStyle(color: Colors.black, fontSize: 20.spMin, fontWeight: FontWeight.bold,fontFamily: 'Righteous',)),
                            TextSpan(text: "come !", style: TextStyle(color: Colors.deepOrangeAccent, fontSize: 20.spMin, fontWeight: FontWeight.bold,fontFamily: 'Righteous',)),


                          ]
                      )),
                      SizedBox(
                        height: 20.h,
                      ),
                      Text(
                        'Discover new amazing recipies',
                        style: TextStyle(
                            fontSize: 15.sp, color: Colors.black),
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
   Provider.of<LocalStorageProvider>(context,listen: false).storePhoneNumber(value);

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
                                hintText: "enter number: 0542169225 ",
                                hintStyle: TextStyle(color: Colors.black,fontSize: 15.sp,fontWeight: FontWeight.normal)),
                            validator: (value) {
                              if (value == null || value.trim().isEmpty) {
                                return '   This field cannot be empty';
                              }
                              //if phone number is not up to 10 digits
                              if (value.length < 10 || value.length > 10) {
                                return 'Phone number must be 10 digits';
                              }
                              return null; // return null if the input is valid
                            },

                          ),

                        ),
                      ),





                      ///GOOGLE SIGN IN BUTTON HERE
                      SizedBox(
                        width: double.infinity,
                        height: 50.h,
                        child: ElevatedButton(
                          style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.deepOrange.shade50,),
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
                        height: 150.h,
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            " Are you an Admin ?  ",
                            style: TextStyle(
                                color: Colors.black, fontStyle: FontStyle.italic, fontSize: 10.sp),
                          ),
                          GestureDetector(
                            onTap: () {
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: ((context) => AdminLogin())));
                            },
                            child: Text(
                              ' Admin   /',
                              style: TextStyle(
                                fontFamily: 'Righteous',
                                fontSize: 10.sp,
                                fontWeight: FontWeight.bold,
                                color: Colors.deepOrangeAccent,
                              ),

                            ),
                          ),
SizedBox(width: 10.w,),
                          GestureDetector(
                            onTap: () {
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: ((context) => CourierLoginPage())));
                            },
                            child: Text(
                              'Courier ',
                              style: TextStyle(
                                fontFamily: 'Righteous',
                                fontSize: 10.sp,
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
            ) ,
          ),
        ),
      ),
    );
  }
}


