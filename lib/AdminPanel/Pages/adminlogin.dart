import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:mealmate/AdminPanel/Pages/adminHome.dart';
import 'package:mealmate/components/CustomLoading.dart';

import '../../components/Notify.dart';

class AdminLogin extends StatefulWidget {
  const AdminLogin({super.key});

  @override
  State<AdminLogin> createState() => _AdminLoginState();
}

class _AdminLoginState extends State<AdminLogin> {
  bool isLoading = false;

  Future<void> adminSignIn() async {
    if (_emailController.text.isEmpty || _passwordController.text.isEmpty) {
      Notify(context, 'Please fill All fields', Colors.white);
      return;
    }

    setState(() {
      isLoading = true;
    });

    try {
      await FirebaseAuth.instance.signInWithEmailAndPassword(
        email: _emailController.text.trim(),
        password: _passwordController.text.trim(),
      );

      // If we reach here, sign in was successful
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => adminHome()),
      );
    } on FirebaseAuthException catch (e) {
      String errorMessage;
      switch (e.code) {
        case 'user-not-found':
          errorMessage = 'No user found for that email.';
          break;
        case 'wrong-password':
          errorMessage = 'Wrong password provided for that user.';
          break;
        case 'invalid-email':
          errorMessage = 'The email address is badly formatted.';
          break;
        default:
          errorMessage = 'Check your Internet Connection';
      }
     Notify(context, errorMessage, Colors.white);
      print('Error during sign in: ${e.code} - ${e.message}');
    } catch (e) {
      print('Unexpected error during sign in: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('An unexpected error occurred')),
      );
    } finally {
      setState(() {
        isLoading = false;
      });
    }
  }

  TextEditingController _emailController = TextEditingController();
  TextEditingController _passwordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            children: [
              SizedBox(
                height: 40,
              ),
              Padding(
                padding: EdgeInsets.all(25),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Center(
                      child: isLoading
                          ? CustomLoGoLoading()
                          : Image(
                              image: AssetImage("assets/images/logo.png"),
                              height: 150,
                              width: 150,
                            ),
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    Center(
                      child: Text(
                        'Admin Login',
                        style: TextStyle(
                            fontSize: 25,
                            color: Colors.black87,
                            fontWeight: FontWeight.bold),
                      ),
                    ),
                    SizedBox(
                      height: 20,
                    ),
                    Padding(
                      padding: EdgeInsets.all(10),
                      child: TextField(
                        style: TextStyle(color: Colors.black),
                        controller: _emailController,
                        decoration: InputDecoration(
                            enabledBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(10),
                              borderSide:
                                  BorderSide(color: Colors.deepOrangeAccent


),
                            ),
                            prefixIcon: Icon(
                                Icons.supervised_user_circle_rounded,
                                color: Colors.deepOrangeAccent


),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(10),
                              borderSide:
                                  BorderSide(color: Colors.deepOrangeAccent


),
                            ),
                            hintText: "Restaurant ID / Email",
                            hintStyle:
                                TextStyle(color: Colors.deepOrangeAccent


)),
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.all(10),
                      child: TextField(
                        style: TextStyle(color: Colors.black),
                        controller: _passwordController,
                        decoration: InputDecoration(
                            enabledBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(10),
                              borderSide:
                                  BorderSide(color: Colors.deepOrangeAccent


),
                            ),
                            prefixIcon: Icon(
                                Icons.supervised_user_circle_rounded,
                                color: Colors.deepOrangeAccent


),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(10),
                              borderSide:
                                  BorderSide(color: Colors.deepOrangeAccent


),
                            ),
                            hintText: "Restaurant Key / Password",
                            hintStyle:
                                TextStyle(color: Colors.deepOrangeAccent


)),
                      ),
                    ),
                    SizedBox(
                      width: double.infinity,
                      height: 60,
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.deepOrangeAccent


),
                        onPressed: () {
                          adminSignIn();
                        }, //_signInWithEmailAndPassword,
                        child: Text(
                          "Login",
                          style: TextStyle(
                            letterSpacing: 2,
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                            fontSize: 20,
                          ),
                        ),
                      ),
                    ),
                    SizedBox(height: 20),
                    SizedBox(
                      height: 20,
                    ),
                    Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          "Forgot your restaurant Credentials ?",
                          style: TextStyle(color: Colors.black),
                        ),
                        TextButton(
                          onPressed: () {},
                          child: Text(
                            ' Click here',
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              color: Colors.deepOrangeAccent


,
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
