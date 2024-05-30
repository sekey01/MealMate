import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:mealmate/AdminPanel/Pages/UploadModel.dart';
import 'package:mealmate/AdminPanel/Pages/uploads.dart';
import 'package:mealmate/AdminPanel/collectionUploadModelProvider/collectionProvider.dart';
import 'package:mealmate/components/card1.dart';
import 'package:provider/provider.dart';

import '../components/adminCollectionRow.dart';

class adminHome extends StatefulWidget {
  const adminHome({super.key});

  @override
  State<adminHome> createState() => _adminHomeState();
}

class _adminHomeState extends State<adminHome> {
  final _formkey = GlobalKey<FormState>();
  TextEditingController idController = TextEditingController();
  TextEditingController timeController = TextEditingController();
  TextEditingController restaurantController = TextEditingController();
  TextEditingController foodNameController = TextEditingController();
  TextEditingController priceController = TextEditingController();
  TextEditingController locationController = TextEditingController();
  File? _image;
  String imageUrl = '';

  Future<void> _pickImage() async {
    final ImagePicker picker = ImagePicker();
    final XFile? pickedFile =
        await picker.pickImage(source: ImageSource.gallery);

    if (pickedFile != null) {
      setState(() {
        _image = File(pickedFile.path);
      });

      try {
        String fileName =
            '${idController.text}/ ${foodNameController.text}/${DateTime.now().microsecondsSinceEpoch}';
        UploadTask uploadTask = FirebaseStorage.instance
            .ref()
            .child(fileName)
            .putFile(File(_image!.path));
        TaskSnapshot snapshot = await uploadTask;
        String downloadUrl = await snapshot.ref.getDownloadURL();

        setState(() {
          imageUrl = downloadUrl;
          print(imageUrl);
        });
      } catch (e) {
        if (kDebugMode) {
          print("Failed to upload image: $e");
        }
      }
    }
  }

  /// Firebase funtion to upload food items
  Future<void> uploadFood(UploadModel food) async {
    try {
      final db = FirebaseFirestore.instance.collection(
          '${Provider.of<AdminCollectionProvider>(context, listen: false).collectionToUpload}');
      await db.add(food.toMap());
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        elevation: 20,
        content: Center(
          child: Text(
            ' Food Uploaded Successfully ',
            style: TextStyle(color: Colors.white, fontSize: 20),
          ),
        ),
        backgroundColor: Colors.green.withOpacity(0.5),
      ));
    } catch (e) {
      print(e.toString());
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: Text('Admin Panel'),
        centerTitle: true,
        actions: [
          IconButton(
            onPressed: () {
              Navigator.push(
                  context, MaterialPageRoute(builder: (context) => Uploaded()));
            },
            icon: Icon(Icons.list_alt),
          ),
          SizedBox(
            width: 5,
          )
        ],
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              children: <Widget>[
                Text(
                  'Welcome to Admin Panel',
                  style: TextStyle(fontSize: 20, color: Colors.black),
                ),
                initCard(),
                SizedBox(
                  height: 10,
                ),
                Text('Select Collection to Upload Product',
                    style: TextStyle(
                        fontSize: 10,
                        color: Colors.black,
                        fontWeight: FontWeight.bold)),

                ///COLLECTION FOR THE TYPE OF PRODUCT TO BE UPLOADED

                Container(
                  height: 50,
                  width: double.infinity,
                  child: Consumer<AdminCollectionProvider>(
                      builder: (context, value, child) {
                    return ListView.builder(
                      scrollDirection: Axis.horizontal,
                      itemCount: value.collectionList.length,
                      itemBuilder: (context, index) {
                        return GestureDetector(
                            onTap: () {
                              value.changeIndex(index);
                            },
                            child: adminCollectionItemsRow(
                                value.collectionList[index]));
                      },
                    );
                  }),
                ),
                SizedBox(
                  height: 20,
                ),

                /// CONTAINER TO SHOW SELECTED COLLECTION
                Container(
                  height: 40,
                  width: double.infinity,
                  decoration: BoxDecoration(
                    color: Colors.deepOrangeAccent,
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Center(
                    child: Text(
                      Provider.of<AdminCollectionProvider>(context)
                          .collectionToUpload,
                      style: TextStyle(color: Colors.white, letterSpacing: 3),
                    ),
                  ),
                ),
                SizedBox(
                  height: 20,
                ),

                ///PICK YOUR IMAGE OF FOOD HERE
                GestureDetector(
                  onTap: () {
                    _pickImage();

                    ///IMAGE PICKER FUNCTION HERE
                  },
                  child: Badge(
                    label: Text('Tap to Select Image'),
                    textStyle: TextStyle(letterSpacing: 3, fontSize: 10),
                    alignment: Alignment.topLeft,
                    backgroundColor: Colors.black,
                    textColor: Colors.white,
                    child: Material(
                      elevation: 4,
                      color: Colors.white,
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(10),
                        child: _image != null
                            ? Image.file(
                                height: 190,
                                width: 190,
                                _image!,
                                fit: BoxFit.fill,
                              )
                            : Icon(
                                Icons.camera_alt_outlined,
                                size: 190,
                                color: Colors.deepOrange,
                              ),
                      ),
                    ),
                  ),
                ),
                Column(
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Form(
                        key: _formkey,
                        child: Column(
                          children: [
                            Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: TextFormField(
                                keyboardType: TextInputType.number,
                                style: TextStyle(color: Colors.black),
                                controller: idController,
                                decoration: InputDecoration(
                                  enabledBorder: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(10),
                                    borderSide: BorderSide(
                                        color: Colors.deepOrangeAccent),
                                  ),
                                  labelText: 'Merchant ID',
                                  labelStyle: TextStyle(color: Colors.grey),
                                  hintStyle: TextStyle(color: Colors.grey),
                                  hintText: 'Merchant ID',
                                  border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(10),
                                    borderSide: BorderSide(
                                        color: Colors.deepOrangeAccent),
                                  ),
                                ),
                                validator: (value) {
                                  if (value!.isEmpty) {
                                    return 'Please Enter ID';
                                  }
                                  return null;
                                },
                              ),
                            ),
                            SizedBox(
                              height: 10,
                            ),
                            Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: TextFormField(
                                style: TextStyle(color: Colors.black),
                                controller: restaurantController,
                                decoration: InputDecoration(
                                  enabledBorder: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(10),
                                    borderSide: BorderSide(
                                        color: Colors.deepOrangeAccent),
                                  ),
                                  hintStyle: TextStyle(color: Colors.grey),
                                  //label: Text('Restaurant Name'),
                                  labelStyle: TextStyle(color: Colors.grey),
                                  labelText: 'restaurant name',
                                  hintText: ' restaurant name',

                                  border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(10),
                                    borderSide: BorderSide(
                                        color: Colors.deepOrangeAccent),
                                  ),
                                ),
                                validator: (value) {
                                  if (value!.isEmpty) {
                                    return 'Please Enter Restaurant Name';
                                  }
                                  return null;
                                },
                              ),
                            ),
                            SizedBox(
                              height: 10,
                            ),
                            Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: TextFormField(
                                style: TextStyle(color: Colors.black),
                                controller: timeController,
                                decoration: InputDecoration(
                                  enabledBorder: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(10),
                                    borderSide: BorderSide(
                                        color: Colors.deepOrangeAccent),
                                  ),
                                  hintStyle: TextStyle(color: Colors.grey),
                                  //label: Text('Restaurant Name'),
                                  labelStyle: TextStyle(color: Colors.grey),
                                  labelText: 'time',
                                  hintText: ' time',

                                  border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(10),
                                    borderSide: BorderSide(
                                        color: Colors.deepOrangeAccent),
                                  ),
                                ),
                                validator: (value) {
                                  if (value!.isEmpty) {
                                    return 'Please Enter Time';
                                  }
                                  return null;
                                },
                              ),
                            ),
                            SizedBox(
                              height: 10,
                            ),
                            Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: TextFormField(
                                style: TextStyle(color: Colors.black),
                                controller: locationController,
                                decoration: InputDecoration(
                                  enabledBorder: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(10),
                                    borderSide: BorderSide(
                                        color: Colors.deepOrangeAccent),
                                  ),
                                  hintStyle: TextStyle(color: Colors.grey),
                                  //label: Text('Restaurant Name'),
                                  labelStyle: TextStyle(color: Colors.grey),
                                  labelText: 'location',
                                  hintText: ' location',

                                  border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(10),
                                    borderSide: BorderSide(
                                        color: Colors.deepOrangeAccent),
                                  ),
                                ),
                                validator: (value) {
                                  if (value!.isEmpty) {
                                    return 'Please Enter location';
                                  }
                                  return null;
                                },
                              ),
                            ),
                            SizedBox(
                              height: 10,
                            ),
                            Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: TextFormField(
                                style: TextStyle(color: Colors.black),
                                controller: foodNameController,
                                decoration: InputDecoration(
                                  enabledBorder: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(10),
                                    borderSide: BorderSide(
                                        color: Colors.deepOrangeAccent),
                                  ),
                                  hintStyle: TextStyle(color: Colors.grey),
                                  labelStyle: TextStyle(color: Colors.grey),
                                  labelText: 'food name',
                                  enabled: true,
                                  hintText: 'food name',
                                  border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(10),
                                    borderSide: BorderSide(
                                        color: Colors.deepOrangeAccent),
                                  ),
                                ),
                                validator: (value) {
                                  if (value!.isEmpty) {
                                    return 'Please Enter Food Name';
                                  }
                                  return null;
                                },
                              ),
                            ),
                            SizedBox(
                              height: 10,
                            ),
                            Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: TextFormField(
                                keyboardType: TextInputType.number,
                                style: TextStyle(color: Colors.black),
                                controller: priceController,
                                decoration: InputDecoration(
                                  enabledBorder: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(10),
                                    borderSide: BorderSide(
                                        color: Colors.deepOrangeAccent),
                                  ),
                                  labelStyle: TextStyle(color: Colors.grey),
                                  hintStyle: TextStyle(color: Colors.grey),
                                  labelText: 'price',
                                  hintText: 'price',
                                  border: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(10),
                                      borderSide:
                                          BorderSide(color: Colors.deepOrange)),
                                ),
                                validator: (value) {
                                  if (value!.isEmpty) {
                                    return 'Please Enter Price';
                                  }
                                  return null;
                                },
                              ),
                            ),
                            SizedBox(
                              height: 10,
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),

                SizedBox(
                  height: 20,
                ),

                SizedBox(
                  width: 200,
                  height: 50,
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.deepOrangeAccent),
                    onPressed: () {
                      if (_formkey.currentState!.validate() &&
                          _image?.path != null) {
                        uploadFood(UploadModel(
                            imageUrl: imageUrl,
                            restaurant: restaurantController.text.trim(),
                            foodName: foodNameController.text.trim(),
                            price: double.parse(priceController.text.trim()),
                            location: locationController.text.trim(),
                            time: timeController.text.trim(),
                            vendorId: int.parse(idController.text.trim())));

                        //clearing the text fields
                        idController.clear();
                        restaurantController.clear();
                        foodNameController.clear();
                        priceController.clear();
                        locationController.clear();
                        timeController.clear();
                        setState(() {
                          _image = null;
                        });
                      } else {
                        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                          elevation: 20,
                          content: Center(
                            child: Text(
                              'Please Fill All Fields',
                              style:
                                  TextStyle(color: Colors.white, fontSize: 20),
                            ),
                          ),
                          backgroundColor: Colors.red.withOpacity(0.5),
                        ));
                      }
                    },
                    child: Text(
                      'Upload Food',
                      style: TextStyle(
                        color: Colors.white,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
