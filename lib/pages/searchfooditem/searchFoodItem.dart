import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:mealmate/components/CustomLoading.dart';
import 'package:mealmate/components/NoFoodFound.dart';
import 'package:mealmate/components/mainCards/horizontalCard.dart';
import 'package:mealmate/components/mainCards/verticalCard.dart';
import 'package:provider/provider.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import '../../models&ReadCollectionModel/ListFoodItemModel.dart';
import '../../searchFoodItemProvider/searchFoodItemFunctionProvider.dart';
import '../../UserLocation/LocationProvider.dart';
import '../detail&checkout/detail.dart';

class SearchFoodItem extends StatefulWidget {
  const SearchFoodItem({super.key});

  @override
  State<SearchFoodItem> createState() => _SearchFoodItemState();
}

class _SearchFoodItemState extends State<SearchFoodItem> {
  final TextEditingController searchitemController = TextEditingController();
  final searchProvider = SearchProvider();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      appBar: AppBar(
        leading: IconButton(
          onPressed: () {
            Navigator.pop(context);
          },
          icon: Icon(
            Icons.arrow_back_ios,
            size: 20.spMin,
            color: Colors.blueGrey,
          ),
        ),
        automaticallyImplyLeading: false,
        centerTitle: true,
        title: Text('search'),
        titleTextStyle: TextStyle(
            color: Colors.blueGrey,
            fontWeight: FontWeight.normal,
            letterSpacing: 2,
            fontSize: 20.spMin),
        backgroundColor: Colors.white,
      ),
      body: Padding(
        padding: const EdgeInsets.all(5.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Padding(
              padding: const EdgeInsets.all(4.0),
              child: TextField(
                controller: searchitemController,
                style: TextStyle(color: Colors.deepOrange),
                decoration: InputDecoration(
                  hintText: 'foodName / restaurant / location',
                  fillColor: Colors.grey.shade100,
                  filled: true,
                  prefixIcon: Icon(
                    Icons.filter_alt_outlined,
                    color: Colors.black,
                  ),
                  suffixIcon: IconButton(
                    onPressed: () {
                      searchitemController.clear();
                    },
                    icon: Icon(
                      Icons.clear,
                      color: Colors.black,
                    ),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderSide: BorderSide(
                      color: Colors.deepOrangeAccent,
                      style: BorderStyle.none,
                    ),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  hintStyle: TextStyle(
                    color: Colors.black,
                    fontSize: 10.sp,
                  ),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                    borderSide: BorderSide(
                      color: Colors.deepOrangeAccent,
                      style: BorderStyle.solid,
                    ),
                  ),
                  label: Text('foodName / restaurant / location'),
                  labelStyle: TextStyle(color: Colors.grey, fontSize: 10.spMin),
                ),
                onChanged: (value) {
                  searchProvider.searchItem = value;
                  setState(() {
                    searchProvider.searchFoodItems();
                  });
                },
              ),
            ),
            Expanded(
              child: FutureBuilder(
                future: searchProvider.searchFoodItems(),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return Center(
                      child: NewSearchLoadingOutLook(),
                    );
                  } else if (snapshot.hasError) {
                    return Center(
                      child: Text('An error occurred: ${snapshot.error}'),
                    );
                  } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                    return Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Center(
                        child: noFoodFound(),
                      ),
                    );
                  } else {
                    final foodItems = snapshot.data as List<FoodItem>;
                    return FutureBuilder<LatLng>(
                      future: Provider.of<LocationProvider>(context, listen: false).getPoints(),
                      builder: (context, locationSnapshot) {
                        if (locationSnapshot.connectionState == ConnectionState.waiting) {
                          return Center(child: SingleChildScrollView(
                            child: Column(
                              children: [
                                NewSearchLoadingOutLook(),
                                NewSearchLoadingOutLook(),
                                NewSearchLoadingOutLook()

                              ],
                            ),
                          ));
                        } else if (locationSnapshot.hasError) {
                          return Center(child: Text('Error: ${locationSnapshot.error}'));
                        } else if (!locationSnapshot.hasData) {
                          return Center(child: Text('Unable to determine location'));
                        } else {
                          LatLng userLocation = locationSnapshot.data!;
                          List<FoodItem> nearbyRestaurants = foodItems.where((foodItem) {
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
                                    Navigator.push(
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
                                    );
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
                          );
                        }
                      },
                    );
                  }
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}