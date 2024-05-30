import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:mealmate/components/detailedCard.dart';
import 'package:mealmate/pages/detail&checkout/detail.dart';
import 'package:mealmate/pages/navpages/cart.dart';
import 'package:mealmate/pages/navpages/search.dart';
import 'package:provider/provider.dart';

import '../../components/adsCouressel.dart';
import '../../components/card1.dart';
import '../../components/horizontalCard.dart';
import '../../components/verticalCard.dart';
import '../../models&ReadCollectionModel/ListFoodItemModel.dart';
import '../../models&ReadCollectionModel/cartmodel.dart';

class Index extends StatefulWidget {
  const Index({super.key});

  @override
  State<Index> createState() => _IndexState();
}

class _IndexState extends State<Index> {
  Future<List<FoodItem>> fetchFoodItems(String Collection) async {
    try {
      QuerySnapshot snapshot =
          await FirebaseFirestore.instance.collection(Collection).get();
      return snapshot.docs
          .map((doc) =>
              FoodItem.fromMap(doc.data() as Map<String, dynamic>, doc.id))
          .toList();
    } catch (e) {
      print("Error fetching food items: $e");
      return [];
    }
  }

  final textController = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey.shade100,
      appBar: AppBar(
        automaticallyImplyLeading: false,
        centerTitle: true,
        actions: [
          GestureDetector(
            onTap: () {
              Navigator.push(
                  context, MaterialPageRoute(builder: (context) => Cart()));
            },
            child: Badge(
              backgroundColor: Colors.black,
              label: Consumer<CartModel>(
                  builder: (context, value, child) => Text(
                        value.cart.length.toString(),
                        style: TextStyle(
                            color: Colors.white, fontWeight: FontWeight.bold),
                      )),
              child: Icon(
                size: 30,
                Icons.shopping_cart_outlined,
                color: Colors.white,
              ),
            ),
          ),
          SizedBox(
            width: 40,
          ),
        ],
        title: Text('MealMate'),
        titleTextStyle: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
            letterSpacing: 3,
            fontSize: 17),
        backgroundColor: Colors.deepOrange,
      ),
      body: Center(
        child: SafeArea(
          child: SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.all(6.0),
              child: Column(
                children: [
                  ///CARD SHOWING THE INTRODUCTION OF THE APP AND COUROSEL OF IMAGES
                  initCard(),
                  Wrap(children: [
                    Padding(
                      padding: const EdgeInsets.all(4.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          Text(
                            'LETS EXPLORE  ',
                            style: TextStyle(
                              fontSize: 35,
                              fontWeight: FontWeight.w500,
                              letterSpacing: 2,
                              color: Colors.black,
                            ),
                          ),
                          Text(
                            'More Delicious Foods 😋  ',
                            style: TextStyle(
                              fontSize: 25,
                              fontWeight: FontWeight.w400,
                              letterSpacing: 2,
                              color: Colors.deepOrange,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ]),
                  SizedBox(
                    height: 10,
                  ),

                  ///COURRESSEL  FOR ADS
                  Badge(
                      backgroundColor: Colors.green,
                      textColor: Colors.white,
                      label: Text(
                        'Ads 📢',
                      ),
                      child: adsCouressel()),

                  SizedBox(
                    height: 21,
                  ),

                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Padding(
                        padding: const EdgeInsets.all(4.0),
                        child: Text(
                          ' 🏪 Stores Near You ',
                          style: TextStyle(
                              color: Colors.black87,
                              fontSize: 15,
                              fontWeight: FontWeight.bold),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: GestureDetector(
                          onTap: () {
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => Search()));
                          },
                          child: Text(
                            'see more',
                            style: TextStyle(
                                fontSize: 15, color: Colors.deepOrangeAccent),
                          ),
                        ),
                      )
                    ],
                  ),
                  Container(
                    color: Colors.grey.shade300,
                    width: double.infinity,
                    height: 200,
                    child: FutureBuilder<List<FoodItem>>(
                      future: fetchFoodItems('Food 🍔'),
                      builder: (context, snapshot) {
                        if (snapshot.connectionState ==
                            ConnectionState.waiting) {
                          return Center(child: CircularProgressIndicator());
                        } else if (snapshot.hasError) {
                          return Center(
                              child: Text('Error: ${snapshot.error}'));
                        } else if (!snapshot.hasData ||
                            snapshot.data!.isEmpty) {
                          return Center(child: Text('No food items found.'));
                        } else {
                          return ListView.builder(
                            itemCount: snapshot.data!.length,
                            itemBuilder: (context, index) {
                              final foodItem = snapshot.data![index];
                              return Padding(
                                  padding: const EdgeInsets.all(4.0),
                                  child: Material(
                                    elevation: 2,
                                    child: GestureDetector(
                                      onTap: () {
                                        Navigator.push(
                                            context,
                                            MaterialPageRoute(
                                                builder: (context) => Detail(
                                                        detail: detailedCard(
                                                      foodItem.imageUrl,
                                                      foodItem.restaurant,
                                                      foodItem.foodName,
                                                      foodItem.price,
                                                      foodItem.location,
                                                      foodItem.vendorId,
                                                      foodItem.time,
                                                    ))));
                                      },
                                      child: verticalCard(
                                        foodItem.imageUrl,
                                        foodItem.restaurant,
                                        foodItem.foodName,
                                        foodItem.price,
                                        foodItem.location,
                                        foodItem.time,
                                        foodItem.vendorId.toString(),
                                      ),
                                    ),
                                  ));
                            },
                            scrollDirection: Axis.horizontal,
                          );
                        }
                      },
                    ),
                  ),
                  SizedBox(
                    height: 30,
                  ),

                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Padding(
                        padding: const EdgeInsets.all(4.0),
                        child: Text(
                          '   Drinks 🍹🍷 ',
                          style: TextStyle(
                              color: Colors.black87,
                              fontSize: 15,
                              fontWeight: FontWeight.bold),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: GestureDetector(
                          onTap: () {
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => Search()));
                          },
                          child: Text(
                            'see more',
                            style: TextStyle(
                                fontSize: 15, color: Colors.deepOrangeAccent),
                          ),
                        ),
                      )
                    ],
                  ),

                  ///CONTAINER OF HRORINZAOL LIST OF DRINKS
                  ///
                  ///
                  ///
                  ///
                  Container(
                    color: Colors.grey.shade300,
                    width: double.infinity,
                    height: 200,
                    child: FutureBuilder<List<FoodItem>>(
                      future: fetchFoodItems('Drinks 🍷'),
                      builder: (context, snapshot) {
                        if (snapshot.connectionState ==
                            ConnectionState.waiting) {
                          return Center(child: CircularProgressIndicator());
                        } else if (snapshot.hasError) {
                          return Center(
                              child: Text('Error: ${snapshot.error}'));
                        } else if (!snapshot.hasData ||
                            snapshot.data!.isEmpty) {
                          return Center(child: Text('No food items found.'));
                        } else {
                          return ListView.builder(
                            itemCount: snapshot.data!.length,
                            itemBuilder: (context, index) {
                              final foodItem = snapshot.data![index];
                              return Padding(
                                  padding: const EdgeInsets.all(4.0),
                                  child: Material(
                                    elevation: 2,
                                    child: GestureDetector(
                                      onTap: () {
                                        Navigator.push(
                                            context,
                                            MaterialPageRoute(
                                                builder: (context) => Detail(
                                                        detail: detailedCard(
                                                      foodItem.imageUrl,
                                                      foodItem.restaurant,
                                                      foodItem.foodName,
                                                      foodItem.price,
                                                      foodItem.location,
                                                      foodItem.vendorId,
                                                      foodItem.time,
                                                    ))));
                                      },
                                      child: horizontalCard(
                                        foodItem.imageUrl,
                                        foodItem.restaurant,
                                        foodItem.foodName,
                                        foodItem.price,
                                        foodItem.location,
                                        foodItem.time,
                                        foodItem.vendorId,
                                      ),
                                    ),
                                  ));
                            },
                            scrollDirection: Axis.vertical,
                          );
                        }
                      },
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
