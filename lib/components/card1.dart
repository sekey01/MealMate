import 'package:another_carousel_pro/another_carousel_pro.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:mealmate/components/mealmate.dart';

Widget initCard() {
  return Padding(
    padding: const EdgeInsets.all(4.0),
    child: Badge(
      alignment: Alignment.topCenter,
      backgroundColor: Colors.deepOrange,
      textColor: Colors.white,
      label: Text(
        'Call Us 📞 +233 55 376 7177',
      ),
      child: Material(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(25)),
        color: Colors.white,
        elevation: 6,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                MealMate(),
                Text(
                  'Order from your favourite \n Restaurants and get it \n delivered to you quick',
                  style: TextStyle(
                      //fontWeight: FontWeight.bold,
                      fontSize: 12.sp,
                      color: Colors.black87),
                )
              ],
            ),
            Container(
              height: 150.h,
              width: 100.w,
              child: AnotherCarousel(
                images: [
                  Image(
                    image: AssetImage('assets/images/logo.png'),
                    height: 200.h,
                    width: 200.w,
                  ),
                  Image(
                    image: AssetImage('assets/images/delivery.jpg'),
                    height: 160.h,
                    width: 150.w,
                  ),
                  Image(
                    image: AssetImage('assets/images/delivery1.jpg'),
                    height: 160.h,
                    width: 150.w,
                  ),
                ],
                dotSize: 3.0,
                dotSpacing: 10.0,
                dotColor: Colors.black,
                indicatorBgPadding: 0.0,
                dotBgColor: Colors.white,
                borderRadius: true,
                moveIndicatorFromBottom: 180.0,
                noRadiusForIndicator: true,
              ),
            )
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
