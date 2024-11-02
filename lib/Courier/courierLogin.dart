import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:mealmate/Courier/courierInit.dart';
import '../components/Notify.dart';

Future<bool> authenticateUser(BuildContext context, String CourierId) async {
  try {
    // Get a reference to the Firestore instance
    FirebaseFirestore firestore = FirebaseFirestore.instance;

    // Query the 'CourierId' collection for the document with matching ID
    QuerySnapshot querySnapshot = await firestore
        .collection('CourierId')
        .where('CourierId', isEqualTo: CourierId)
        .limit(1)
        .get();

    // Check if any documents were found
    if (querySnapshot.docs.isNotEmpty) {
      Notify(context, 'Verified', Colors.green);
      return true;
    } else {
      Notify(context, 'Not Verified', Colors.red);
      return false;
    }
  } catch (e) {
    Notify(context, 'Please make sure you\'re Connected', Colors.red);
    print('Error authenticating user: $e');
    return false;
  }
}

// Example usage in a StatefulWidget
class CourierLoginPage extends StatefulWidget {
  @override
  _CourierLoginPageState createState() => _CourierLoginPageState();
}

class _CourierLoginPageState extends State<CourierLoginPage> {
  final _formKey = GlobalKey<FormState>();

  final TextEditingController CourierIdController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      appBar: AppBar(
        automaticallyImplyLeading: false,
        leading: IconButton(
          onPressed: () {
            Navigator.pop(context);
          },
          icon: Icon(Icons.arrow_back_ios),
          color: Colors.blueGrey,
        ),
        backgroundColor: Colors.white,
        title: RichText(
          text: TextSpan(
            children: [
              TextSpan(
                text: "Courier",
                style: TextStyle(
                  color: Colors.black,
                  fontSize: 20.spMin,
                  fontWeight: FontWeight.bold,
                  fontFamily: 'Righteous',
                ),
              ),
              TextSpan(
                text: "Verification",
                style: TextStyle(
                  color: Colors.deepOrangeAccent,
                  fontSize: 20.spMin,
                  fontWeight: FontWeight.bold,
                  fontFamily: 'Righteous',
                ),
              ),
            ],
          ),
        ),
        centerTitle: true,
      ),
      body: Center(
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Form(
                key: _formKey,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Padding(
                      padding: EdgeInsets.all(1),
                      child: Image(
                        image: AssetImage('assets/images/logo.png'),
                        height: 150,
                        width: 250,
                      ),
                    ),
                    SizedBox(height: 30.h),
                    Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: TextFormField(
                        keyboardType: TextInputType.numberWithOptions(decimal: true, signed: true),
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Please enter Courier Id';
                          }
                          return null;
                        },
                        obscureText: true,
                        style: TextStyle(color: Colors.black),
                        controller: CourierIdController,
                        decoration: InputDecoration(
                          filled: true,
                          fillColor: Colors.deepOrange.shade50,
                          hintStyle: TextStyle(color: Colors.black),
                          labelStyle: TextStyle(color: Colors.black),
                          labelText: 'Courier Id',
                          hintText: 'Enter Courier Id for verification',
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10),
                            borderSide: BorderSide(color: Colors.deepOrangeAccent),
                          ),
                        ),
                      ),
                    ),
                    SizedBox(height: 30.h),
                    ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        elevation: 3,
                        backgroundColor: Colors.deepOrangeAccent,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),
                      onPressed: () async {
                        if (_formKey.currentState!.validate()) {
                          String VerifycourierId = CourierIdController.text.toString();
                          bool isAuthenticated = await authenticateUser(context, VerifycourierId);
                          if (isAuthenticated) {
                            Navigator.pushReplacement(
                              context,
                              MaterialPageRoute(
                                builder: (context) => CourierInit(),
                              ),
                            );
                          }
                        }
                        CourierIdController.clear();
                      },
                      child: Text(
                        'Verify Id',
                        style: TextStyle(
                          fontSize: 20.sp,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                          fontFamily: 'Righteous',
                          letterSpacing: 2,
                        ),
                      ),
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