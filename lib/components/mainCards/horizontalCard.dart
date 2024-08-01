import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../pages/detail&checkout/detail.dart';

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
                      builder: (context) => DetailedCard(
                          imgUrl: imgUrl,
                          restaurant: restaurant,
                          foodName: foodName,
                          price: price,
                          location: location,
                          vendorid: id,
                          time: time)));
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
                        child: imgUrl.isEmpty
                            ? Center(
                                child: Icon(
                                  ///NO IMAGE ICON WHEN THE IMAGE URL IS EMPTY
                                  ///
                                  Icons.image_not_supported_outlined,
                                  color: Colors.deepOrange,
                                  size: 120,
                                ),
                              )
                            : ClipRRect(
                                borderRadius: BorderRadius.circular(13),
                                child: Image(
                                  fit: BoxFit.fill,
                                  image: NetworkImage(imgUrl),
                                  height: 90,
                                  width: 120,
                                ),
                              ),
                      ),
                      SizedBox(
                        width: 10.w,
                      ),
                      Container(
                        color: Colors.white,
                        child: Column(
                          //Column to Shaow Name OF Restaurant,Food Name, and Price Of the Food
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                          children: [
                            SizedBox(
                              height: 5,
                            ),

                            ///Row for restaurant name
                            Text(
                              restaurant,
                              style: TextStyle(
                                fontSize: 10,
                                letterSpacing: 2,
                                fontWeight: FontWeight.w700,
                                color: Colors.black,
                              ),
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
                              'GHC ${price}0 ',
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
                                      fontStyle: FontStyle.italic,
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
