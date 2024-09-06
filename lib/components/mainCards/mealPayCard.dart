import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../mealmate.dart';

Widget MatePayCard(
  String Premium,
  String CardNumber,
  String CardHolderName,
  String CVV,
) {
  return Padding(
    padding: const EdgeInsets.all(4.0),
    child: Badge(
      alignment: Alignment.topCenter,
      backgroundColor: Colors.deepOrange,
      textColor: Colors.white,
      label: Text(
        Premium,
      ),
      child: Material(
        shape:
            RoundedRectangleBorder(borderRadius: BorderRadius.circular(25.r)),
        color: Colors.grey,
        elevation: 6,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            Container(
                height: 130.h,
                width: 110.w,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    ClipRRect(
                      borderRadius: BorderRadius.all(Radius.circular(70)),
                      child: Image(
                        image: AssetImage('assets/Icon/chip.png'),
                        height: 70.h,
                        width: 60.w,
                      ),
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    ClipRRect(
                      borderRadius: BorderRadius.all(Radius.circular(70)),
                      child: Image(
                        image: AssetImage('assets/Icon/radio-waves.png'),
                        height: 50.h,
                        width: 50.w,
                      ),
                    ),
                  ],
                )),
            Column(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                MealMate(),
                Text(
                  'NAME:$CardHolderName',
                  style: TextStyle(
                      fontWeight: FontWeight.w600,
                      fontSize: 15.sp,
                      letterSpacing: 1.sp,
                      color: Colors.black),
                ),
                SizedBox(
                  height: 5.h,
                ),
                Text(
                  CardNumber,
                  style: TextStyle(
                      //fontWeight: FontWeight.bold,
                      fontSize: 18.sp,
                      color: Colors.black),
                ),
                SizedBox(
                  height: 20.h,
                ),
                Text(
                  'VALID THRU ',
                  style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 10.sp,
                      color: Colors.black),
                ),
                Text(
                  ' 12/25',
                  style: TextStyle(
                      //fontWeight: FontWeight.bold,
                      fontSize: 18.sp,
                      color: Colors.black),
                ),
                Text(
                  "CCV : $CVV",
                  style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 12.sp,
                      color: Colors.black87),
                ),
                SizedBox(
                  height: 10.h,
                )
              ],
            ),

            /* Image(
              image: AssetImage('assets/images/logo.png'),
              height: 160,
              width: 150,
            )*/
          ],
        ),
      ),
    ),
  );
}
