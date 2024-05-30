import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:rflutter_alert/rflutter_alert.dart';

import '../models&ReadCollectionModel/cartmodel.dart';

SingleChildScrollView detailedCard(String imgUrl, String restaurant,
    String foodName, double price, String location, int id, String time) {
  double tPrice = price;

  return SingleChildScrollView(
    child: Material(
      color: Colors.white,
      elevation: 3,
      child: Container(
        width: double.infinity,
        height: 750,
        color: Colors.white70,
        child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
          Container(
            color: Colors.white,
            height: 280,
            width: 330,
            child: ClipRRect(
              borderRadius: BorderRadius.circular(20),

              ///IMAGE URL
              ///
              /// The AssetImage widget is used to load an image from an asset bundle.
              child: Image.network(
                imgUrl,
                fit: BoxFit.fill,
              ),
            ),
          ),
          SizedBox(
            height: 5,
          ),

          ///NAME OF RESTAURANT
          ///
          /// The Text widget is used to display a string of text with single style.
          Text(
            '$restaurant',
            style: TextStyle(
                fontSize: 15,
                fontWeight: FontWeight.w300,
                color: Colors.black,
                letterSpacing: 3),
          ),
          SizedBox(
            height: 5,
          ),

          ///NAME OF FOOD
          ///
          /// The Text widget is used to display a string of text with single style.
          Text(
            '$foodName',
            style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.w300,
                color: Colors.black,
                letterSpacing: 2),
          ),

          ///PRICE OF FOOD
          ///
          /// The Text widget is used to display a string of text with single style.
          Text(
            '₵ $price 0',
            style: TextStyle(
                fontSize: 20,
                letterSpacing: 3,
                // fontWeight: FontWeight.bold,
                color: Colors.deepOrangeAccent),
          ),

          SizedBox(
            height: 10,
          ),

          /// Row for location
          ///
          /// The Row widget is used to display its children in a horizontal array.
          Row(mainAxisAlignment: MainAxisAlignment.spaceEvenly, children: [
            Material(
              color: Colors.white,
              borderRadius: BorderRadius.circular(5),
              elevation: 3,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  SizedBox(
                    width: 10,
                  ),
                  Icon(
                    Icons.location_on,
                    color: Colors.deepOrangeAccent,
                  ),
                  SizedBox(
                    width: 5,
                  ),
                  Text(
                    '$location',
                    style: TextStyle(
                        color: Colors.deepOrangeAccent,
                        fontSize: 15,
                        overflow: TextOverflow.ellipsis,
                        letterSpacing: 3),
                  ),
                  SizedBox(
                    width: 5,
                  ),
                ],
              ),
            ),
            SizedBox(
              width: 10,
            ),
          ]),
          SizedBox(
            height: 20,
          ),

          /// ROW FOR ADDING AND REMOVING ITEMS
          ///
          /// The Row widget is used to display its children in a horizontal array.
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              //time
              Material(
                color: Colors.white,
                borderRadius: BorderRadius.circular(5),
                elevation: 3,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      Icons.timelapse_rounded,
                      color: Colors.black,
                    ),
                    Text(
                      '$time',
                      style: TextStyle(
                        color: Colors.black,
                        fontSize: 15,
                        //fontWeight: FontWeight.bold
                      ),
                    ),
                    SizedBox(
                      width: 10,
                    ),
                  ],
                ),
              ),
              SizedBox(
                width: 20,
              ),
              Icon(
                Icons.call,
                color: Colors.black,
                //semanticLabel: '30mins',
              ),
              Text(
                '$id',
                style: TextStyle(
                  color: Colors.deepOrangeAccent,
                  fontSize: 15,
                  //fontWeight: FontWeight.bold
                ),
              ),
            ],
          ),
          SizedBox(
            height: 10,
          ),

          /// TOTAL PRICE OF ONLY THIS FOOD ITEM AND NOT THE FULL CART PRICE
          ///
          /// THE PRICE OF FOOD ITEM IS DISPLAYED HERE
          ///
          ///
          Material(
            elevation: 2,
            color: Colors.white,
            child: Consumer<CartModel>(
              builder: (context, CartModel, child) {
                tPrice = CartModel.getQuantity * price;
                return Text(
                  '  Total: ₵${tPrice}0  ',
                  style: TextStyle(
                    color: Colors.black,
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                );
              },
            ),
          ),
          SizedBox(
            height: 10,
          ),
          Consumer<CartModel>(
            builder: (context, value, child) =>

                /// OR YOU CAN ADD THE FOOD ITEM TO CART AND PAY FOR ALL ITEMS IN THE CART
                ElevatedButton(
              style: ElevatedButton.styleFrom(
                elevation: 3,
                backgroundColor: Colors.deepOrangeAccent,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
              onPressed: () {
                value.add(CartFood(
                    imgUrl: imgUrl,
                    restaurant: restaurant,
                    foodName: foodName,
                    price: price,
                    id: id));

                Alert(
                  context: context,
                  style: AlertStyle(
                      backgroundColor: Colors.transparent,
                      alertPadding: EdgeInsets.all(88),
                      isButtonVisible: true,
                      descStyle: TextStyle(
                        color: Colors.green,
                        fontSize: 15,
                      )),
                  type: AlertType.success,
                  // title: "Success",
                  desc: "Food added to Cart",
                  buttons: [
                    DialogButton(
                      child: Text(
                        " Ok  ",
                        style: TextStyle(
                            color: Colors.black,
                            fontSize: 20,
                            fontWeight: FontWeight.bold),
                      ),
                      onPressed: () => Navigator.pop(context),
                      width: 100,
                    )
                  ],
                ).show();
              },
              child: Text(
                'Add to Cart',
                style: TextStyle(color: Colors.white),
              ),
            ),
          ),
          SizedBox(
            height: 20,
          ),

          /// Quanty decrese and add
          /// And CheckOut button
          ///
          ///
          ///
          ///
          ///
          ///
          Consumer<CartModel>(
              builder: (context, value, child) => Container(
                    ///Second background color of bottom sheet
                    margin: EdgeInsets.all(10),
                    height: 150,
                    width: double.infinity,
                    color: Colors.grey.shade200,
                    child: Center(
                        child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        SizedBox(height: 15),

                        ///ROW FOR INCREASING AND DECREASING THE QUANTITY OF FOOD ITEM
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            GestureDetector(
                              /// DECREMENT QUANTITY OF FOOD ITEM IN CART
                              onTap: () {
                                value.decrementQuantity();
                              },
                              child: Material(
                                color: Colors.deepOrangeAccent,
                                borderRadius: BorderRadius.circular(7),
                                elevation: 3,
                                child: Text(
                                  '  -  ',
                                  style: TextStyle(
                                      fontSize: 20,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.white),
                                ),
                              ),
                            ),
                            SizedBox(width: 15),
                            Material(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(7),
                              elevation: 3,
                              child: Text(
                                value.getQuantity.toString(),
                                // context.watch<CartModel>().getQuantity.toString(),
                                style: TextStyle(
                                    fontSize: 20,
                                    letterSpacing: 3,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.black),
                              ),
                            ),
                            SizedBox(width: 15),
                            GestureDetector(
                              /// INCREMENT QUANTITY OF FOOD ITEM IN CART
                              onTap: () {
                                value.incrementQuantity();
                              },
                              child: Material(
                                color: Colors.deepOrangeAccent,
                                borderRadius: BorderRadius.circular(7),
                                elevation: 3,
                                child: Text(
                                  '  +  ',
                                  style: TextStyle(
                                      fontSize: 20,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.white),
                                ),
                              ),
                            ),

                            ////////

                            /////
                            /////
                          ],
                        ),

                        SizedBox(height: 25),

                        ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            elevation: 3,
                            backgroundColor: Colors.deepOrangeAccent,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10),
                            ),
                          ),
                          onPressed: () {},
                          child: Text(
                            'Checkout',
                            style: TextStyle(color: Colors.white),
                          ),
                        ),
                        SizedBox(width: 20),
                      ],
                    )),
                  ))
        ]),
      ),
    ),
  );
}
