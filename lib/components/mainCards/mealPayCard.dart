import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../mealmate.dart';

Widget MatePayCard(
  String Premium,
  String CardNumber,
  String CardHolderName,
  String ID,
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
      child: Container(
        decoration: BoxDecoration(
            gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [Colors.blueGrey,Colors.black, Colors.deepOrangeAccent.shade100]),
            borderRadius: BorderRadius.circular(10),
            boxShadow: [
              BoxShadow(
                  color: Colors.grey.withOpacity(0.5),
                  spreadRadius: 5,
                  blurRadius: 7,
                  offset: Offset(0, 3))
            ]),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            Container(
                height: 150.h,
                width: 110.w,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    ClipRRect(
                      borderRadius: BorderRadius.all(Radius.circular(70)),
                      child: Image(
                        image: AssetImage('assets/Icon/chip.png'),
                        height: 60.h,
                        width: 50.w,
                      ),
                    ),
                    SizedBox(
                      height: 10.h,
                    ),
                   ImageIcon(AssetImage('assets/Icon/radio-waves.png',), size: 50, color: Colors.red,),
                  ],
                )),
            Column(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                MealMate(),
                Text(
                  'NAME: ${CardHolderName.toUpperCase()}',
                  style: TextStyle(
                    overflow: TextOverflow.ellipsis,
                      fontWeight: FontWeight.w600,
                      fontSize: 15.sp,
                      letterSpacing: 2,
                      color: Colors.white),
                ),
                SizedBox(
                  height: 5.h,
                ),
                Text(
                  'Promo Code :'+"$CardNumber",
                  style: TextStyle(
                      //fontWeight: FontWeight.bold,
                      fontSize: 15.sp,
                      color: Colors.white),
                ),
                SizedBox(
                  height: 20.h,
                ),
                Text(
                  'VALID THRU ',
                  style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 10.sp,
                      color: Colors.white),
                ),
                Text(
                  ' 12/25',
                  style: TextStyle(
                      //fontWeight: FontWeight.bold,
                      fontSize: 18.sp,
                      color: Colors.white),
                ),
                SizedBox(
                  height: 10.h,
                ),
                Text(
                  "ACC ID : $ID",
                  style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 12.sp,
                      color: Colors.white),
                ),
                SizedBox(
                  height: 15.h,
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
