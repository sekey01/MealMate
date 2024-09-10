import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:pin_code_fields/pin_code_fields.dart';
import 'package:provider/provider.dart';

import '../../Local_Storage/Locall_Storage_Provider/StoreCredentials.dart';
import '../navpages/home.dart';

class verifyOTP extends StatefulWidget {
  const verifyOTP({super.key, required this.phoneNumber, required this.verificationId});

  final String phoneNumber;
  final  String verificationId;

  @override
  State<verifyOTP> createState() => _verifyOTPState();
}

class _verifyOTPState extends State<verifyOTP> {
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    Provider.of<LocalStorageProvider>(context, listen: false)
        .storeNumber(widget.phoneNumber);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Theme.of(context).scaffoldBackgroundColor,
        appBar: AppBar(
          backgroundColor: Theme.of(context).scaffoldBackgroundColor,
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
                      height: 10.h,
                    ),
                    RichText(text: TextSpan(
                        children: [
                          TextSpan(text: "OTP sent to : ", style: TextStyle(color: Colors.black,)),
                          TextSpan(text: '${widget.phoneNumber.toString()}', style: TextStyle(color: Colors.deepOrangeAccent, fontSize: 20.sp, fontWeight: FontWeight.bold)),


                        ]
                    )),
                    SizedBox(
                      height: 20.h,
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
   Navigator.pop(context);
                      },
                      child: Text('Resend OTP',style: TextStyle(color: Colors.deepOrangeAccent, fontWeight: FontWeight.bold),),
                    )
                  ]))
        ]))));
  }
}
