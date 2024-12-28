import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:internet_connection_checker_plus/internet_connection_checker_plus.dart';
import 'package:mealmate/Notification/notification_Provider.dart';
import 'package:mealmate/components/NoInternet.dart';
import 'package:mealmate/components/mainCards/promotion_ads_card.dart';
import 'package:mealmate/pages/detail&checkout/detail.dart';
import 'package:mealmate/pages/navpages/profile.dart';
import 'package:mealmate/pages/navpages/searchByCollection.dart';
import 'package:mealmate/pages/searchfooditem/init_row_search.dart';
import 'package:mealmate/pages/searchfooditem/searchFoodItem.dart';
import 'package:provider/provider.dart';
import '../../UserLocation/LocationProvider.dart';
import '../../components/Notify.dart';
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

  /// THIS IS STREAM METHOD FETCHES NEARBY RESTAURANTS
  ///
  Stream<List<FoodItem>> getNearbyProducts(String collection) async* {
   try{
     QuerySnapshot snapshot = await FirebaseFirestore.instance.collection(collection).get(GetOptions(source: Source.cache));
     if(snapshot.docs.isEmpty){
       print('No data in cache');
       snapshot = await FirebaseFirestore.instance.collection(collection).get(
         GetOptions(source: Source.server),
       );
       print(snapshot.docs.length);

     }
     LatLng userLocation = await Provider.of<LocationProvider>(context, listen: false).getPoints();

     List<FoodItem> nearbyRestaurants = [];
     for (var doc in snapshot.docs) {
       FoodItem foodItem = FoodItem.fromMap(doc.data() as Map<String, dynamic>, doc.id);
       double distance = Provider.of<LocationProvider>(context, listen: false)
           .calculateDistance(userLocation, LatLng(foodItem.latitude, foodItem.longitude));
       if (distance <= Provider.of<LocationProvider>(context,listen: false).distanceRangeToSearch) {
         nearbyRestaurants.add(foodItem);
         yield nearbyRestaurants; // Emit the current list of nearby restaurants
       }
     }

   }catch(e){
     print(e);
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
            TextSpan(text: "Mate", style: TextStyle(color: Colors.redAccent, fontSize: 20.spMin, fontWeight: FontWeight.bold,fontFamily: 'Righteous',)),


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
                          Icon(Icons.location_on_outlined, size: 20.spMin,color: Colors.blueGrey,),
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
                                            fontSize: 12.spMin)),
                                  );
                                }
                                return Text(
                                  'wait while we locate you...',
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
                     width: 350.w,
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
                              Navigator.push(context, MaterialPageRoute(builder: (context)=> InitRowSearch(searchItem: 'grocery')));
                            },
                                child: InitRow(imageUrl: 'assets/adsimages/Grocery.png',name: 'Grocery',)),
                            InkWell(
                              onTap: (){
                                Navigator.push(context, MaterialPageRoute(builder: (context)=> InitRowSearch(searchItem: 'snacks')));
                              }
                            ,child: InitRow(imageUrl: 'assets/images/burger.png',name: 'Snacks',)),

                            InkWell(onTap: (){
                              Navigator.push(context, MaterialPageRoute(builder: (context)=> InitRowSearch(searchItem: 'pizza')));
                            }
                            ,child: InitRow(imageUrl: 'assets/adsimages/pizza.png',name: 'Pizza',)),

                            InkWell(
                            onTap: (){
                              Navigator.push(context, MaterialPageRoute(builder: (context)=> InitRowSearch(searchItem: 'drinks')));
                            },
                            child: InitRow(imageUrl: 'assets/adsimages/drinks.png',name: 'Drinks',)),

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
                                Navigator.push(context, MaterialPageRoute(builder: (context)=> InitPageSearch(searchCollection: 'Food ', Title: 'Food Delivery',)));

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
                                            fontSize: 35.spMin,
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
                                            fontSize: 13.spMin,

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
                                      Navigator.push(context, MaterialPageRoute(builder: (context)=> InitPageSearch(searchCollection: 'Grocery ', Title: 'Supermarket',)));

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
                                                  fontSize: 18.spMin,
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
                                      fontSize: 15.spMin,
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
                                      Navigator.push(context, MaterialPageRoute(builder: (context)=> InitPageSearch(searchCollection: 'Others', Title: ' Other Shops',)));

                                    },
                                    child: Container(
                                      decoration: BoxDecoration(
                                        color: Colors.white,
                                        borderRadius: BorderRadius.circular(10),
                                      ),
                                      child: Row(
                                        mainAxisAlignment: MainAxisAlignment.center,
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: [
                                          Expanded(child: SingleChildScrollView(
                                            scrollDirection: Axis.vertical,
                                            child: Column(
                                              crossAxisAlignment: CrossAxisAlignment.start,
                                                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                                children: [
                                                 Padding(
                                                   padding: const EdgeInsets.only(left: 8,),
                                                   child: Text('Shops', style: TextStyle(
                                                       fontFamily: 'Righteous',
                                                       color: Colors.black,
                                                       fontSize: 15.spMin,
                                                       fontWeight: FontWeight.bold),),
                                                 ),
                                                  Padding(
                                                    padding: const EdgeInsets.only(left: 8.0),
                                                    child: Text('Visit shops around you...',
                                                      style: TextStyle(
                                                          color: Colors.blueGrey,
                                                          fontSize: 10.spMin,
                                                          fontFamily: 'Poppins',
                                                          //fontWeight: FontWeight.bold
                                                      ),),
                                                  ),

                                                ],
                                            ),
                                          )),
                                          Expanded(child: Image(image: AssetImage('assets/images/shops.jpg'), height: 60.h, width: 130.w,)),
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


                  SizedBox(
                    width: double.infinity,
                    height: 110.h,
                    child: ListView(
                      scrollDirection: Axis.horizontal,
                      children: const [
                        Padding(padding: EdgeInsets.all(1),
                            child: PromotionAdsCard(
                              image: 'assets/images/MealmateDress.png',
                              heading:'Get Rewarded With MealMate Shirt',
                              content: 'Order your favorite food and get Lucky..',
                              contentColor: Colors.white70,
                              headingColor: Colors.white,
                              backgroundColor: Colors.black,

                            )),
                        Padding(
                          padding: EdgeInsets.only(right: 5),
                          child: PromotionAdsCard(
                            image: 'assets/adsimages/fufu.png',
                            heading: 'Eat what you desire',
                            content: 'Order your favorite food and get Lucky.. yh get lucky 🍀☺️',
                            contentColor: Colors.white70,
                            headingColor: Colors.white,
                            backgroundColor: Colors.black,
                          ),
                        ),
                        Padding(
                          padding: EdgeInsets.only(right: 5),
                          child: PromotionAdsCard(
                            image: 'assets/adsimages/local.png',
                            heading: 'Order Pizza and get a free drink',
                            content: 'Embrace the Ecosystem... Let love lead',
                            contentColor: Colors.white70,
                            headingColor: Colors.white,
                            backgroundColor: Colors.black,
                          ),
                        ),
                      ],
                    ),
                  ),


                  SizedBox(
                    height: 30.h,
                  ),


                  ///CONTAINER OF HRORINZAOL LIST OF FOODS
                  ///
                  ///
              _hasInternet
                  ? SizedBox(
                width: double.infinity,
                height: 200.h,
                child: StreamBuilder<List<FoodItem>>(
                  stream: getNearbyProducts('Food'),
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
                      return Center(child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Image(image: AssetImage('assets/Icon/route.png'),height: 50.h,width: 70.w,),
                          Text('Enable Location in your Settings',style: TextStyle(color: Colors.black, fontFamily: 'Poppins'),)
                        ],
                      ));
                    } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                      print('No data');
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
                      return ListView.builder(
                        itemCount: snapshot.data!.length,
                        itemBuilder: (context, index) {
                          final foodItem = snapshot.data![index];
                          return Padding(
                            padding: const EdgeInsets.all(4.0),
                            child: GestureDetector(
                              onTap: () {
                                foodItem.isAvailable
                                    ? Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => DetailedCard(
                                      paymentKey: foodItem.paymentKey,
                                      hasCourier: foodItem.hasCourier,
                                      productImageUrl: foodItem.ProductImageUrl,
                                      shopImageUrl: foodItem.shopImageUrl,
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
                                      vendorAccount: foodItem.vendorAccount,
                                    ),
                                  ),
                                )
                                    : Notify(context, 'This item is not available now', Colors.red);
                              },
                              child: NewVerticalCard(
                                foodItem.ProductImageUrl,
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
                ),
              )
                  : NoInternetConnection(),

                  SizedBox(
                    height: 20.h,
                  ),


                  ////PROMOTION ADS

                  SizedBox(
                    width: double.infinity,
                    height: 110.h,
                    child: ListView(
                      scrollDirection: Axis.horizontal,
                      children: const [
                        Padding(
                          padding: EdgeInsets.only(right: 5),
                          child: PromotionAdsCard(
                            image: 'assets/adsimages/fufu.png',
                            heading: 'Eat what you desire',
                            content: 'Order your favorite food and get Lucky.. yh get lucky 🍀☺️',
                            contentColor: Colors.white70,
                            headingColor: Colors.white,
                            backgroundColor: Colors.black,
                          ),
                        ),

                        Padding(
                          padding: EdgeInsets.only(right: 5),
                          child: PromotionAdsCard(
                            image: 'assets/adsimages/local.png',
                            heading: 'Order Pizza and get a free drink',
                            content: 'Embrace the Ecosystem... Let love lead',
                            contentColor: Colors.white70,
                            headingColor: Colors.white,
                            backgroundColor: Colors.black,
                          ),
                        ),
                      ],
                    ),
                  ),

                  SizedBox(
                    height: 20.h,
                  ),

                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Text(
                          '  Grocery  ',
                          style: TextStyle(
                            fontFamily: 'Righteous',
                              color: Colors.blueGrey,
                              fontSize: 12.spMin,
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
                                    fontSize: 12.spMin, color: Colors.deepOrangeAccent,fontWeight: FontWeight.bold),
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
                  _hasInternet
                      ? SizedBox(
                    width: double.infinity,
                    height: 200.h,
                    child: StreamBuilder<List<FoodItem>>(
                      stream: getNearbyProducts('Grocery'),
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
                          return Center(child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Image(image: AssetImage('assets/Icon/route.png'),height: 50.h,width: 70.w,),
                              Text('Enable Location in your Settings',style: TextStyle(color: Colors.black, fontFamily: 'Poppins'),)
                            ],
                          ));
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
                          return ListView.builder(
                            itemCount: snapshot.data!.length,
                            itemBuilder: (context, index) {
                              final foodItem = snapshot.data![index];
                              return Padding(
                                padding: const EdgeInsets.all(4.0),
                                child: GestureDetector(
                                  onTap: () {
                                    foodItem.isAvailable
                                        ? Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (context) => DetailedCard(
                                          paymentKey: foodItem.paymentKey,
                                          hasCourier: foodItem.hasCourier,
                                          productImageUrl: foodItem.ProductImageUrl,
                                          shopImageUrl: foodItem.shopImageUrl,
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
                                          vendorAccount: foodItem.vendorAccount,
                                        ),
                                      ),
                                    )
                                        : Notify(context, 'This item is not available now', Colors.red);
                                  },
                                  child: NewVerticalCard(
                                    foodItem.ProductImageUrl,
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
                    ),
                  )
                      : NoInternetConnection(),
SizedBox(height: 30.h,),

                  SizedBox(
                    width: double.infinity,
                    height: 110.h,
                    child: ListView(
                      scrollDirection: Axis.horizontal,
                      children: const [
                        Padding(
                          padding: EdgeInsets.all(4.0),
                          child: PromotionAdsCard(
                            image: 'assets/images/jollof.png',
                            heading:'Satisfy Your cravings With MealMate',
                            content: 'Favorite food from your favorite restaurant',
                            contentColor: Colors.white,
                            headingColor: Colors.white,
                            backgroundColor: Colors.redAccent,

                          ),
                        ),
                        Padding(
                          padding: EdgeInsets.all(4.0),
                          child: PromotionAdsCard(
                            image: 'assets/adsimages/shawama.png',
                            heading: 'Eat what you desire',
                            content: 'How about a shawama... mmm☺️',
                            contentColor: Colors.white70,
                            headingColor: Colors.white,
                            backgroundColor: Colors.black,
                          ),
                        ),

                        Padding(
                          padding: EdgeInsets.all(4.0),
                          child: PromotionAdsCard(
                            image: 'assets/adsimages/drinks.png',
                            heading: 'Order Local meals & get a free drink',
                            content: 'Embrace the Ecosystem... Let love lead 🍀 ',
                            contentColor: Colors.white70,
                            headingColor: Colors.white,
                            backgroundColor: Colors.pinkAccent,
                          ),
                        ),
                      ],
                    ),
                  ),


SizedBox(height: 30.h,),

                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Text(
                          '   Others ',
                          style: TextStyle(
                              fontFamily: 'Righteous',
                              color: Colors.blueGrey,
                              fontSize: 12.spMin,
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
                                    fontSize: 12.spMin, color: Colors.deepOrangeAccent,fontWeight: FontWeight.bold),
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

                  _hasInternet
                      ? SizedBox(
                    width: double.infinity,
                    height: 200.h,
                    child: StreamBuilder<List<FoodItem>>(
                      stream: getNearbyProducts('Others'),
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
                          return Center(child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Image(image: AssetImage('assets/Icon/route.png'),height: 50.h,width: 70.w,),
                              Text('Enable Location in your Settings',style: TextStyle(color: Colors.black, fontFamily: 'Poppins'),)
                            ],
                          ));
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
                          return ListView.builder(
                            itemCount: snapshot.data!.length,
                            itemBuilder: (context, index) {
                              final foodItem = snapshot.data![index];
                              return Padding(
                                padding: const EdgeInsets.all(4.0),
                                child: GestureDetector(
                                  onTap: () {
                                    foodItem.isAvailable
                                        ? Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (context) => DetailedCard(
                                          paymentKey: foodItem.paymentKey,
                                          hasCourier: foodItem.hasCourier,
                                          productImageUrl: foodItem.ProductImageUrl,
                                          shopImageUrl: foodItem.shopImageUrl,
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
                                          vendorAccount: foodItem.vendorAccount,
                                        ),
                                      ),
                                    )
                                        : Notify(context, 'This item is not available now', Colors.red);
                                  },
                                  child: NewVerticalCard(
                                    foodItem.ProductImageUrl,
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
                    ),
                  )
                      : NoInternetConnection(),

                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

