import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../mealmate.dart';

Widget MatePayCard(
    String Premium,
    String CardNumber,
    String CardHolderName,
    String ID,
    String Balance,
    ) {
  return Padding(
    padding: const EdgeInsets.all(2.0),
    child: Badge(
      alignment: Alignment.topCenter,
      backgroundColor: Colors.deepOrange,
      textColor: Colors.white,
      label: Text(
        Premium,
      ),
      child: Container(
        height: 140.h,
        width: 300.w,
        decoration: BoxDecoration(
            gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [
                  Colors.blueGrey,Colors.black,
                  Colors.deepOrangeAccent.shade100]),
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
                height: 140.h,
                width: 50.w,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [

                    Padding(padding: const EdgeInsets.only(top: 15),
                      child: RichText(
                        text: TextSpan(
                          children: [
                            TextSpan(
                              text: 'GHS \n',
                              style: TextStyle(
                                  fontFamily: 'Poppins',
                                  fontWeight: FontWeight.bold,
                                  fontSize: 10.sp,
                                  color: Colors.white),
                            ),
                            TextSpan(
                              text: Balance,
                              style: TextStyle(
                                  fontFamily: 'Righteous',
                                  fontWeight: FontWeight.bold,
                                  fontSize: 14.sp,
                                  color: Colors.white),
                            ),
                          ],
                        ),
                      ),
                    ),

                    /*Padding(
                      padding: const EdgeInsets.only(top: 10),
                      child: ClipRRect(
                        borderRadius: BorderRadius.all(Radius.circular(70)),
                        child: Image(
                          image: AssetImage('assets/Icon/chip.png'),
                          height: 40.h,
                          width: 40.w,
                        ),
                      ),
                    ),*/

                    ImageIcon(AssetImage('assets/images/logo.png'), size: 80, color: Colors.white,),
                  ],
                )),
            Column(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                //MealMate(),
                Text(
                  'NAME: ${CardHolderName.toUpperCase()}',
                  style: TextStyle(
                      overflow: TextOverflow.ellipsis,
                      fontWeight: FontWeight.w600,
                      fontSize: 10.sp,
                      letterSpacing: 1,
                      color: Colors.white),
                ),

                Text(
                  'P'
                      'P-Code :'+"$CardNumber",
                  style: TextStyle(
                    //fontWeight: FontWeight.bold,
                      fontSize: 10.sp,
                      color: Colors.white),
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
                      fontSize: 10.sp,
                      color: Colors.white),
                ),
                SizedBox(
                  height: 10.h,
                ),
                Text(
                  "ACC ID : $ID",
                  style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 10.sp,
                      color: Colors.white),
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
