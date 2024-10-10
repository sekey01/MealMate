import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:mealmate/components/cartlist.dart';
import 'package:provider/provider.dart';

import '../../models&ReadCollectionModel/cartmodel.dart';

class Cart extends StatefulWidget {
  const Cart({super.key});

  @override
  State<Cart> createState() => _CartState();
}

class _CartState extends State<Cart> {
  @override
  Widget build(BuildContext context) {
    return Consumer<CartModel>(
        builder: (context, value, child) => Scaffold(
          backgroundColor: Theme.of(context).scaffoldBackgroundColor,
              appBar: AppBar(
                // automaticallyImplyLeading: false,
                title: Text(
                  'Favourites',
                  style: TextStyle(
                      color: Colors.blueGrey,
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      letterSpacing: 3),
                ),
                centerTitle: true,
                backgroundColor: Colors.white,
                actions: [
                  Badge(
                    backgroundColor: Colors.black,
                    label: Consumer<CartModel>(
                        builder: (context, value, child) => Text(
                              value.cart.length.toString(),
                              style: TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold),
                            )),
                    child: ImageIcon(
                      AssetImage('assets/Icon/favourite.png'),
                      size: 30,
                      color: Colors.blueGrey,
                    ),
                  ),
                  SizedBox(
                    width: 30,
                  )
                ],
              ),

          /// THE value  IN THE BUILDER IS WHAT I WILL USE AS REFERENCE TO CALL ALL THAT I WANT TO CALL ION THE THE CartModel()
          ///
          ///
              body: Center(
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: ListView.builder(
                      itemCount: value.cart.length,
                      itemBuilder: (context, index) {
                        ///Get food item and its properties from Cart
                        final CartFood food = value.cart[index];

                        ///Get food imgUrl
                        final String imgUrl = food.imgUrl;

                        ///Get restaurant
                        final String restaurant = food.restaurant;

                        ///Get foodName
                        final String foodName = food.foodName;

                        ///Get price
                        final double price = food.price;

                        ///Get id
                        final int id = food.id;
                        return cartList(
                            imgUrl, restaurant, foodName, price, id);
                      }),
                ),
              ),
              //bottom sheet
              bottomSheet: Material(
                color: Colors.white,
                elevation: 3,
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(20),
                  topRight: Radius.circular(20),
                ),
                child: Container(
                  margin: EdgeInsets.all(10),
                  height: 130.h,
                  width: double.infinity,
                  color: Colors.white,
                  child: Center(
                      child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      SizedBox(height: 10),
                      Text(
                        'Total Price: ${value.tPrice}0',
                        style: TextStyle(
                            color: Colors.black,
                            fontSize: 15,
                            fontWeight: FontWeight.bold,
                            letterSpacing: 3),
                      ),
                      SizedBox(height: 10),
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
                          'CheckOut',
                          style: TextStyle(
                            letterSpacing: 2,
                            color: Colors.white,
                            fontWeight: FontWeight.normal,
                          ),
                        ),
                      ),
                    ],
                  )),
                ),
              ),
            ));
  }
}
