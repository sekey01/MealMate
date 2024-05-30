import 'package:another_carousel_pro/another_carousel_pro.dart';
import 'package:flutter/material.dart';

Material adsCouressel() {
  return Material(
    borderRadius: BorderRadius.circular(10),
    color: Colors.white,
    elevation: 7,
    shadowColor: Colors.red,
    child: Container(
      height: 250,
      width: 300,
      child: AnotherCarousel(
        boxFit: BoxFit.fill,
        dotSize: 1.0,
        dotHorizontalPadding: 1,
        indicatorBgPadding: 0,
        images: [
          Image(
            image: AssetImage('assets/adsimages/ads1.png'),
            //height: 240,
            //  width: double.infinity,
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
        ],
      ),
    ),
  );
}
