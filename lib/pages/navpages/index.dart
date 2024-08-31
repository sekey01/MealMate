import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:mealmate/AdminPanel/Pages/IncomingOrdersPage.dart';
import 'package:mealmate/AdminPanel/components/adminHorizontalCard.dart';
import 'package:mealmate/components/Notify.dart';
import 'package:mealmate/pages/detail&checkout/detail.dart';
import 'package:mealmate/pages/navpages/cart.dart';
import 'package:mealmate/pages/navpages/profile.dart';
import 'package:mealmate/pages/navpages/searchByCollection.dart';
import 'package:provider/provider.dart';

import '../../UserLocation/LocationProvider.dart';
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
  ///SIMPLE FETCH FOOD FROM DB TO INDEX PAGE METHOD THAT REQUIRES ONLY COLLECTION NAME
  ///
  ///
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
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      appBar: AppBar(
        leading: Padding(
          padding: const EdgeInsets.all(8.0),
          child: GestureDetector(
              onTap: (){
                Navigator.push(context, MaterialPageRoute(builder: (context)=> Profile()));
              },
              child: CircleAvatar(
                  backgroundColor: Colors.black,
                  child: ImageIcon(AssetImage('assets/Icon/profile.png'), color: Colors.white, ))),
        ),
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
              child: ImageIcon(AssetImage(
                'assets/Icon/Cart.png'
              ), color: Colors.blueGrey,size: 25.sp,
            ),
            ),
          ),
          SizedBox(
            width: 40.w,
          ),
        ],
        title: Text('MealMate'),
        titleTextStyle: TextStyle(
            color: Colors.blueGrey,
            fontWeight: FontWeight.bold,
            letterSpacing: 3,
            fontSize: 20.sp),
        backgroundColor: Colors.transparent,
      ),
      body: Center(
        child: SafeArea(
          child: SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.all(6.0),
              child: Column(
                children: [
                  Padding(padding: EdgeInsets.all(3), child:     FutureBuilder(
                      future:
                      Provider.of<LocationProvider>(context, listen: false)
                          .determinePosition(),
                      builder: (context, snapshot) {
                        if (snapshot.hasData) {
                          return Text(snapshot.data.toString(),
                              style: TextStyle(
                                  overflow: TextOverflow.ellipsis,
                                  color: Colors.black,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 10.sp));
                        }
                        return Text(
                          'locating you...',
                          style: TextStyle(color: Colors.blueGrey,fontWeight: FontWeight.normal),
                        );
                      }),),
                  SizedBox(height: 20,),
                  ///CARD SHOWING THE INTRODUCTION OF THE APP AND COUROSEL OF IMAGES
                  initCard(),
                  SizedBox(
                    height: 20.h,
                  ),
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
                              fontWeight: FontWeight.w800,
                              letterSpacing: 2,
                              color: Colors.blueGrey,
                            ),
                          ),
                          Text(
                            'More Delicious Foods 😋  ',
                            style: TextStyle(
                              fontSize: 15.sp,
                              fontWeight: FontWeight.w700,
                              letterSpacing: 2,
                              color: Colors.deepOrange,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ]),
                  SizedBox(
                    height: 20.h,
                  ),
                  Padding(padding: EdgeInsets.all(10), child: Image(image: AssetImage('assets/images/MMBoard.png')),),
                  SizedBox(
                    height: 40.h,
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
                    height: 20,
                  ),

                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Padding(
                        padding: const EdgeInsets.all(4.0),
                        child: Text(
                          ' 🏪 Stores Near You ',
                          style: TextStyle(
                              color: Colors.blueGrey,
                              fontSize: 10,
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
                                fontSize: 10, color: Colors.deepOrangeAccent),
                          ),
                        ),
                      )
                    ],
                  ),
                  Container(
                    color: Colors.white,
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
                                  child: GestureDetector(
                                    onTap: () {

                                      foodItem.isAvailable?Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                              builder: (context) =>
                                                  DetailedCard(
                                                      imgUrl:
                                                          foodItem.imageUrl,
                                                      restaurant:
                                                          foodItem.restaurant,
                                                      foodName:
                                                          foodItem.foodName,
                                                      price: foodItem.price,
                                                      location:
                                                          foodItem.location,
                                                      vendorid:
                                                          foodItem.vendorId,
                                                      time: foodItem.time))) :  Notify(context, 'This item is not Avable now', Colors.white) ;
                                    },
                                    child: verticalCard(
                                        foodItem.imageUrl,
                                        foodItem.restaurant,
                                        foodItem.foodName,
                                        foodItem.price,
                                        foodItem.location,
                                        foodItem.time,
                                        foodItem.vendorId.toString(),
                                        foodItem.isAvailable),
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

                  Padding(padding: EdgeInsets.all(8), child: Image(image: AssetImage('assets/images/MMBoard1.png')),),

                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Text(
                          '   Drinks 🍹🍷 ',
                          style: TextStyle(
                              color: Colors.blueGrey,
                              fontSize: 10.sp,
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
                                fontSize: 10.sp, color: Colors.deepOrangeAccent),
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
                    color: Colors.white,
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

                                        foodItem.isAvailable?Navigator.push(
                                            context,
                                            MaterialPageRoute(
                                                builder: (context) =>
                                                    DetailedCard(
                                                        imgUrl:
                                                            foodItem.imageUrl,
                                                        restaurant:
                                                            foodItem.restaurant,
                                                        foodName:
                                                            foodItem.foodName,
                                                        price: foodItem.price,
                                                        location:
                                                            foodItem.location,
                                                        vendorid:
                                                            foodItem.vendorId,
                                                        time: foodItem.time))):Notify(context, 'This item is not Available now', Colors.white);
                                      },
                                      child: verticalCard(
                                        foodItem.imageUrl,
                                        foodItem.restaurant,
                                        foodItem.foodName,
                                        foodItem.price,
                                        foodItem.location,
                                        foodItem.time,
                                        foodItem.vendorId.toString(),
                                        foodItem.isAvailable
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
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
