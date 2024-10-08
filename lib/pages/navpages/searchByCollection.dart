import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:internet_connection_checker_plus/internet_connection_checker_plus.dart';
//import 'package:internet_connection_checker/internet_connection_checker.dart';
import 'package:mealmate/AdminPanel/components/adminHorizontalCard.dart';
import 'package:mealmate/components/CustomLoading.dart';
import 'package:mealmate/components/NoFoodFound.dart';
import 'package:mealmate/components/NoInternet.dart';
import 'package:mealmate/components/Notify.dart';
import 'package:mealmate/components/mainCards/verticalCard.dart';
import 'package:mealmate/pages/detail&checkout/detail.dart';
import 'package:mealmate/pages/navpages/order.dart';
import 'package:mealmate/pages/searchfooditem/searchFoodItem.dart';
import 'package:provider/provider.dart';

import '../../components/userCollectionshow.dart';
import '../../models&ReadCollectionModel/ListFoodItemModel.dart';
import '../../models&ReadCollectionModel/userReadwithCollection.dart';

class Search extends StatefulWidget {
  const Search({super.key});

  @override
  State<Search> createState() => _SearchState();
}

class _SearchState extends State<Search> {

  /// THIS FUNCTION FETCHES THE FOOD ITEMS FROM THE COLLECTION SELECTED BY THE USER
  ///
  /// THE FUNCTION TAKES IN A COLLECTION AS A PARAMETER
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


  ///CHECK FOR INTERNET UPON INIT
bool _hasInternet = true;
  checkInternet() async {
    final listener = InternetConnection().onStatusChange.listen((InternetStatus status) {
      if (status == InternetStatus.connected) {
       // print('Connected');
      } else {
        setState(() {
        //  print('Not connected');
          _hasInternet = false;
          NoInternetNotify(context, 'Check Internet Connection ', Colors.red);

        });
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
        automaticallyImplyLeading: false,
        centerTitle: true,
        title: Text('Search '),
        titleTextStyle: TextStyle(
            color: Colors.blueGrey,
            fontWeight: FontWeight.normal,
            letterSpacing: 3,
            fontSize: 20.spMin),
        backgroundColor: Colors.white,
        actions: [
          SizedBox(
            width: 20.w,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              IconButton(
                onPressed: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => SearchFoodItem()));
                },

                ///ICON THAT TAKES YOU TO ORDER DETAILS PAGE
                ///TO VIEW LIST OF ODERS AND REPORT ISSUES
                icon: ImageIcon(
                  AssetImage('assets/Icon/Search.png'),
                  color: Colors.black,
                  size: 20.sp,
                ),
              ),
              SizedBox(
                width: 20.w,
              ),
              IconButton(
                  onPressed: () {
                    Navigator.push(context,
                        MaterialPageRoute(builder: (context) => OrderList()));
                  },
                  icon: ImageIcon(
                    AssetImage('assets/Icon/Order.png'),
                    color: Colors.black,
                    size: 20.w,
                  ))
            ],
          ),
        ],
      ),
      body: Column(
        children: [
          // SizedBox(height: 10),
          Padding(
            /// THIS IS WHERE THE FOOD COLLECTION ITMES ARE DISPLAYED ,
            ///
            /// THUS { FOODS, DRINKS , ELECTRONICS, CLOTHING, GROCERY }
            padding: const EdgeInsets.all(10.0),
            child: Container(
              height: 100.h,
              width: double.infinity,
              decoration: BoxDecoration(
                //border: Border.all(color: Colors.deepOrangeAccent),
                color: Colors.transparent,
                borderRadius: BorderRadius.circular(10),
              ),
              child: Consumer<userCollectionProvider>(
                  builder: (context, value, child) {
                return ListView.builder(
                  itemBuilder: (context, index) {
                    return GestureDetector(
                      onTap: () {
                        /// SINCE THIS IS WHERE A ROW(LIST < FOOD, DRINKS, CLOTHING, ELECTRONICS >  OF COLLECTION IS DISPLAYED FOR USER TO SEARCH FOOD ITEMS
                        /// I USED THE PROVIDER TO CHANGE THE INDEX OF THE COLLECTION TO READ
                        ///
                        ///
                        value.changeIndex(index);
                        setState(() {});
                      },
                      child: userCollectionItemsRow(value.collectionList[index],
                          value.collectionImageList[index]),
                    );
                  },
                  scrollDirection: Axis.horizontal,
                  itemCount: value.collectionList.length,
                );
              }),
            ),
          ),
         _hasInternet ?Expanded(
              child: FutureBuilder<List<FoodItem>>(
                  future: fetchFoodItems(Provider.of<userCollectionProvider>(
                          context,
                          listen: false)
                      .collectionToRead),
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return Center(child: SearchLoadingOutLook());
                    } else if (snapshot.hasError) {
                      return Center(child: Text('Error: ${snapshot.error}'));
                    } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                      return Center(child: noFoodFound());
                    } else {
                      return MasonryGridView.count(
                          itemCount: snapshot.data!.length,
                          crossAxisCount: 2,
                          mainAxisSpacing: 2,
                          crossAxisSpacing: 3,
                          itemBuilder: (context, index) {
                            final data = snapshot.data![index];
                            return GestureDetector(
                              onTap: () {

                                data.isAvailable?Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) => DetailedCard(
                                            imgUrl: data.imageUrl,
                                            restaurant: data.restaurant,
                                            foodName: data.foodName,
                                            price: data.price,
                                            location: data.location,
                                            vendorid: data.vendorId,
                                            time: data.time,
                                        latitude: data.latitude,
                                          longitude: data.longitude,
                                          adminEmail: data.adminEmail,
                                          adminContact: data.adminContact,
                                        ))): Notify(context, 'This item Is not Available Now', Colors.red);
                              },
                              child: verticalCard(
                                  data.imageUrl,
                                  data.restaurant,
                                  data.foodName,
                                  data.price,
                                  data.location,
                                  data.time,
                                  data.vendorId.toString(),
                                  data.isAvailable,
                              data.adminEmail,
                                data.adminContact,
                              ),
                            );
                          });
                    }
                  })) : Center(child: NoInternetConnection(),)
        ],
      ),
    );
  }
}
