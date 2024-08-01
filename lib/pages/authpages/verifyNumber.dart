import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:pin_code_fields/pin_code_fields.dart';
import 'package:provider/provider.dart';

import '../../Local_Storage/Locall_Storage_Provider/StoreCredentials.dart';
import '../navpages/home.dart';

class verifyOTP extends StatefulWidget {
  const verifyOTP({super.key, required this.phoneNumber});

  final String phoneNumber;

  @override
  State<verifyOTP> createState() => _verifyOTPState();
}

class _verifyOTPState extends State<verifyOTP> {
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    Provider.of<LocalStorageProvider>(context, listen: false)
        .storePhoneNumber(widget.phoneNumber);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text('Verify Phone Number'),
        ),
        body: SafeArea(
            child: SingleChildScrollView(
                child: Column(children: [
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
                    Center(
                      child: Text(
                        'We have sent an OTP to your phone ',
                        style: TextStyle(
                            fontSize: 15,
                            letterSpacing: 1,
                            color: Colors.black87,
                            fontWeight: FontWeight.normal),
                      ),
                    ),
                    Center(
                      child: Text(
                        widget.phoneNumber,
                        style: TextStyle(
                          fontSize: 20,
                          letterSpacing: 2,
                          color: Colors.black87,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    SizedBox(
                      height: 20,
                    ),
                    Padding(
                      padding: EdgeInsets.all(10),
                      child: PinCodeTextField(
                        textStyle: TextStyle(
                          color: Colors.black,
                          fontSize: 25,
                        ),
                        boxShadows: [
                          BoxShadow(
                              offset: Offset(1, 1),
                              color: Colors.green.withOpacity(0.2),
                              blurStyle: BlurStyle.solid,
                              blurRadius: 5,
                              spreadRadius: 4)
                        ],
                        onCompleted: (v) {
                          print(v);
                          Navigator.pushReplacement(context,
                              MaterialPageRoute(builder: (context) => Home()));
                        },
                        keyboardType: TextInputType.number,
                        inputFormatters: [
                          FilteringTextInputFormatter.digitsOnly
                        ],
                        autoDisposeControllers: true,
                        autovalidateMode: AutovalidateMode.onUserInteraction,
                        animationType: AnimationType.slide,
                        //backgroundColor: Colors.green,
                        appContext: context,
                        length: 4,
                      ),
                    ),
                    SizedBox(
                      height: 20,
                    ),
                    TextButton(
                      onPressed: () {
                        // Perform sign-in operation
                        // Navigator.of(context).pushReplacement(
                        //   MaterialPageRoute(
                        //     builder: (context) => Index(),
                        //   ),
                        // );
                      },
                      child: Text('Resend OTP'),
                    )
                  ]))
        ]))));
  }
}
