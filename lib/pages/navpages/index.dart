import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:internet_connection_checker_plus/internet_connection_checker_plus.dart';
import 'package:mealmate/Local_Storage/Locall_Storage_Provider/StoreCredentials.dart';

import 'package:mealmate/Notification/notification_Provider.dart';
import 'package:mealmate/components/NoInternet.dart';
import 'package:mealmate/components/mainCards/promotion_ads_card.dart';
import 'package:mealmate/pages/detail&checkout/detail.dart';
import 'package:mealmate/pages/navpages/profile.dart';
import 'package:mealmate/pages/navpages/searchByCollection.dart';
import 'package:mealmate/pages/searchfooditem/filters.dart';
import 'package:mealmate/pages/searchfooditem/init_row_search.dart';
import 'package:mealmate/pages/searchfooditem/searchFoodItem.dart';
import 'package:provider/provider.dart';

import '../../UserLocation/LocationProvider.dart';
import '../../components/Notify.dart';
import '../../components/adsCouressel.dart';
import '../../components/card1.dart';
import '../../components/mainCards/verticalCard.dart';
import '../../models&ReadCollectionModel/ListFoodItemModel.dart';
import '../searchfooditem/init_page_search.dart';
import 'notifications.dart';
import 'package:mealmate/components/CustomLoading.dart';


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
  bool _hasInternet = true;

  checkInternet() async {
    final listener = InternetConnection().onStatusChange.listen((InternetStatus status) {
      if (status == InternetStatus.connected) {
        setState(() {
          _hasInternet = true;
        });
        print('Connected');
      } else {
        setState(() {
          NoInternetNotify(context, 'Check internet Connection !', Colors.red);

          _hasInternet = false;

        });
        print('Not connected');
      }
    });

  }
  @override
  void initState() {
    super.initState();
    // Start listening to the internet connection status
checkInternet();
  }

  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      appBar: AppBar(
        ///APP BAR BACKGROUND
        backgroundColor: Colors.white,
       // elevation: 4,
        automaticallyImplyLeading: false,

        leading: Padding(
          padding: const EdgeInsets.all(8.0),
          child: GestureDetector(
              onTap: (){
                Navigator.push(context, MaterialPageRoute(builder: (context)=> Profile()));
              },
              child: CircleAvatar(
                radius: 10,
                  backgroundImage: AssetImage('assets/Icon/profile.png'),
                  )),
        ),
        centerTitle: true,
        actions: [

          SizedBox(
            width: 20.w,
          ),

          ///NOTIFICATION HERE
          ///
          GestureDetector(
            onTap: () {
              Navigator.push(
                  context, MaterialPageRoute(builder: (context) => Notice()));
            },
            child: Badge(
              backgroundColor: Colors.green,
              label: Consumer<NotificationProvider>(
                  builder: (context, value, child)
                  {
                   value.getUserNotifications();

                    return  Text(
                          value.userNotificationLength.toString(),
                          style: TextStyle(
                              color: Colors.white, fontWeight: FontWeight.bold),
                        );
                      }),
              child: ImageIcon(AssetImage(
                  'assets/Icon/notification.png'
              ), color: Colors.blueGrey,size: 30.spMin,
              ),
            ),
          ),


          SizedBox(
            width: 30.w,
          ),
        ],
        title: RichText(text: TextSpan(
          children: [
            TextSpan(text: "Meal", style: TextStyle(color: Colors.black, fontSize: 20.spMin, fontWeight: FontWeight.bold,fontFamily: 'Righteous',)),
            TextSpan(text: "Mate", style: TextStyle(color: Colors.deepOrangeAccent, fontSize: 20.spMin, fontWeight: FontWeight.bold,fontFamily: 'Righteous',)),


          ]
        )),
        titleTextStyle: TextStyle(
           // color: Colors.black,
            fontWeight: FontWeight.bold,
            letterSpacing: 1,
            fontSize: 20.spMin),

      ),
      body: Center(
        child: SafeArea(
          child: SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [

                  ///LOCATION DISPLAYED HERE
                  ///
                  SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    child: Padding(
                      padding: const EdgeInsets.only(bottom: 20),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          Icon(Icons.location_on_outlined, size: 20.sp,color: Colors.blueGrey,),
                          FutureBuilder(
                              future:
                              Provider.of<LocationProvider>(context, listen: false).determinePosition(),
                              builder: (context, snapshot) {
                                if (snapshot.hasData) {
                                  return Padding(
                                    padding: const EdgeInsets.all(2.0),
                                    child: Text(snapshot.data.toString(),
                                        overflow: TextOverflow.ellipsis,
                                        style: TextStyle(
                                            overflow: TextOverflow.ellipsis,
                                            color: Colors.black,
                                            fontWeight: FontWeight.bold,
                                            fontSize: 12.sp)),
                                  );
                                }
                                return Text(
                                  'locating you...',
                                  style: TextStyle(color: Colors.blueGrey,fontWeight: FontWeight.normal,fontSize: 10.spMin),
                                );
                              }),
                        ],
                      ),
                    ),
                  ),


                SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: Padding(
                    padding: const EdgeInsets.only(left: 0,right: 0),
                    child: Container(
                      //height: 80.h,
                      decoration: BoxDecoration(
                        color: Colors.grey.shade100,
                        borderRadius: BorderRadius.circular(10)
                      ),

                      child: Padding(
                        padding: const EdgeInsets.all(4.0),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            InkWell(
                            onTap: (){
                              Navigator.push(context, MaterialPageRoute(builder: (context)=> InitRowSearch(searchItem: 'chilzy')));
                            },
                                child: InitRow(imageUrl: 'assets/images/jollof.png',name: 'Jollof',)),
                            InkWell(
                              onTap: (){
                                Navigator.push(context, MaterialPageRoute(builder: (context)=> InitRowSearch(searchItem: 'Pizza')));
                              }
                            ,child: InitRow(imageUrl: 'assets/images/burger.png',name: 'Snacks',)),

                            InkWell(onTap: (){
                              Navigator.push(context, MaterialPageRoute(builder: (context)=> InitRowSearch(searchItem: 'groceries')));
                            }
                            ,child: InitRow(imageUrl: 'assets/images/shops.jpg',name: 'Grocery',)),

                            InkWell(
                            onTap: (){
                              Navigator.push(context, MaterialPageRoute(builder: (context)=> InitRowSearch(searchItem: 'Drinks')));
                            },
                            child: InitRow(imageUrl: 'assets/images/burger.png',name: 'Drinks',)),

                          ],
                        ),
                      ),
                    ),
                  ),
                ),

                //  SizedBox(height: 30.h,),



                  /// SEARCH BAR HERE
                  ///
                  Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: GestureDetector(
                      onTap: () {
                        Navigator.push(context, MaterialPageRoute(builder: (context)=> SearchFoodItem()));
                      },
                      child: AbsorbPointer(
                        child: Container(
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(10),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.grey.shade200,
                                spreadRadius: 2,
                                blurRadius: 5,
                                offset: Offset(0, 3), // changes position of shadow
                              ),
                            ],
                          ),
                          child: TextField(
                            style: TextStyle(color: Colors.deepOrange),
                            decoration: InputDecoration(
                              hintText: 'FoodName or Restaurant',
                              fillColor: Colors.white,
                              filled: true,
                              prefixIcon: Icon(
                                Icons.search,
                                color: Colors.blueGrey,
                              ),
                              suffixIcon: IconButton(
                                onPressed: () {
                                },
                                icon: ImageIcon(AssetImage('assets/Icon/filter.png'), color: Colors.blueGrey,),
                              ),
                              enabledBorder: OutlineInputBorder(
                                borderSide: BorderSide(
                                  color: Colors.grey.shade200,
                                  style: BorderStyle.solid,
                                ),
                                borderRadius: BorderRadius.circular(10),

                                ///borderSide: BorderSide(color: Colors.red),
                              ),
                              hintStyle: TextStyle(
                                color: Colors.grey,
                                fontSize: 15,
                              ),
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(10),
                                borderSide: BorderSide(
                                  color: Colors.blueGrey,
                                  style: BorderStyle.solid,
                                ),
                              ),
                              /*       label: Text('Foodnameee and Restaurant'),
                              labelStyle: TextStyle(color: Colors.grey, fontSize: 10),*/
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),

                  SizedBox(height: 10.h,),


                  ///FOOD DELIVERY AND SUPERMARKET AND SHOPS
                  Container(
                    height: 260.h,
                    width: double.infinity,
                    decoration: BoxDecoration(
                      color: Colors.grey.shade200,
                      borderRadius: BorderRadius.circular(10),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.grey.shade200,
                          spreadRadius: 2,
                          blurRadius: 5,
                          offset: Offset(0, 3), // changes position of shadow
                        ),
                      ],
                    ),

                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Row(

                        children: [
                          ///FOOD DELIVERY
                          Expanded(
                            flex: 2,
                            child: GestureDetector(
                              onTap: (){
                                Navigator.push(context, MaterialPageRoute(builder: (context)=> InitPageSearch(searchCollection: 'Food 🍔', Title: 'Food Delivery',)));

                              },
                              child: Container(

                                decoration: BoxDecoration(
                                  color: Colors.white,
                                  borderRadius: BorderRadius.circular(10),
                                ),
                                child: Column(
                                  children: [
                                    Padding(
                                      padding: const EdgeInsets.only(left: 8.0),
                                      child: Text(
                                        'Food Delivery',
                                        style: TextStyle(
                                          fontFamily: 'Righteous',
                                            color: Colors.black,
                                            fontSize: 35.sp,
                                            fontWeight: FontWeight.bold),
                                      ),
                                    ),

                                    Padding(
                                      padding: const EdgeInsets.only(left: 8.0),
                                      child: Text(
                                        'Order from your favorite restaurant',
                                        style: TextStyle(
                                          wordSpacing: 2,
                                            fontFamily: 'Poppins',
                                            color: Colors.blueGrey,
                                            fontSize: 13.sp,

                                        ),
                                      ),
                                    ),
                                    Image(image: AssetImage('assets/images/burger.png'), height: 100.h, width: 200.w,),

                                  ],
                                ),
                              ),
                            ),
                          ),

                          ///SUPERMARKET AND SHOPS
                          Expanded(
                            flex: 2,
                            child: Padding(
                              padding: const EdgeInsets.only(left: 4),
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                children: [
                                  ///SUPERMARKET
                                  ///
                                  ///
                                  GestureDetector(
                                    onTap: (){
                                      Navigator.push(context, MaterialPageRoute(builder: (context)=> InitPageSearch(searchCollection: 'Grocery 🛒', Title: 'Supermarket',)));

                                    },
                                    child: Container(
                                      decoration: BoxDecoration(
                                        color: Colors.white,
                                        borderRadius: BorderRadius.circular(10),
                                      ),
                                      child: Column(
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: [
                                          Padding(
                                            padding: const EdgeInsets.only(left: 8.0,top: 8),
                                            child: Text(
                                              'Supermarket',
                                              style: TextStyle(
                                                  fontFamily: 'Righteous',
                                                  color: Colors.black,
                                                  fontSize: 18.sp,
                                                  fontWeight: FontWeight.bold),
                                            ),
                                          ),


                                                                Padding(
                                                                  padding: const EdgeInsets.only(left: 8.0,),
                                                                  child: Text(
                                                                    'Groceries and more...',
                                                                    style: TextStyle(
                                     // fontFamily: 'Popins',
                                      color: Colors.blueGrey,
                                      fontSize: 15.sp,
                                      //fontWeight: FontWeight.bold
                                                                    ),
                                                                  ),),
                                          Padding(
                                            padding: const EdgeInsets.only(left: 16),
                                            child: Image(image: AssetImage('assets/images/grocery.png'), height: 100.h, width: 150.w,),
                                          ),



                                        ],
                                      ),
                                    ),
                                  ),

                                  ///SHOPS
                                  ///
                                  ///
                                  GestureDetector(
                                    onTap: (){
                                      Navigator.push(context, MaterialPageRoute(builder: (context)=> InitPageSearch(searchCollection: 'Clothing 👗', Title: ' Other Shops',)));

                                    },
                                    child: Container(
                                      decoration: BoxDecoration(
                                        color: Colors.white,
                                        borderRadius: BorderRadius.circular(10),
                                      ),
                                      child: Row(
                                        mainAxisAlignment: MainAxisAlignment.start,
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: [
                                          Expanded(child: Column(
                                            crossAxisAlignment: CrossAxisAlignment.start,
                                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                              children: [
                                               Padding(
                                                 padding: const EdgeInsets.only(left: 8,top: 8),
                                                 child: Text('Shops', style: TextStyle(
                                                     fontFamily: 'Righteous',
                                                     color: Colors.black,
                                                     fontSize: 17.sp,
                                                     fontWeight: FontWeight.bold),),
                                               ),
                                                Padding(
                                                  padding: const EdgeInsets.only(left: 8.0),
                                                  child: Text('This and more available in shops around you...',
                                                    style: TextStyle(
                                                        color: Colors.blueGrey,
                                                        fontSize: 9.sp,
                                                        fontFamily: 'Poppins',
                                                        //fontWeight: FontWeight.bold
                                                    ),),
                                                ),

                                              ],
                                          )),
                                          Expanded(child: Image(image: AssetImage('assets/images/shops.jpg'), height: 80.h, width: 150.w,)),
                                        ],
                                      ),
                                    ),
                                  )
                                ],
                              ),
                            ),
                          ),

                        ],
                      ),
                    ),
                  ),
SizedBox(height: 30.h,),

                  Padding(padding: EdgeInsets.all(1),
                      child: PromotionAdsCard(
                        image: 'assets/images/MealmateDress.png',
                        heading:'Get Rewarded With MealMate Shirt',
                        content: 'Order your favorite food and get Lucky..',
                        contentColor: Colors.white70,
                        headingColor: Colors.white,
                        backgroundColor: Colors.black,

                      )),


                  SizedBox(
                    height: 30.h,
                  ),
                  ///COURRESSEL  FOR ADS
             /*     Badge(
                      backgroundColor: Colors.green,
                      textColor: Colors.white,
                      label: Text(
                        'Ads 📢',
                      ),
                      child: adsCouressel()),*/
                  ///
                  ///
                  ///

                  SizedBox(
                    height: 30.h,
                  ),
                  ///CARD SHOWING THE INTRODUCTION OF THE APP AND COUROSEL OF IMAGES
                  //initCard(),

                  SizedBox(
                    height: 30.h,
                  ),

                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Padding(
                        padding: const EdgeInsets.all(4.0),
                        child: Text(
                          ' 🏪 Stores Near You ',
                          style: TextStyle(
                            fontFamily: 'Righteous',
                              color: Colors.blueGrey,
                              fontSize: 12.sp,
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
                          child: Row(
                            children: [

                              Text(
                                'View All',
                                style: TextStyle(
                                    fontSize: 15.sp, color: Colors.deepOrangeAccent),
                              ),
                              Icon(
                                Icons.arrow_forward_ios,
                                size: 15.spMin,
                                color: Colors.deepOrangeAccent,
                              )
                            ],
                          ),
                        ),
                      )
                    ],
                  ),
                  SizedBox(
                    height: 10.h,
                  ),

                  _hasInternet? SizedBox(
  width: double.infinity,
  height: 200.h,
  child: FutureBuilder<List<FoodItem>>(
  future: fetchFoodItems('Food 🍔'),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return ListView.builder(
                    itemCount: 5,
                    itemBuilder: (context, index) {
                      return Padding(
                        padding: const EdgeInsets.all(4.0),
                        child: NewSearchLoadingOutLook(),
                      );
                    },
                    scrollDirection: Axis.horizontal,
                  );
                } else if (snapshot.hasError) {
                  return Center(child: Text('Error: ${snapshot.error}'));
                } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                  return ListView.builder(
                    itemCount: 5,
                    itemBuilder: (context, index) {
                      return Padding(
                        padding: const EdgeInsets.all(4.0),
                        child: EmptyCollection(),
                      );
                    },
                    scrollDirection: Axis.horizontal,
                  );
                } else {
                  return FutureBuilder<LatLng>(
                    future: Provider.of<LocationProvider>(context, listen: false).getPoints(),
                    builder: (context, locationSnapshot) {
                      if (locationSnapshot.connectionState == ConnectionState.waiting) {
                        return ListView.builder(
                          itemCount: 5,
                          itemBuilder: (context, index) {
                            return Padding(
                              padding: const EdgeInsets.all(4.0),
                              child: NewSearchLoadingOutLook(),
                            );
                          },
                          scrollDirection: Axis.horizontal,
                        );
                      } else if (locationSnapshot.hasError) {
                        return Center(child: Text('Error: ${locationSnapshot.error}'));
                      } else if (!locationSnapshot.hasData) {
                        return Center(child: Text('Unable to determine location'));
                      } else {
                        LatLng userLocation = locationSnapshot.data!;
                        List<FoodItem> nearbyRestaurants = snapshot.data!.where((foodItem) {
                          double distance = Provider.of<LocationProvider>(context, listen: false)
                              .calculateDistance(userLocation, LatLng(foodItem.latitude, foodItem.longitude));
                          return distance <= 10; // Check if the restaurant is within 10 km
                        }).toList();

                        return ListView.builder(
                          itemCount: nearbyRestaurants.length,
                          itemBuilder: (context, index) {
                            final foodItem = nearbyRestaurants[index];
                            return Padding(
                              padding: const EdgeInsets.all(4.0),
                              child: GestureDetector(
                                onTap: () {
                                  foodItem.isAvailable
                                      ? Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) => DetailedCard(
                                        imgUrl: foodItem.imageUrl,
                                        restaurant: foodItem.restaurant,
                                        foodName: foodItem.foodName,
                                        price: foodItem.price,
                                        location: foodItem.location,
                                        vendorid: foodItem.vendorId,
                                        time: foodItem.time,
                                        latitude: foodItem.latitude,
                                        longitude: foodItem.longitude,
                                        adminEmail: foodItem.adminEmail,
                                        adminContact: foodItem.adminContact,
                                        maxDistance: foodItem.maxDistance,
                                      ),
                                    ),
                                  )
                                      : Notify(context, 'This item is not available now', Colors.red);
                                },
                                child: NewVerticalCard(
                                  foodItem.imageUrl,
                                  foodItem.restaurant,
                                  foodItem.foodName,
                                  foodItem.price,
                                  foodItem.location,
                                  foodItem.time,
                                  foodItem.vendorId.toString(),
                                  foodItem.isAvailable,
                                  foodItem.adminEmail,
                                  foodItem.adminContact,
                                  foodItem.maxDistance,
                                ),
                              ),
                            );
                          },
                          scrollDirection: Axis.horizontal,
                        );
                      }
                    },
                  );
                }
              },
            ),
): NoInternetConnection(),
                  ///CONTAINER OF HRORINZAOL LIST OF FOODS
                  ///
                  ///
                  ///
                  ///

                  _hasInternet? SizedBox(
                    width: double.infinity,
                    height: 200.h,
                    child: FutureBuilder<List<FoodItem>>(
                      future: fetchFoodItems('Food 🍔'),
                      builder: (context, snapshot) {
                        if (snapshot.connectionState == ConnectionState.waiting) {
                          return ListView.builder(
                            itemCount: 5,
                            itemBuilder: (context, index) {
                              return Padding(
                                padding: const EdgeInsets.all(4.0),
                                child: NewSearchLoadingOutLook(),
                              );
                            },
                            scrollDirection: Axis.horizontal,
                          );
                        } else if (snapshot.hasError) {
                          return Center(child: Text('Error: ${snapshot.error}'));
                        } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                          return ListView.builder(
                            itemCount: 5,
                            itemBuilder: (context, index) {
                              return Padding(
                                padding: const EdgeInsets.all(4.0),
                                child: EmptyCollection(),
                              );
                            },
                            scrollDirection: Axis.horizontal,
                          );
                        } else {
                          return FutureBuilder<LatLng>(
                            future: Provider.of<LocationProvider>(context, listen: false).getPoints(),
                            builder: (context, locationSnapshot) {
                              if (locationSnapshot.connectionState == ConnectionState.waiting) {
                                return ListView.builder(
                                  itemCount: 5,
                                  itemBuilder: (context, index) {
                                    return Padding(
                                      padding: const EdgeInsets.all(4.0),
                                      child: NewSearchLoadingOutLook(),
                                    );
                                  },
                                  scrollDirection: Axis.horizontal,
                                );
                              } else if (locationSnapshot.hasError) {
                                return Center(child: Text('Error: ${locationSnapshot.error}'));
                              } else if (!locationSnapshot.hasData) {
                                return Center(child: Text('Unable to determine location'));
                              } else {
                                LatLng userLocation = locationSnapshot.data!;
                                List<FoodItem> nearbyRestaurants = snapshot.data!.where((foodItem) {
                                  double distance = Provider.of<LocationProvider>(context, listen: false)
                                      .calculateDistance(userLocation, LatLng(foodItem.latitude, foodItem.longitude));
                                  return distance <= 1000; // Check if the restaurant is within 10 km
                                }).toList();

                                return ListView.builder(
                                  itemCount: nearbyRestaurants.length,
                                  itemBuilder: (context, index) {
                                    final foodItem = nearbyRestaurants[index];
                                    return Padding(
                                      padding: const EdgeInsets.all(4.0),
                                      child: GestureDetector(
                                        onTap: () {
                                          foodItem.isAvailable
                                              ? Navigator.push(
                                            context,
                                            MaterialPageRoute(
                                              builder: (context) => DetailedCard(
                                                imgUrl: foodItem.imageUrl,
                                                restaurant: foodItem.restaurant,
                                                foodName: foodItem.foodName,
                                                price: foodItem.price,
                                                location: foodItem.location,
                                                vendorid: foodItem.vendorId,
                                                time: foodItem.time,
                                                latitude: foodItem.latitude,
                                                longitude: foodItem.longitude,
                                                adminEmail: foodItem.adminEmail,
                                                adminContact: foodItem.adminContact,
                                                maxDistance: foodItem.maxDistance,
                                              ),
                                            ),
                                          )
                                              : Notify(context, 'This item is not available now', Colors.red);
                                        },
                                        child: NewVerticalCard(
                                          foodItem.imageUrl,
                                          foodItem.restaurant,
                                          foodItem.foodName,
                                          foodItem.price,
                                          foodItem.location,
                                          foodItem.time,
                                          foodItem.vendorId.toString(),
                                          foodItem.isAvailable,
                                          foodItem.adminEmail,
                                          foodItem.adminContact,
                                          foodItem.maxDistance,
                                        ),
                                      ),
                                    );
                                  },
                                  scrollDirection: Axis.horizontal,
                                );
                              }
                            },
                          );
                        }
                      },
                    ),
                  ): NoInternetConnection(),
                  SizedBox(
                    height: 30.h,
                  ),



                  ///PROMOTIONAL ADS
                  Padding(padding: EdgeInsets.all(1),
                      child: PromotionAdsCard(
                        image: 'assets/adsimages/ads1.png',
                        heading:'Grab Your Favorite Burger',
                        content: 'Fast & fresh on MealMate foods: click to order',
                        contentColor: Colors.white70,
                        headingColor: Colors.white,
                        backgroundColor: Colors.pinkAccent.shade200,

                      )),
                  SizedBox(
                    height: 30.h,
                  ),

                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Text(
                          '   Drinks 🍹🍷 ',
                          style: TextStyle(
                            fontFamily: 'Righteous',
                              color: Colors.blueGrey,
                              fontSize: 12.sp,
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
                          child: Row(
                            children: [
                              Text(
                                'View All',
                                style: TextStyle(
                                    fontSize: 12.sp, color: Colors.deepOrangeAccent,fontWeight: FontWeight.bold),
                              ),
                              Icon(
                                Icons.arrow_forward_ios,
                                size: 12.spMin,
                                color: Colors.deepOrangeAccent,
                              )
                            ],
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
                 _hasInternet? Container(
                    color: Colors.white,
                    width: double.infinity,
                    height: 200.h,
                    child: FutureBuilder<List<FoodItem>>(
                      future: fetchFoodItems('Drinks 🍷'),
                      builder: (context, snapshot) {
                        if (snapshot.connectionState ==
                            ConnectionState.waiting) {
                          return ListView.builder(
                            itemCount: 5,
                            itemBuilder: (context, index) {
                              return Padding(
                                  padding: const EdgeInsets.all(4.0),
                                  child: NewSearchLoadingOutLook());
                            },
                            scrollDirection: Axis.horizontal,
                          );
                        } else if (snapshot.hasError) {
                          return Center(
                              child: Text('Error: ${snapshot.error}'));
                        } else if (!snapshot.hasData ||
                            snapshot.data!.isEmpty) {
                          return ListView.builder(
                            itemCount: 5,
                            itemBuilder: (context, index) {
                              return Padding(
                                  padding: const EdgeInsets.all(4.0),
                                  child: EmptyCollection());
                            },
                            scrollDirection: Axis.horizontal,
                          );
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
                                                        time: foodItem.time,
                                                    latitude: foodItem.latitude,
                                                      longitude: foodItem.longitude,
                                                      adminEmail: foodItem.adminEmail,
                                                      adminContact: foodItem.adminContact,
                                                      maxDistance: foodItem.maxDistance
                                                    ))):Notify(context, 'This item is not Available now', Colors.red);
                                      },
                                      child: verticalCard(
                                        foodItem.imageUrl,
                                        foodItem.restaurant,
                                        foodItem.foodName,
                                        foodItem.price,
                                        foodItem.location,
                                        foodItem.time,
                                        foodItem.vendorId.toString(),
                                        foodItem.isAvailable,
                                        foodItem.adminEmail,
                                          foodItem.adminContact
                                      ),
                                    ),
                                  ));
                            },
                            scrollDirection: Axis.horizontal,
                          );
                        }
                      },
                    ),
                  ) : Center(child: NoInternetConnection(),),
SizedBox(height: 30.h,),
                  Padding(padding: EdgeInsets.all(1),
                      child: PromotionAdsCard(
                        image: 'assets/images/jollof.png',
                        heading:'Satisfy Your cravings With MealMate',
                        content: 'Order your favorite food from your favorite restaurant',
                        contentColor: Colors.white,
                        headingColor: Colors.white,
                        backgroundColor: Colors.redAccent.shade200,

                      )),



SizedBox(height: 30.h,),

                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Text(
                          '   Grocery 🛒 ',
                          style: TextStyle(
                              fontFamily: 'Righteous',
                              color: Colors.blueGrey,
                              fontSize: 12.sp,
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
                          child: Row(
                            children: [
                              Text(
                                'View All',
                                style: TextStyle(
                                    fontSize: 12.sp, color: Colors.deepOrangeAccent,fontWeight: FontWeight.bold),
                              ),
                              Icon(
                                Icons.arrow_forward_ios,
                                size: 12.spMin,
                                color: Colors.deepOrangeAccent,
                              )
                            ],
                          ),
                        ),
                      )
                    ],
                  ),
                  ////CONTAINER OF HRORINZAOL LIST OF GROCERY

                  _hasInternet? Container(
                    color: Colors.white,
                    width: double.infinity,
                    height: 200.h,
                    child: FutureBuilder<List<FoodItem>>(
                      future: fetchFoodItems('Grocery 🛒'),
                      builder: (context, snapshot) {
                        if (snapshot.connectionState ==
                            ConnectionState.waiting) {
                          return ListView.builder(
                            itemCount: 5,
                            itemBuilder: (context, index) {
                              return Padding(
                                  padding: const EdgeInsets.all(4.0),
                                  child: NewSearchLoadingOutLook());
                            },
                            scrollDirection: Axis.horizontal,
                          );
                        } else if (snapshot.hasError) {
                          return Center(
                              child: Text('Error: ${snapshot.error}'));
                        } else if (!snapshot.hasData ||
                            snapshot.data!.isEmpty) {
                          return ListView.builder(
                            itemCount: 5,
                            itemBuilder: (context, index) {
                              return Padding(
                                  padding: const EdgeInsets.all(4.0),
                                  child: EmptyCollection());
                            },
                            scrollDirection: Axis.horizontal,
                          );
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
                                                        time: foodItem.time,
                                                        latitude: foodItem.latitude,
                                                        longitude: foodItem.longitude,
                                                        adminEmail: foodItem.adminEmail,
                                                        adminContact: foodItem.adminContact,
                                                        maxDistance: foodItem.maxDistance
                                                    ))):Notify(context, 'This item is not Available now', Colors.red);
                                      },
                                      child: verticalCard(
                                          foodItem.imageUrl,
                                          foodItem.restaurant,
                                          foodItem.foodName,
                                          foodItem.price,
                                          foodItem.location,
                                          foodItem.time,
                                          foodItem.vendorId.toString(),
                                          foodItem.isAvailable,
                                          foodItem.adminEmail,
                                          foodItem.adminContact
                                      ),
                                    ),
                                  ));
                            },
                            scrollDirection: Axis.horizontal,
                          );
                        }
                      },
                    ),
                  ) : Center(child: NoInternetConnection(),),

                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

