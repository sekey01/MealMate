import 'package:card_loading/card_loading.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:mealmate/AdminPanel/OtherDetails/AdminFunctionsProvider.dart';
import 'package:provider/provider.dart';
import 'package:rflutter_alert/rflutter_alert.dart';

ListView adminHorizontalCard(String imgUrl, String restaurant, String location,
    String foodName, double price, int id, String time, bool isAvailable) {
  return ListView.builder(
    itemBuilder: (context, index) {
      return Padding(
          padding: const EdgeInsets.all(4.0),
          child: Container(
            color: Colors.white,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Badge(
                  alignment: Alignment.topCenter,
                  textStyle:
                      TextStyle(fontSize: 10.sp, fontWeight: FontWeight.bold),
                  textColor: Colors.white,
                  label: Text(
                    (isAvailable) ? 'Online' : 'Not Available',
                  ),
                  backgroundColor: (isAvailable) ? Colors.green : Colors.red,
                  child: Container(
                    margin: EdgeInsets.all(2),
                    color: Colors.white,

                    ///I CHECKED WHETHERE THE IMAGE URL IS EMPTY AND INDICATE THE UPLOADER
                    ///
                    ///
                    child: imgUrl.isEmpty
                        ? Center(
                            child: Icon(
                              ///NO IMAGE ICON WHEN THE IMAGE URL IS EMPTY
                              ///
                              Icons.image_not_supported_outlined,
                              color: Colors.deepOrange,
                              size: 120.sp,
                            ),
                          )
                        : ClipRRect(
                            borderRadius: BorderRadius.circular(13),
                            child: Image(
                              fit: BoxFit.fill,
                              image: NetworkImage(imgUrl),
                              height: 150.h,
                              width: 150.w,
                            ),
                          ),
                  ),
                ),
                SizedBox(
                  width: 20.w,
                ),
                Container(
                  height: 200,
                  color: Colors.white,
                  child: Column(
                    //Column to Shaow Name OF Restaurant,Food Name, and Price Of the Food
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
                              color: Colors.deepOrangeAccent, size: 10),
                          Text(
                            location,
                            style: TextStyle(
                                fontSize: 8,
                                //fontWeight: FontWeight.bold,
                                color: Colors.deepOrangeAccent),
                          ),
                        ],
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
                                fontSize: 8,
                                //fontWeight: FontWeight.bold,
                                color: Colors.black),
                          ),
                          SizedBox(
                            width: 10,
                          ),
                          Icon(Icons.payment_outlined,
                              color: Colors.black, size: 10),
                          Text(
                            '  $id',
                            style: TextStyle(
                                fontSize: 8,
                                //fontWeight: FontWeight.bold,
                                color: Colors.black),
                          ),
                        ],
                      ),
                      SizedBox(
                        height: 25,
                      ),

                      ///THE BUTTON THAT DELETES THE FOOD ITEM
                      ///
                      ///
                      TextButton(
                          onPressed: () {
                            Alert(
                                    context: context,
                                    // type: AlertType.warning,

                                    title:
                                        ' Are you sure you want to delete this food ?',
                                    content: Center(
                                      child: CardLoading(
                                          height: 20,
                                          child: Consumer<AdminFunctions>(
                                            builder: (context, value, child) =>
                                                TextButton(
                                                    onPressed: () {
                                                      value.deleteItem(
                                                          context, imgUrl);
                                                      Navigator.pop(context);
                                                    },
                                                    child: Text('Y e s')),
                                          )),
                                    ),
                                    style: AlertStyle(
                                        animationDuration:
                                            Duration(milliseconds: 500),
                                        alertPadding: EdgeInsets.all(66),
                                        backgroundColor: Colors.white,
                                        animationType: AnimationType.shrink))
                                .show();
                          },
                          child: Text(
                            'Delete',
                            style: TextStyle(
                                fontWeight: FontWeight.bold,
                                color: Colors.deepOrangeAccent),
                          ))
                    ],
                  ),
                ),
              ],
            ),
          ));
    },
    itemCount: 1,
    shrinkWrap: true,
    physics: NeverScrollableScrollPhysics(),
  );
}
