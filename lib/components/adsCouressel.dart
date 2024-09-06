import 'package:another_carousel_pro/another_carousel_pro.dart';
import 'package:flutter/material.dart';

Container adsCouressel() {
  return Container(
    height: 200,
    width: 300,
    child:  AnotherCarousel(
      animationDuration: Duration(seconds: 2),
      boxFit: BoxFit.fitWidth,
      dotSize: 0.5,
      dotHorizontalPadding: 1,
      indicatorBgPadding: 0,
      images: [
        Image(
          image: AssetImage('assets/images/MealmateDress.png'),
          //height: 240,
          //  width: double.infinity,
        ),
        Image(
          image: AssetImage('assets/adsimages/ads1.png'),
          //height: 240,
          //  width: double.infinity,
        ),
        Image(
          image: AssetImage('assets/Announcements/An_Feedback.png'),
          height: 240,
          width: 200,
        ),
        Image(
          image: AssetImage('assets/adsimages/ads2.png'),
          height: 240,
          width: 200,
        ),
        Image(
          image: AssetImage('assets/adsimages/ads3.png'),
          height: 240,
          width: 200,
        ),
        Image(
          image: AssetImage('assets/Announcements/An_Grocery.png'),
          height: 240,
          width: 200,
        ),
      ],
    ),
  );
}
