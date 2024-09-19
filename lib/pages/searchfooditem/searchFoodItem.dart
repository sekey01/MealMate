import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:mealmate/components/CustomLoading.dart';
import 'package:mealmate/components/NoFoodFound.dart';
import 'package:mealmate/components/mainCards/horizontalCard.dart';

import '../../models&ReadCollectionModel/ListFoodItemModel.dart';
import '../../searchFoodItemProvider/searchFoodItemFunctionProvider.dart';
import '../detail&checkout/detail.dart';

class SearchFoodItem extends StatefulWidget {
  const SearchFoodItem({super.key});

  @override
  State<SearchFoodItem> createState() => _SearchFoodItemState();
}

class _SearchFoodItemState extends State<SearchFoodItem> {
  final TextEditingController searchitemController = TextEditingController();

  /// search provider instance
  ///
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
              padding: const EdgeInsets.all(2.0),
              child: TextField(
                controller: searchitemController,
                style: TextStyle(color: Colors.deepOrange),
                decoration: InputDecoration(
                  hintText: 'foodName / restaurant / location',
                  fillColor: Colors.deepOrange.shade50,
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

                    ///borderSide: BorderSide(color: Colors.red),
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
                  //print("this is the ${value.toString()}");
                  setState(() {
                    searchProvider.searchFoodItems();
                  });

                  /// Trigger rebuild to update search results
                },
              ),
            ),
            Expanded(
              child: FutureBuilder(
                future: searchProvider.searchFoodItems(),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return Center(
                      child: CustomLoGoLoading(),
                    );
                  } else if (snapshot.hasError) {
                    return Center(
                      child: Text('An error occurred: ${snapshot.error}'),
                    );
                  } else if (snapshot.data!.isEmpty) {
                    return Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Center(
                        child: noFoodFound(),
                      ),
                    );
                  } else {
                    final foodItems = snapshot.data as List<FoodItem>;

                    return ListView.builder(
                      itemCount: foodItems.length,
                      itemBuilder: (context, index) {
                        final foodItem = foodItems[index];
                        return Padding(
                            padding: const EdgeInsets.all(4.0),
                            child: Material(
                              color: Colors.white,
                              elevation: 2,
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
                                          )));
                                },
                                child: horizontalCard(
                                  foodItem.imageUrl,
                                  foodItem.restaurant,
                                  foodItem.foodName,
                                  foodItem.price,
                                  foodItem.location,
                                  foodItem.time,
                                  foodItem.vendorId,
                                  foodItem.latitude,
                                  foodItem.longitude,
                                  foodItem.adminEmail,
                                  foodItem.adminContact,
                                ),
                              ),
                            ));
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
