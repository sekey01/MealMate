import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:internet_connectivity_checker/internet_connectivity_checker.dart';
import 'package:mealmate/Local_Storage/Locall_Storage_Provider/StoreCredentials.dart';
import 'package:mealmate/UserLocation/LocationProvider.dart';
import 'package:mealmate/components/NoFoodFound.dart';
import 'package:mealmate/components/NoInternet.dart';
import 'package:mealmate/components/mainCards/Anouncement.dart';
import 'package:mealmate/pages/detail&checkout/detail.dart';
import 'package:mealmate/pages/navpages/cart.dart';
import 'package:mealmate/pages/navpages/profile.dart';
import 'package:mealmate/pages/navpages/searchByCollection.dart';
import 'package:provider/provider.dart';

import '../../components/CustomLoading.dart';
import '../../components/adsCouressel.dart';
import '../../components/card1.dart';
import '../../components/mainCards/horizontalCard.dart';
import '../../components/mainCards/verticalCard.dart';
import '../../models&ReadCollectionModel/ListFoodItemModel.dart';
import '../../models&ReadCollectionModel/cartmodel.dart';

class Index extends StatefulWidget {
  const Index({super.key});

  @override
  State<Index> createState() => _IndexState();
}

class _IndexState extends State<Index> {
  /// THIS FUNCTION FETCHES THE FOOD ITEMS FROM THE COLLECTION SELECTED BY THE USER
  Future<List<FoodItem>> fetchFoodItems(String collection) async {
    try {
      QuerySnapshot snapshot =
          await FirebaseFirestore.instance.collection(collection).get();
      return snapshot.docs
          .map((doc) =>
              FoodItem.fromMap(doc.data() as Map<String, dynamic>, doc.id))
          .toList();
    } on SocketException catch (e) {
      // Handle SocketException (network related)
      print("SocketException: $e");
      throw "Internet connection problem";
    } on FirebaseException catch (e) {
      // print("Firebase Error: $e");
      throw "Firebase Error: $e"; // Throw a specific error message for Firebase errors
    } catch (e) {
      // print("Error fetching food items: $e");
      throw "Error fetching food items"; // Throw a generic error message for other exceptions
    }
  }

  final textController = TextEditingController();
  @override
  initState() {
    super.initState();
    Provider.of<LocalStorageProvider>(context, listen: false).getPhoneNumber();
  }

  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.white /*Colors.grey.shade100*/,
        appBar: AppBar(
          leading:

              ///Profile Logo
              IconButton(
                  onPressed: () {
                    Navigator.push(context,
                        MaterialPageRoute(builder: (context) => Profile()));
                  },
                  icon: ImageIcon(
                    AssetImage('assets/Icon/profile.png'),
                    color: Colors.black,
                    size: 35,
                  )),
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
                child: ImageIcon(
                    size: 30,
                    color: Colors.black,
                    AssetImage('assets/Icon/Cart.png')),
              ),
            ),
            SizedBox(width: 20),
            SizedBox(
              width: 10,
            )
          ],
          title: Text('MealMate'),
          titleTextStyle: TextStyle(
              color: Colors.black,
              fontWeight: FontWeight.normal,
              letterSpacing: 3.sp,
              fontSize: 20.sp),
          backgroundColor: Colors.white,
        ),
        body: Center(
          child: SafeArea(
            child: SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.all(6.0),
                child: Column(
                  children: [
                    ///DISPLAY LOCATION OF USER
                    ///
                    Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        Padding(
                          padding: const EdgeInsets.all(2.0),
                          child: GestureDetector(
                            onTap: () {},
                            child: Icon(
                              size: 20.sp,
                              Icons.location_on_outlined,
                              color: Colors.black,
                            ),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.all(4.0),
                          child: FutureBuilder(
                              future: Provider.of<LocationProvider>(context,
                                      listen: false)
                                  .determinePosition(),
                              builder: (context, snapshot) {
                                if (snapshot.hasData) {
                                  return Text(snapshot.data.toString(),
                                      style: TextStyle(
                                          overflow: TextOverflow.ellipsis,
                                          color: Colors.black,
                                          fontSize: 10.sp));
                                }
                                return Text(
                                  'locating you...',
                                  style: TextStyle(color: Colors.black),
                                );
                              }),
                        ),
                      ],
                    ),

                    ///CARD SHOWING THE INTRODUCTION OF THE APP AND COUROSEL OF IMAGES
                    ///
                    ///
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
                                fontSize: 20.sp,
                                fontWeight: FontWeight.bold,
                                letterSpacing: 2,
                                color: Colors.black,
                              ),
                            ),
                            Text(
                              'Get the Best Pizza Sellers Near You and get rewarded... ',
                              style: TextStyle(
                                fontSize: 15.sp,
                                fontWeight: FontWeight.normal,
                                letterSpacing: 2,
                                color: Colors.black,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ]),
                    SizedBox(
                      height: 10.h,
                    ),

                    ///COURRESSEL  FOR ADS
                    Padding(
                      padding: const EdgeInsets.all(12.0),
                      child: Badge(
                          backgroundColor: Colors.deepOrangeAccent,
                          textColor: Colors.white,
                          label: Text(
                            'Ads📢',
                          ),
                          child: adsCouressel()),
                    ),

                    SizedBox(
                      height: 21.h,
                    ),

                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        /// THIS IS THE FIRST CONTAINER OF HORIZONTAL LIST OF "STORES NEAR YOU"  ITEMS
                        Container(
                          child: Row(children: [
                            Padding(
                                padding: const EdgeInsets.all(14.0),
                                child: ClipRRect(
                                    borderRadius: BorderRadius.circular(10),
                                    child: Image(
                                      image:
                                          AssetImage("assets/Icon/Grocery.png"),
                                      height: 40,
                                    ))),
                            Text(
                              'Stores Near  ',
                              style: TextStyle(
                                  color: Colors.black,
                                  fontSize: 10,
                                  fontWeight: FontWeight.bold),
                            ),
                          ]),
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
                                  fontSize: 10, color: Colors.deepOrangeAccent),
                            ),
                          ),
                        )
                      ],
                    ),

                    /// THIS IS THE FIRST CONTAINER OF HORIZONTAL LIST OF "STORES NEAR YOU"  ITEMS
                    /// IT DISPLAYS FOOD ITEMS FROM THE COLLECTION "Food 🍔"

                    Container(
                      color: Colors.white,
                      width: double.infinity,
                      height: 220,
                      child: FutureBuilder<List<FoodItem>>(
                        future: fetchFoodItems('Food 🍔'),
                        builder: (context, snapshot) {
                          if (snapshot.connectionState ==
                              ConnectionState.waiting) {
                            return Center(child: CustomLoGoLoading());
                          } else if (snapshot.hasError) {
                            String errorMessage = snapshot.error.toString();
                            if (errorMessage.contains(" SocketException")) {
                              return Center(
                                  child: Text('No Internet Connection'));
                            } else {
                              return Center(
                                  child: Text('Error: $errorMessage'));
                            }
                          } else if (!snapshot.hasData ||
                              snapshot.data!.isEmpty) {
                            return Center(child: noFoodFound());
                          } else {
                            return ConnectivityBuilder(builder: (status) {
                              bool connected =
                                  status == ConnectivityStatus.online;
                              return connected
                                  ? ListView.builder(
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
                                                          builder: (context) => DetailedCard(
                                                              imgUrl: foodItem
                                                                  .imageUrl,
                                                              restaurant: foodItem
                                                                  .restaurant,
                                                              foodName: foodItem
                                                                  .foodName,
                                                              price: foodItem
                                                                  .price,
                                                              location: foodItem
                                                                  .location,
                                                              vendorid: foodItem
                                                                  .vendorId,
                                                              time: foodItem
                                                                  .time)));
                                                },
                                                child: verticalCard(
                                                    foodItem.imageUrl,
                                                    foodItem.restaurant,
                                                    foodItem.foodName,
                                                    foodItem.price,
                                                    foodItem.location,
                                                    foodItem.time,
                                                    foodItem.vendorId
                                                        .toString(),
                                                    foodItem.isAvailable),
                                              ),
                                            ));
                                      },
                                      scrollDirection: Axis.horizontal,
                                    )
                                  : Center(
                                      child: NoInternetConnection(),
                                    );
                            });
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
                        Container(
                          child: Row(children: [
                            Padding(
                                padding: const EdgeInsets.all(14.0),
                                child: ClipRRect(
                                    borderRadius: BorderRadius.circular(10),
                                    child: Image(
                                      image:
                                          AssetImage("assets/Icon/Drinks.png"),
                                      height: 40,
                                    ))),
                            Text(
                              'Drinks ',
                              style: TextStyle(
                                  color: Colors.black87,
                                  fontSize: 10,
                                  fontWeight: FontWeight.bold),
                            ),
                          ]),
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
                                  fontSize: 10, color: Colors.deepOrangeAccent),
                            ),
                          ),
                        )
                      ],
                    ),

                    ///CONTAINER OF HORIZONTAL LIST OF DRINKS
                    ///
                    ///
                    ///
                    ///
                    Padding(
                      padding: const EdgeInsets.all(10.0),
                      child: Container(
                          color: Colors.white,
                          width: double.infinity,
                          height: 200.h,
                          child: FutureBuilder<List<FoodItem>>(
                              future: fetchFoodItems('Drinks 🍷'),
                              builder: (context, snapshot) {
                                if (snapshot.connectionState ==
                                    ConnectionState.waiting) {
                                  return Center(child: CustomLoGoLoading());
                                } else if (snapshot.hasError) {
                                  return Center(
                                      child: Text('Error: ${snapshot.error}'));
                                } else if (!snapshot.hasData ||
                                    snapshot.data!.isEmpty) {
                                  return Center(
                                      child: Text('No food items found.'));
                                } else {
                                  ///CHECK INTERNET CONNECTION STATUS
                                  ///
                                  /// I WILL CVHANGE THIS LATER FOR THE WHOLE PAGE TO CHECK INTERNET CONNECTION
                                  /// I WILL USE THE CONNECTIVITY BUILDER TO CHECK INTERNET CONNECTION\
                                  ///
                                  return ConnectivityBuilder(builder: (status) {
                                    bool connected =
                                        status == ConnectivityStatus.online;
                                    return connected
                                        ? ListView.builder(
                                            itemCount: snapshot.data!.length,
                                            itemBuilder: (context, index) {
                                              final foodItem =
                                                  snapshot.data![index];
                                              return Padding(
                                                  padding:
                                                      const EdgeInsets.all(4.0),
                                                  child: Material(
                                                    color: Colors.white,
                                                    elevation: 2,
                                                    child: GestureDetector(
                                                      onTap: () {
                                                        Navigator.push(
                                                            context,
                                                            MaterialPageRoute(
                                                                builder: (context) => DetailedCard(
                                                                    imgUrl: foodItem
                                                                        .imageUrl,
                                                                    restaurant:
                                                                        foodItem
                                                                            .restaurant,
                                                                    foodName: foodItem
                                                                        .foodName,
                                                                    price: foodItem
                                                                        .price,
                                                                    location:
                                                                        foodItem
                                                                            .location,
                                                                    vendorid:
                                                                        foodItem
                                                                            .vendorId,
                                                                    time: foodItem
                                                                        .time)));
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
                                          )
                                        : Center(
                                            child: NoInternetConnection(),
                                          );
                                  });
                                }
                              })),
                    ),

                    SizedBox(
                      height: 30,
                    ),

                    ///ANOUNCEMENT HERE
                    ///
                    ///
                    ///
                    Padding(
                      padding: EdgeInsets.all(8),
                      child: Announcement(" Alert",
                          "Report all issues to our front desk \n  mealmate@gmail.com "),
                    ),

                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Container(
                          child: Row(children: [
                            Padding(
                                padding: const EdgeInsets.all(14.0),
                                child: ClipRRect(
                                    borderRadius: BorderRadius.circular(10),
                                    child: Image(
                                      image:
                                          AssetImage("assets/Icon/Grocery.png"),
                                      height: 40,
                                    ))),
                            Text(
                              'Grocery ',
                              style: TextStyle(
                                  color: Colors.black87,
                                  fontSize: 10,
                                  fontWeight: FontWeight.bold),
                            ),
                          ]),
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
                                  fontSize: 10.sp,
                                  color: Colors.deepOrangeAccent),
                            ),
                          ),
                        )
                      ],
                    ),

                    /// CONTAINER OF HORIZONTAL LIST OF GROCERIES
                    ///
                    ///
                    Padding(
                      padding: const EdgeInsets.all(10.0),
                      child: Container(
                        color: Colors.white,
                        width: double.infinity.w,
                        height: 200.h,
                        child: FutureBuilder<List<FoodItem>>(
                          future: fetchFoodItems('Grocery 🛒'),
                          builder: (context, snapshot) {
                            if (snapshot.connectionState ==
                                ConnectionState.waiting) {
                              return Center(child: CustomLoGoLoading());
                            } else if (snapshot.hasError) {
                              return Center(
                                  child: Text('Error: ${snapshot.error}'));
                            } else if (!snapshot.hasData ||
                                snapshot.data!.isEmpty) {
                              return Center(
                                  child: Text('No food items found.'));
                            } else {
                              return ConnectivityBuilder(builder: (status) {
                                bool connected =
                                    status == ConnectivityStatus.online;
                                return connected
                                    ? ListView.builder(
                                        itemCount: snapshot.data!.length,
                                        itemBuilder: (context, index) {
                                          final foodItem =
                                              snapshot.data![index];
                                          return Padding(
                                              padding:
                                                  const EdgeInsets.all(4.0),
                                              child: Material(
                                                color: Colors.white,
                                                elevation: 2,
                                                child: GestureDetector(
                                                  onTap: () {
                                                    Navigator.push(
                                                        context,
                                                        MaterialPageRoute(
                                                            builder: (context) => DetailedCard(
                                                                imgUrl: foodItem
                                                                    .imageUrl,
                                                                restaurant: foodItem
                                                                    .restaurant,
                                                                foodName: foodItem
                                                                    .foodName,
                                                                price: foodItem
                                                                    .price,
                                                                location: foodItem
                                                                    .location,
                                                                vendorid: foodItem
                                                                    .vendorId,
                                                                time: foodItem
                                                                    .time)));
                                                  },
                                                  child: verticalCard(
                                                      foodItem.imageUrl,
                                                      foodItem.restaurant,
                                                      foodItem.foodName,
                                                      foodItem.price,
                                                      foodItem.location,
                                                      foodItem.time,
                                                      foodItem.vendorId
                                                          .toString(),
                                                      foodItem.isAvailable),
                                                ),
                                              ));
                                        },
                                        scrollDirection: Axis.horizontal,
                                      )
                                    : Center(
                                        child: NoInternetConnection(),
                                      );
                              });
                            }
                          },
                        ),
                      ),
                    ),

                    SizedBox(
                      height: 30,
                    ),

                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Container(
                          child: Row(children: [
                            Padding(
                                padding: const EdgeInsets.all(14.0),
                                child: ClipRRect(
                                    borderRadius: BorderRadius.circular(10),
                                    child: Image(
                                      image: AssetImage(
                                          "assets/Icon/Clothing.png"),
                                      height: 40,
                                    ))),
                            Text(
                              'Clothings ',
                              style: TextStyle(
                                  color: Colors.black87,
                                  fontSize: 10,
                                  fontWeight: FontWeight.bold),
                            ),
                          ]),
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
                                  fontSize: 10.sp,
                                  color: Colors.deepOrangeAccent),
                            ),
                          ),
                        )
                      ],
                    ),

                    /// CONTAINER OF HORIZONTAL LIST OF CLOTHES
                    ///
                    ///
                    Padding(
                      padding: const EdgeInsets.all(10.0),
                      child: Container(
                        color: Colors.white,
                        width: double.infinity,
                        height: 250.h,
                        child: FutureBuilder<List<FoodItem>>(
                          future: fetchFoodItems('Clothing 👗'),
                          builder: (context, snapshot) {
                            if (snapshot.connectionState ==
                                ConnectionState.waiting) {
                              return Center(child: CustomLoGoLoading());
                            } else if (snapshot.hasError) {
                              return Center(
                                  child: Text('Error: ${snapshot.error}'));
                            } else if (!snapshot.hasData ||
                                snapshot.data!.isEmpty) {
                              return Center(child: noFoodFound());
                            } else {
                              return ConnectivityBuilder(builder: (status) {
                                bool connected =
                                    status == ConnectivityStatus.online;
                                return connected
                                    ? ListView.builder(
                                        itemCount: snapshot.data!.length,
                                        itemBuilder: (context, index) {
                                          final foodItem =
                                              snapshot.data![index];
                                          return Padding(
                                              padding:
                                                  const EdgeInsets.all(4.0),
                                              child: Material(
                                                color: Colors.white,
                                                elevation: 2,
                                                child: GestureDetector(
                                                  onTap: () {
                                                    Navigator.push(
                                                        context,
                                                        MaterialPageRoute(
                                                            builder: (context) => DetailedCard(
                                                                imgUrl: foodItem
                                                                    .imageUrl,
                                                                restaurant: foodItem
                                                                    .restaurant,
                                                                foodName: foodItem
                                                                    .foodName,
                                                                price: foodItem
                                                                    .price,
                                                                location: foodItem
                                                                    .location,
                                                                vendorid: foodItem
                                                                    .vendorId,
                                                                time: foodItem
                                                                    .time)));
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
                                      )
                                    : Center(
                                        child: NoInternetConnection(),
                                      );
                              });
                            }
                          },
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ));
  }
}
