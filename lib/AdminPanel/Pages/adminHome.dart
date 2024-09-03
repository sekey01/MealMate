import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:image_picker/image_picker.dart';
import 'package:lite_rolling_switch/lite_rolling_switch.dart';
import 'package:mealmate/AdminPanel/OtherDetails/AdminFunctionsProvider.dart';
import 'package:mealmate/AdminPanel/OtherDetails/incomingOrderProvider.dart';
import 'package:mealmate/AdminPanel/Pages/UploadModel.dart';
import 'package:mealmate/AdminPanel/Pages/uploads.dart';
import 'package:mealmate/AdminPanel/collectionUploadModelProvider/collectionProvider.dart';
import 'package:mealmate/UserLocation/LocationProvider.dart';
import 'package:mealmate/components/CustomLoading.dart';
import 'package:mealmate/components/Notify.dart';
import 'package:mealmate/components/card1.dart';
import 'package:provider/provider.dart';

import '../OtherDetails/ID.dart';
import '../components/ChangeIDofAdmin.dart';
import '../components/adminCollectionRow.dart';
import 'IncomingOrdersPage.dart';

class adminHome extends StatefulWidget {
  const adminHome({super.key});

  @override
  State<adminHome> createState() => _adminHomeState();
}

class _adminHomeState extends State<adminHome> {
  bool _isLoading = false;
  final _formkey = GlobalKey<FormState>();
  TextEditingController idController = TextEditingController();
  TextEditingController timeController = TextEditingController();
  TextEditingController restaurantController = TextEditingController();
  TextEditingController foodNameController = TextEditingController();
  TextEditingController priceController = TextEditingController();
  TextEditingController locationController = TextEditingController();
  File? _image;
  String imageUrl = '';
  late int numberOfOrders ;


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

          /// print(imageUrl);
        });
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          elevation: 20.sp,
          content: Center(
            child: Text(
              '$e',
              style: TextStyle(color: Colors.deepOrange, fontSize: 20),
            ),
          ),
          backgroundColor: Colors.black.withOpacity(0.5),
        ));
        // if (kDebugMode) {
        //   print("Failed to upload image: $e");
        // }
      }
    }
  }

  /// Firebase funtion to upload food items
  Future<void> uploadFood(UploadModel food) async {
    try {
      _isLoading = true;

      final db = FirebaseFirestore.instance.collection(
          '${Provider.of<AdminCollectionProvider>(context, listen: false).collectionToUpload}');
      await db.add(food.toMap());

      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        elevation: 20,
        content: Center(
          child: Text(
            ' Food Uploaded Successfully ',
            style: TextStyle(
                color: Colors.green,
                fontSize: 15.sp,
                fontWeight: FontWeight.bold),
          ),
        ),
        backgroundColor: Colors.black.withOpacity(0.5),
      ));
      setState(() {
        _isLoading = false;
      });
    } catch (e) {
      ///print(e.toString());
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        elevation: 20,
        content: Center(
          child: Text(
            ' Upload Unsuccessfull ',
            style: TextStyle(color: Colors.red, fontSize: 20),
          ),
        ),
        backgroundColor: Colors.black.withOpacity(0.5),
      ));
    }
  }

  @override
  initState() {
    super.initState();
    //Notify(context, 'Welcome', Colors.red);

    WidgetsBinding.instance.addPostFrameCallback((_){


      Provider.of<AdminId>(context, listen: false).loadId();


    });
    // Call the loadId function from AdminId provider
  }


  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      appBar: AppBar(
        leading: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Badge(
            backgroundColor: Colors.green,
            textColor: Colors.white,
            label: Provider.of<IncomingOrdersProvider>(context, listen: false).gotIncomingOrdersIndex ? Consumer<IncomingOrdersProvider>(builder: (context, value, child){
               return StreamBuilder(
              stream: value.fetchOrders( Provider.of<AdminId>(context, listen: false).adminID),
                  builder: (context, snapshot) {

                       if (snapshot.connectionState == ConnectionState.waiting) {
                        // print(111111111111);
                             return Center(
                                   child: Text('Updating...'),);}

                       else if(snapshot.hasData && snapshot.data != null){
                       //  print(22222222222);

                  numberOfOrders = snapshot.data!.length;
                         return Text('${numberOfOrders.toString()}', style: TextStyle(fontWeight: FontWeight.bold),);

                       }
                       else if (snapshot.hasError) {
                      //   print(333333333333);
                             return Center(child: Text('refresh page'));}
                       else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                       //  print(4444444444);
                             return Center( child: Text('Empty',style: TextStyle(fontWeight: FontWeight.bold,color: Colors.white)));
                      }
                      else {
                      //  print(5555555555);
                             return Text('0', style: TextStyle(fontWeight: FontWeight.bold),);
              }

            });}): Text('0')

            /*Text(
             Provider.of<IncomingOrdersProvider>(context, listen: false).IncomingOrdersIndex.toString(),

              // You can now use the provider
              style: TextStyle(fontWeight: FontWeight.bold),
            )*/,
            child: IconButton(
              onPressed: () {
                Navigator.push(context,
                    MaterialPageRoute(builder: (context) => IncomingOrders()));
              },
              icon: ImageIcon(
                AssetImage('assets/Icon/Orders.png'),
                color: Colors.blueGrey


,
                size: 40,
              ),
            ),
          ),
        ),
        backgroundColor: Colors.white70,
        automaticallyImplyLeading: false,
        title: Text('Admin Panel'),
        titleTextStyle: TextStyle(
            color: Colors.blueGrey,
            fontSize: 20.spMin,
            fontWeight: FontWeight.bold,
            letterSpacing: 2),
        centerTitle: true,
        actions: [
          /// ICON BUTTON TO SHOW THE LIST OF ADMINS UPLOADS
          IconButton(
            onPressed: () {
              Navigator.push(
                  context, MaterialPageRoute(builder: (context) => Uploaded()));
            },
            icon: ImageIcon(
               AssetImage('assets/Icon/uploads.png'),
              size: 30.spMin,
              color: Colors.deepOrangeAccent,
            ),
          ),
          SizedBox(
            width: 5.w,
          ),

          ///ICON BUTTON CHANGE THE ID OF ADMIN
          /// IT OPENS BUTTOMSHEETVIEW TO CHANGE THE ID
          ///
          ///
          IconButton(
            onPressed: () {
              showModalBottomSheet(
                useSafeArea: true,
                enableDrag: true,
                showDragHandle: true,
                elevation: 4.sp,
                isDismissible: true,
                shape: Border.all(
                  color: Colors.black,
                ),
                context: (context),
                builder: (context) {
                  return SingleChildScrollView(child: changeIdWidget());
                },
              );
            },
            icon: ImageIcon(
               AssetImage('assets/Icon/change.png'),
              size: 30,
              color: Colors.blueGrey


,
            ),
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              children: <Widget>[
                ///LOCATION DISPLAYED HERE
                ///
                ///
                FutureBuilder(
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
                                fontSize: 10.spMin));
                      }
                      return Text(
                        'locating you...',
                        style: TextStyle(color: Colors.deepOrangeAccent,fontSize: 10.spMin, fontWeight: FontWeight.bold),
                      );
                    }),
                SizedBox(
                  height: 15,
                ),

                ///TOGGLE BUTTON TO SHOW FOOD IS ONLINE
                LiteRollingSwitch(
                  //initial value
                  value: false,
                  width: 200.w,
                  textOn: 'Online',
                  textOnColor: Colors.white,
                  textOff: 'Offline',
                  textOffColor: Colors.white,
                  colorOn: CupertinoColors.activeGreen,
                  colorOff: Colors.redAccent,
                  iconOn: Icons.done,
                  iconOff: Icons.remove_circle_outline,
                  textSize: 20.0,
                  onChanged: (bool state) {
                  /// print(Provider.of<AdminId>(context, listen: false).id);

                    setState(() {
                    //  Provider.of<IncomingOrdersProvider>(context, listen: false).fetchOrders(Provider.of<AdminId>(context).id);

                      Provider.of<AdminFunctions>(context, listen: false)
                          .Switch(
                              context,
                              Provider.of<AdminId>(context, listen: false).id,
                              state);
                    });

                   ///Use it to manage the different states
                   //print('Current State of SWITCH IS: $state');
                  },
                  onTap: () {
                  },
                  onDoubleTap: () {},
                  onSwipe: () {},
                ),
                SizedBox(
                  height: 20,
                ),
                Text(
                  'Upload Food Items Here',
                  style: TextStyle(fontSize: 15.sp, color: Colors.blueGrey),
                ),

                _isLoading ? CustomLoGoLoading() : initCard(),
                SizedBox(
                  height: 30.h,
                ),

                ///ROW OF BUTTONS TO SELECT THE FOOD COLLECTION YOU WAN TO UPLOAD
                Image(
                  image: AssetImage('assets/Icon/alert.png'),
                  height: 30.h,
                  width: 30.w,
                ),
                Text('Please Select Collection bellow to Upload Product',
                    style: TextStyle(
                        fontSize: 10.sp,
                        color: Colors.blueGrey,
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

                /// CONTAINER TO SHOW/DISPLAY SELECTED COLLECTION
                Container(
                  height: 40,
                  width: double.infinity,
                  decoration: BoxDecoration(
                    color: Colors.green,
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Center(
                    child: Text(
                      Provider.of<AdminCollectionProvider>(context)
                          .collectionToUpload,
                      style: TextStyle(
                          color: Colors.white,
                          letterSpacing: 3,
                          fontWeight: FontWeight.bold),
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
                    label: Text('Select Product Image'),
                    textStyle: TextStyle(letterSpacing: 3, fontSize: 10),
                    alignment: Alignment.topLeft,
                    backgroundColor: Colors.black,
                    textColor: Colors.white,
                    child: Material(
                      elevation: 4,
                      borderRadius: BorderRadius.circular(35),
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
                            : Image(
                                image:
                                    AssetImage('assets/Icon/selectImage.png'),
                                height: 200,
                                width: 200,
                              ),
                      ),
                    ),
                  ),
                ),

                Column(
                  /// COLUMN THAT TAKES ALL THE TEXTFIELDS
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Form(
                        key: _formkey,
                        child: Column(
                          children: [
                            ///TEXTFIELD FOR MERCHANT ID
                            Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: TextFormField(
                                keyboardType: TextInputType.number,
                                style: TextStyle(
                                  color: Colors.black,
                                ),
                                controller: idController,
                                decoration: InputDecoration(
                                  filled: true,
                                  fillColor: Colors.deepOrange.shade50,
                                  labelText: 'Merchant ID',
                                  labelStyle: TextStyle(color: Colors.black),
                                  hintStyle: TextStyle(color: Colors.black),
                                  hintText: 'Merchant ID',
                                  border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(10),
                                    borderSide: BorderSide(
                                        color: Colors.deepOrangeAccent


),
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

                            ///TEXTFIELD FOR RESTAURANT NAME
                            Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: TextFormField(
                                style: TextStyle(color: Colors.black),
                                controller: restaurantController,
                                decoration: InputDecoration(
                                  filled: true,
                                  fillColor: Colors.deepOrange.shade50,
                                  hintStyle: TextStyle(color: Colors.black),
                                  //label: Text('Restaurant Name'),
                                  labelStyle: TextStyle(color: Colors.black),
                                  labelText: 'restaurant name',
                                  hintText: ' restaurant name',

                                  border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(10),
                                    borderSide: BorderSide(
                                        color: Colors.deepOrangeAccent


),
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

                            ///TEXTFIELD FOR TIME
                            Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: TextFormField(
                                style: TextStyle(color: Colors.black),
                                controller: timeController,
                                decoration: InputDecoration(
                                  filled: true,
                                  fillColor: Colors.deepOrange.shade50,
                                  hintStyle: TextStyle(color: Colors.black),
                                  //label: Text('Restaurant Name'),
                                  labelStyle: TextStyle(color: Colors.black),
                                  labelText: 'time',
                                  hintText: ' time',

                                  border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(10),
                                    borderSide: BorderSide(
                                        color: Colors.deepOrangeAccent


),
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

                            ///TEXTFIELD FOR LOCATION
                            Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: TextFormField(
                                style: TextStyle(color: Colors.black),
                                controller: locationController,
                                decoration: InputDecoration(
                                  filled: true,
                                  fillColor: Colors.deepOrange.shade50,
                                  hintStyle: TextStyle(color: Colors.black),
                                  //label: Text('Restaurant Name'),
                                  labelStyle: TextStyle(color: Colors.black),
                                  labelText: 'location',
                                  hintText: ' location',

                                  border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(10),
                                    borderSide: BorderSide(
                                        color: Colors.deepOrangeAccent


),
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

                            ///TEXTFIELD FOR FOODNAME
                            Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: TextFormField(
                                style: TextStyle(color: Colors.black),
                                controller: foodNameController,
                                decoration: InputDecoration(
                                  filled: true,
                                  fillColor: Colors.deepOrange.shade50,
                                  hintStyle: TextStyle(color: Colors.black),
                                  labelStyle: TextStyle(color: Colors.black),
                                  labelText: 'food name',
                                  enabled: true,
                                  hintText: 'food name',
                                  border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(10),
                                    borderSide: BorderSide(
                                        color: Colors.deepOrangeAccent


),
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

                            ///TEXTFIELD FOR PRICE
                            Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: TextFormField(
                                keyboardType: TextInputType.number,
                                style: TextStyle(color: Colors.black),
                                controller: priceController,
                                decoration: InputDecoration(
                                  filled: true,
                                  fillColor: Colors.deepOrange.shade50,
                                  labelStyle: TextStyle(color: Colors.black),
                                  hintStyle: TextStyle(color: Colors.black),
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

                ///UPLOAD FUNCTION FOR ADMIN
                SizedBox(
                  width: 200,
                  height: 50,
                  child: _isLoading
                      ? CustomLoGoLoading()
                      : ElevatedButton(
                          style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.deepOrangeAccent


),
                          onPressed: () {
                            if (_formkey.currentState!.validate() &&
                                _image?.path != null) {
                              uploadFood(UploadModel(
                                  isAvailable: true,
                                  imageUrl: imageUrl,
                                  restaurant: restaurantController.text.trim(),
                                  foodName: foodNameController.text.trim(),
                                  price:
                                      double.parse(priceController.text.trim()),
                                  location: locationController.text.trim(),
                                  time: timeController.text.trim(),
                                  vendorId:
                                      int.parse(idController.text.trim())));

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
                              ScaffoldMessenger.of(context)
                                  .showSnackBar(SnackBar(
                                elevation: 20,
                                content: Center(
                                  child: Text(
                                    'Please Fill All Fields and Select Image',
                                    style: TextStyle(
                                        color: Colors.white, fontSize: 20),
                                  ),
                                ),
                                backgroundColor: Colors.red.withOpacity(0.5),
                              ));
                            }
                          },
                          child: Text(
                            'Upload Food',
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
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
