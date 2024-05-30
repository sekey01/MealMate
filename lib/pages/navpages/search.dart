import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:mealmate/components/detailedCard.dart';
import 'package:mealmate/components/verticalCard.dart';
import 'package:mealmate/pages/detail&checkout/detail.dart';
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
  final TextEditingController textController = TextEditingController();
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        centerTitle: true,
        title: Text('MealMate'),
        titleTextStyle: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
            letterSpacing: 3,
            fontSize: 17),
        backgroundColor: Colors.deepOrange,
      ),
      body: Column(
        children: [
          Text(
            'Tap to view collection items',
            style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 13,
                letterSpacing: 2,
                color: Colors.black),
          ),
          SizedBox(height: 10),
          Padding(
            padding: const EdgeInsets.all(10.0),
            child: Container(
              height: 60,
              width: double.infinity,
              decoration: BoxDecoration(
                border: Border.all(color: Colors.deepOrangeAccent),
                color: Colors.transparent,
                borderRadius: BorderRadius.circular(10),
              ),
              child: Consumer<userCollectionProvider>(
                  builder: (context, value, child) {
                return ListView.builder(
                  itemBuilder: (context, index) {
                    return GestureDetector(
                      onTap: () {
                        /// The State is not rebuilding so i used the setstate method to rebuild the state
                        setState(() {});
                        value.changeIndex(index);
                      },
                      child:
                          userCollectionItemsRow(value.collectionList[index]),
                    );
                  },
                  scrollDirection: Axis.horizontal,
                  itemCount: value.collectionList.length,
                );
              }),
            ),
          ),
          Expanded(
              child: FutureBuilder<List<FoodItem>>(
                  future: fetchFoodItems(Provider.of<userCollectionProvider>(
                          context,
                          listen: false)
                      .collectionToRead),
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return Center(child: CircularProgressIndicator());
                    } else if (snapshot.hasError) {
                      return Center(child: Text('Error: ${snapshot.error}'));
                    } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                      return Center(
                          child: Text(
                        'No food items found.',
                        style: TextStyle(color: Colors.black),
                      ));
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
                                Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) => Detail(
                                            detail: detailedCard(
                                                data.imageUrl,
                                                data.restaurant,
                                                data.foodName,
                                                data.price,
                                                data.location,
                                                data.vendorId,
                                                data.time))));
                              },
                              child: verticalCard(
                                  data.imageUrl,
                                  data.restaurant,
                                  data.foodName,
                                  data.price,
                                  data.location,
                                  data.time,
                                  data.vendorId.toString()),
                            );
                          });
                    }
                  }))
        ],
      ),
    );
  }
}
