import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

Widget NoInternetConnection() {
  return Padding(
    padding: const EdgeInsets.all(18.0),
    child: Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Center(child: Image(image: AssetImage('assets/Icon/no-connection.png'), height: 150.h, width: 150.w,)),
          SizedBox(height: 20.h,),
  Text( "Unstable Internet Connection ", style: TextStyle(color: Colors.red, fontSize: 15.sp, fontWeight: FontWeight.normal, fontFamily: 'Popins'),),
          SizedBox(height: 10.h,),
          Text( "Please check your internet connection and try again", style: TextStyle(color: Colors.black, fontSize: 10.sp, fontWeight: FontWeight.normal, fontFamily: 'Popins'),)
  ,
        ],
      ),
    ),
  );
}
