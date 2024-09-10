import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

Widget NoInternetConnection() {
  return Padding(
    padding: const EdgeInsets.all(18.0),
    child: Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Center(child: ImageIcon(AssetImage('assets/Icon/no-connection.png'), color: Colors.red, size: 100,)),
          SizedBox(height: 20.h,),
          RichText(text: TextSpan(
              children: [
                TextSpan(text: "Internet Connection ", style: TextStyle(color: Colors.red, fontSize: 15.sp, fontWeight: FontWeight.normal)),
                TextSpan(text: 'Unstable', style: TextStyle(color: Colors.red, fontSize: 15.sp, fontWeight: FontWeight.normal)),


              ]
          )),
        ],
      ),
    ),
  );
}
