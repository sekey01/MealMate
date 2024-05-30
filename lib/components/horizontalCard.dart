import 'package:flutter/material.dart';

import '../pages/detail&checkout/detail.dart';
import 'detailedCard.dart';

Column horizontalCard(
  String imgUrl,
  String restaurant,
  String foodName,
  double price,
  String location,
  String time,
  int id,
) {
  return Column(
    children: [
      ListView.builder(
        itemBuilder: (context, index) {
          return GestureDetector(
            onTap: () {
              Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => Detail(
                          detail: detailedCard(imgUrl, restaurant, foodName,
                              price, location, id, time))));
            },
            child: Padding(
                padding: const EdgeInsets.all(2.0),
                child: Container(
                  color: Colors.white,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Container(
                        margin: EdgeInsets.all(2),
                        color: Colors.white,
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(13),
                          child: Image.network(
                            imgUrl,
                            fit: BoxFit.fill,
                            height: 100,
                            width: 100,
                          ),
                        ),
                      ),
                      Container(
                        color: Colors.white,
                        child: Column(
                          //Column to Shaow Name OF Restaurant,Food Name, and Price Of the Food
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            SizedBox(
                              height: 5,
                            ),

                            ///Row for restaurant name
                            Text(
                              restaurant,
                              style: TextStyle(
                                  fontSize: 10,
                                  letterSpacing: 1,
                                  fontWeight: FontWeight.w700,
                                  color: Colors.black),
                            ),
                            SizedBox(
                              height: 5,
                            ),

                            ///Row for food name
                            Text(
                              foodName,
                              style: TextStyle(
                                  letterSpacing: 1,
                                  fontSize: 10,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.deepOrangeAccent),
                            ),
                            SizedBox(
                              height: 10,
                            ),

                            ///Row for price
                            Text(
                              '₵ $price 0 ',
                              style: TextStyle(
                                  letterSpacing: 1,
                                  fontSize: 10,
                                  fontWeight: FontWeight.w700,
                                  color: Colors.black87),
                            ),
                            SizedBox(
                              height: 10,
                            ),

                            ///Row for location
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              children: [
                                Icon(Icons.location_on_outlined,
                                    color: Colors.deepOrangeAccent, size: 13),
                                Text(
                                  location,
                                  style: TextStyle(
                                      letterSpacing: 2,
                                      fontSize: 12,
                                      //fontWeight: FontWeight.bold,
                                      color: Colors.deepOrangeAccent),
                                ),
                              ],
                            ),
                            SizedBox(
                              height: 10,
                            ),

                            ///Row for time and id
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              children: [
                                Icon(Icons.timelapse_rounded,
                                    color: Colors.black, size: 10),
                                Text(
                                  time,
                                  style: TextStyle(
                                      fontSize: 10,
                                      //fontWeight: FontWeight.bold,
                                      color: Colors.black),
                                ),
                                SizedBox(
                                  width: 15,
                                ),
                                Icon(Icons.payment_outlined,
                                    color: Colors.black, size: 10),
                                Text(
                                  '  $id',
                                  style: TextStyle(
                                      letterSpacing: 3,
                                      fontSize: 10,
                                      //fontWeight: FontWeight.bold,
                                      color: Colors.black),
                                ),
                              ],
                            )
                          ],
                        ),
                      )
                    ],
                  ),
                )),
          );
        },
        itemCount: 1,
        shrinkWrap: true,
        physics: NeverScrollableScrollPhysics(),
      ),
    ],
  );
}
