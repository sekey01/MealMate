import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:internet_connection_checker/internet_connection_checker.dart';
import 'package:mealmate/AdminPanel/Pages/IncomingOrdersPage.dart';
import 'package:mealmate/AdminPanel/Pages/adminHome.dart';
import 'package:mealmate/AdminPanel/components/adminHorizontalCard.dart';
import 'package:mealmate/Local_Storage/Locall_Storage_Provider/StoreCredentials.dart';
import 'package:mealmate/components/NoInternet.dart';
import 'package:mealmate/components/Notify.dart';
import 'package:mealmate/pages/detail&checkout/detail.dart';
import 'package:mealmate/pages/navpages/cart.dart';
import 'package:mealmate/pages/navpages/profile.dart';
import 'package:mealmate/pages/navpages/searchByCollection.dart';
import 'package:mealmate/pages/searchfooditem/searchFoodItem.dart';
import 'package:provider/provider.dart';

import '../../UserLocation/LocationProvider.dart';
import '../../components/adsCouressel.dart';
import '../../components/card1.dart';
import '../../components/mainCards/horizontalCard.dart';
import '../../components/mainCards/verticalCard.dart';
import '../../models&ReadCollectionModel/ListFoodItemModel.dart';
import '../../models&ReadCollectionModel/cartmodel.dart';
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
  @override
  void initState() {
    super.initState();
    // Start listening to the internet connection status
    InternetConnectionChecker().onStatusChange.listen((status) {
      setState(() {
        _hasInternet = status == InternetConnectionStatus.connected;
      });
    });
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
              label: Consumer<LocalStorageProvider>(
                  builder: (context, value, child) => Text(
                    value.notificationLength.toString(),
                    style: TextStyle(
                        color: Colors.white, fontWeight: FontWeight.bold),
                  )),
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
            TextSpan(text: "Meal", style: TextStyle(color: Colors.black, fontSize: 20.spMin, fontWeight: FontWeight.bold)),
            TextSpan(text: "Mate", style: TextStyle(color: Colors.deepOrangeAccent, fontSize: 20.spMin, fontWeight: FontWeight.bold)),


          ]
        )),
        titleTextStyle: TextStyle(
            color: Colors.black,
            fontWeight: FontWeight.bold,
            letterSpacing: 1,
            fontSize: 20.spMin),

      ),
      body: Center(
        child: SafeArea(
          child: SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.all(6.0),
              child: Column(
                children: [
SizedBox(height: 30.spMin,),

                  ///LOCATION DISPLAYED HERE
                  ///
                  Padding(padding: EdgeInsets.all(3), child:     FutureBuilder(
                      future:
                      Provider.of<LocationProvider>(context, listen: false)
                          .determinePosition(),
                      builder: (context, snapshot) {
                        if (snapshot.hasData) {
                          return Row(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: [
                              Icon(Icons.location_on_outlined, size: 20,color: Colors.blueGrey,),
                              Text(snapshot.data.toString(),
                                  style: TextStyle(
                                      overflow: TextOverflow.ellipsis,
                                      color: Colors.black,
                                      fontWeight: FontWeight.bold,
                                      fontSize: 10.spMin)),
                            ],
                          );
                        }
                        return Text(
                          'locating you...',
                          style: TextStyle(color: Colors.blueGrey,fontWeight: FontWeight.normal),
                        );
                      }),),


                  SizedBox(height: 20.h,),
                  /// SEARCH BAR HERE
                  ///

                  Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: TextField(
                      onTap: (){
                        Navigator.push(context, MaterialPageRoute(builder: (context)=> SearchFoodItem()));
                      },
                      style: TextStyle(color: Colors.deepOrange),
                      decoration: InputDecoration(
                        hintText: 'FoodName or Restaurant',
                        fillColor: Colors.grey.shade300,
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
                            color: Colors.black,
                            style: BorderStyle.none,
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

                  SizedBox(height: 30.h,),
                  ///CARD SHOWING THE INTRODUCTION OF THE APP AND COUROSEL OF IMAGES
                  initCard(),

                  ///
                  ///
                  SizedBox(
                    height: 30.h,
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
                              fontSize: 20.spMin,
                              fontWeight: FontWeight.w800,
                              letterSpacing: 2,
                              color: Colors.black,
                            ),
                          ),
                          Text(
                            'More Delicious Foods 😋  ',
                            style: TextStyle(
                              fontSize: 15.spMin,
                              fontWeight: FontWeight.w700,
                              letterSpacing: 2,
                              color: Colors.blueGrey,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ]),
                  SizedBox(
                    height: 10.h,
                  ),
                  Padding(padding: EdgeInsets.all(1), child: Image(image: AssetImage('assets/Announcements/An_Jollof.png'),height: 200.h,),),
                  SizedBox(
                    height: 30.h,
                  ),
                  ///COURRESSEL  FOR ADS
                  Badge(
                      backgroundColor: Colors.green,
                      textColor: Colors.white,
                      label: Text(
                        'Ads 📢',
                      ),
                      child: adsCouressel()),
                  ///
                  ///
                  ///

                  SizedBox(
                    height: 30.h,
                  ),

                  Padding(padding: EdgeInsets.all(1),
                      child: Image(image: AssetImage('assets/Announcements/An_Grocery.png'))


                  ),
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
                              color: Colors.blueGrey,
                              fontSize: 10.spMin,
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
                                fontSize: 10.spMin, color: Colors.deepOrangeAccent),
                          ),
                        ),
                      )
                    ],
                  ),
                  SizedBox(
                    height: 30.h,
                  ),


                  ///CONTAINER OF HRORINZAOL LIST OF FOODS
                  ///
                  ///
                  ///
                  ///

                  _hasInternet?Container(
                    color: Colors.white,
                    width: double.infinity,
                    height: 200.h,
                    child: FutureBuilder<List<FoodItem>>(
                      future: fetchFoodItems('Food 🍔'),
                      builder: (context, snapshot) {
                        if (snapshot.connectionState ==
                            ConnectionState.waiting) {
                          return Center(child: Center(child:  CustomLoGoLoading()));
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
                                                      time: foodItem.time,
                                                  latitude: foodItem.latitude,
                                                    longitude: foodItem.longitude,
                                                  ))) :  Notify(context, 'This item is not Avable now', Colors.red) ;
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
                                  )) ;
                            },
                            scrollDirection: Axis.horizontal,
                          );
                        }
                      },
                    ),
                  ) : NoInternetConnection(),
                  SizedBox(
                    height: 30.h,
                  ),

                  Padding(padding: EdgeInsets.all(1),
                      child: Image(image: AssetImage('assets/Announcements/An_Feedback.png'))


                      ),
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
                              color: Colors.blueGrey,
                              fontSize: 10.spMin,
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
                                fontSize: 10.spMin, color: Colors.deepOrangeAccent),
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
                          return Center(child: Center(child:  CustomLoGoLoading()));
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
                                                        time: foodItem.time,
                                                    latitude: foodItem.latitude,
                                                      longitude: foodItem.longitude,
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
