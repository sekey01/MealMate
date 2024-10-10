import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

Container noFoodFound() {
  return Container(
    child: Column(
      children: [
        SizedBox(
          height: 80.h,
        ),
        Icon(
          Icons.no_food_outlined,
          size: 65.sp,
          color: Colors.red,
        ),
        SizedBox(
          height: 20.h,
        ),
    RichText(text: TextSpan(
        children: [
          TextSpan(text: " No Food", style: TextStyle(color: Colors.black, fontSize: 20.sp,fontWeight: FontWeight.bold)),
          TextSpan(text: " Found", style: TextStyle(color: Colors.deepOrangeAccent, fontSize: 20.sp,fontWeight: FontWeight.bold)),


        ]
    )),
      ],
    ),
  );
}

Container EmptyHistory() {
  return Container(
    child: Column(
      children: [
        SizedBox(
          height: 80.h,
        ),
        Icon(
          Icons.no_food_outlined,
          size: 65.sp,
          color: Colors.red,
        ),
        SizedBox(
          height: 20.h,
        ),
        RichText(text: TextSpan(
            children: [
              TextSpan(text: " Empty", style: TextStyle(color: Colors.black, fontSize: 20.sp,fontWeight: FontWeight.bold)),
              TextSpan(text: " History", style: TextStyle(color: Colors.deepOrangeAccent, fontSize: 20.sp,fontWeight: FontWeight.bold)),
            ]
        )),      ],
    ),
  );
}
