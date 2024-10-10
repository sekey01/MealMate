import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:mealmate/AdminPanel/OtherDetails/ID.dart';
import 'package:mealmate/AdminPanel/components/adminHorizontalCard.dart';
import 'package:mealmate/components/CustomLoading.dart';
import 'package:mealmate/components/NoFoodFound.dart';
import 'package:provider/provider.dart';

import '../../models&ReadCollectionModel/ListFoodItemModel.dart';
import '../collectionUploadModelProvider/collectionProvider.dart';

class Uploaded extends StatefulWidget {
  const Uploaded({super.key});

  @override
  State<Uploaded> createState() => _UploadedState();
}

class _UploadedState extends State<Uploaded> {
  @override
  initState() {
    /// I CALLED THE FUNCTION IN THE ADMINID PROVIDER WHEN EVER THIS PAGE IS LAUNCHED
    /// I USED THE INITSTATE() TO DO THIS
    super.initState();
    context.read<AdminId>().loadId();
  }

  bool NoInternet = false;

  ///FUNCTION TO READ ALL ADMIN UPLOADS BASE ON THE ID PROVIDED
  Future<List<FoodItem>> fetchFoodItems(String collection, int id) async {
    int retryCount = 3;
    int attempt = 0;
    while (attempt < retryCount) {
      try {
        QuerySnapshot snapshot =
            await FirebaseFirestore.instance.collection(collection)
                .where('vendorId', isEqualTo:id )
                .get();
        return snapshot.docs
            .map((doc) =>
                FoodItem.fromMap(doc.data() as Map<String, dynamic>, doc.id))
            .toList();
      } on SocketException catch (e) {
        attempt++;
        if (attempt >= retryCount) {
          print("Internet Problem: $e");
          return [];
        }
        await Future.delayed(Duration(seconds: 2)); // wait before retrying
      } catch (e) {
        print("Error fetching food items: $e");
        return [];
      }
    }
    print('noooooooooooooo');
    return [];
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        elevation: 3,
        automaticallyImplyLeading: false,
        leading:IconButton(onPressed: (){
          Navigator.pop(context);
        }, icon: Icon(Icons.arrow_back_ios), color: Colors.blueGrey,),
        titleTextStyle: TextStyle(
          letterSpacing: 3,
          color: Colors.white,
          fontSize: 20,
        ),
        backgroundColor: Colors.white,

        /// automaticallyImplyLeading: false,
        centerTitle: true,
        title: Consumer<AdminId>(builder: (context, value, child) {
          return Center(
            child: Text(
              'ID: ${value.id}',
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15, color: Colors.blueGrey),
            ),
          );
        }),
        actions: [
          IconButton(
              onPressed: () {
                setState(() {});
              },
              icon: ImageIcon(
                AssetImage('assets/Icon/refresh.png'),
                size: 35.sp,
                color: Colors.blueGrey,
              ))
        ],
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(4.0),
          child: SafeArea(
              child: Center(
            child: Container(
                color: Colors.white,
                width: double.infinity,
                height: 19900,
                child: FutureBuilder<List<FoodItem>>(
                  future: fetchFoodItems(
                    Provider.of<AdminCollectionProvider>(context)
                        .collectionToUpload, Provider.of<AdminId>(context, listen: false).id
                  ),
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return Center(child: SearchLoadingOutLook());
                    } else if (snapshot.hasError) {
                      return Center(child: Text('Error: Try Again later', style: TextStyle(color: Colors.deepOrangeAccent),));
                    } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                      return Center(child: noFoodFound());
                    } else {
                      return ListView.builder(
                        itemCount: snapshot.data!.length,
                        itemBuilder: (context, index) {
                          final upload = snapshot.data![index];
                          return Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: adminHorizontalCard(
                              upload.imageUrl,
                              upload.restaurant,
                              upload.location,
                              upload.foodName,
                              upload.price,
                              upload.vendorId,
                              upload.time,
                              upload.isAvailable,
                            ),
                          );
                        },
                      );
                    }
                  },
                )),
          )),
        ),
      ),
    );
  }
}
