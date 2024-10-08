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
import 'package:mealmate/AdminPanel/Pages/Completed_Orders_Page.dart';
import 'package:mealmate/AdminPanel/Pages/UploadModel.dart';
import 'package:mealmate/AdminPanel/Pages/adminNotificationPage.dart';
import 'package:mealmate/AdminPanel/Pages/uploads.dart';
import 'package:mealmate/AdminPanel/collectionUploadModelProvider/collectionProvider.dart';
import 'package:mealmate/UserLocation/LocationProvider.dart';
import 'package:mealmate/components/CustomLoading.dart';
import 'package:mealmate/components/Notify.dart';
import 'package:mealmate/components/card1.dart';
import 'package:provider/provider.dart';
import 'package:mealmate/components/NoInternet.dart';
import '../../Local_Storage/Locall_Storage_Provider/StoreCredentials.dart';
import '../../Notification/notification_Provider.dart';
import '../OtherDetails/ID.dart';
import '../components/ChangeIDofAdmin.dart';
import '../components/adminCollectionRow.dart';
import 'IncomingOrdersPage.dart';
import 'Completed_Orders_Page.dart';


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
  TextEditingController adminContactController = TextEditingController();
  File? _image;
  String imageUrl = '';
  late int numberOfOrders ;

///IMAGE PICKER FUNCTION HERE
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

  /// UPLOAD FOOD ITEMS FUNCTION HERE
  Future<void> uploadFood(UploadModel food) async {
    try {
      _isLoading = true;

      final db = FirebaseFirestore.instance.collection(
          '${Provider.of<AdminCollectionProvider>(context, listen: false).collectionToUpload}');
      await db.add(food.toMap());
Notify(context, 'Item Uploaded Successfully', Colors.green);
      setState(() {
        _isLoading = false;
      });
    } catch (e) {
      ///print(e.toString());
      Notify(context, 'Upload Unsuccessful', Colors.red);
    }
  }

  ///BOOL TO CHECK FOR INTERNET
  ///
  bool _hasInternet = true;
  @override
  initState() {
    super.initState();
    /// Start listening to the internet connection status
    // InternetConnectionChecker().onStatusChange.listen((status) {
    //   setState(() {
    //     _hasInternet = status == InternetConnectionStatus.connected;
    //   });
    // });
  }


  Widget build(BuildContext context) {
final int adminId = Provider.of<AdminId>(context, listen: false).adminID;
    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      appBar: AppBar(
        backgroundColor: Colors.white,
        automaticallyImplyLeading: false,
        title: RichText(text: TextSpan(
            children: [
              TextSpan(text: "Welcome ", style: TextStyle(color: Colors.deepOrangeAccent, fontSize: 15.spMin,fontWeight: FontWeight.bold,fontFamily: 'Righteous',
              )),
              TextSpan(text: " !", style: TextStyle(color: Colors.black, fontSize: 15.spMin,fontWeight: FontWeight.bold)),


            ]
        )),

        centerTitle: true,
        elevation: 3,
        leading: Padding(
          padding: const EdgeInsets.all(8.0),
          child: GestureDetector(
            onTap: () {
              Navigator.push(
                  context, MaterialPageRoute(builder: (context) => IncomingOrders()));
            },
            child:  Badge(
              backgroundColor: Colors.green,
                  label:StreamBuilder(
           stream: Provider.of<IncomingOrdersProvider>(context, listen: false).fetchOrders(adminId),
           builder: (context, snapshot) {
             if (snapshot.connectionState == ConnectionState.waiting) {
                     return Center(
                        child: Text('Updating', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 8.sp, fontStyle: FontStyle.italic),),
                        );
                       } else if (snapshot.hasError) {
                            return Center(child: Center(child: Text('refresh page')));
             } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
               return Center(
                 child: Text('No Order Detected',style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold, fontSize: 8.sp, fontStyle: FontStyle.italic), ),
               );
             } else {
               return Text(snapshot.data!.length.toString(), style: TextStyle(color: Colors.white,fontWeight: FontWeight.bold,fontSize: 10.sp),);
             }
           }
              ),
                  child: ImageIcon(AssetImage('assets/Icon/Order.png'), size: 25.sp,color: Colors.blueGrey,),
                ),

          ),
        ),


        actions: [
          /// ICON BUTTON TO SHOW THE LIST OF COMPLETED ORDERS
          GestureDetector(
            onTap: () {
              Navigator.push(
                  context, MaterialPageRoute(builder: (context)=> CompletedOrders()));
            },
            child:  Badge(
              backgroundColor: Colors.green,
              label:StreamBuilder(
                  stream: Provider.of<IncomingOrdersProvider>(context, listen: false).fetchCompleteOrders(adminId),
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return Center(
                        child: Text('...', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 8.sp, fontStyle: FontStyle.italic),),
                      );
                    } else if (snapshot.hasError) {
                      return Center(child: Center(child: Text('refresh page')));
                    } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                      return Center(
                        child: Text('0',style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold, fontSize: 8.sp, fontStyle: FontStyle.italic), ),
                      );
                    } else {
                      return Text(snapshot.data!.length.toString(), style: TextStyle(color: Colors.white,fontWeight: FontWeight.bold,fontSize: 10.sp),);
                    }
                  }
              ),
              child: ImageIcon(AssetImage('assets/Icon/Orders.png'), size: 25.sp,color: Colors.blueGrey,),
            ),

          ),
          /// ICON BUTTON TO SHOW THE LIST OF ADMINS UPLOADS
          IconButton(
            onPressed: () {
              Navigator.push(
                  context, MaterialPageRoute(builder: (context) => Uploaded()));
            },
            icon: ImageIcon(
              AssetImage('assets/Icon/uploads.png'),
              size: 25.sp,
              color: Colors.deepOrangeAccent,
            ),
          ),

          /// THIS IS NOTIFICATION TO ALL ADMINS
          ///
          IconButton(
              onPressed: () {
                Navigator.push(
                    context, MaterialPageRoute(builder: (context) => AdminNotice()));
              },
              icon:Badge(
                backgroundColor: Colors.green,
                label: Builder(
                  builder: (context) {
                    Provider.of<NotificationProvider>(context, listen: false).getAdminNotifications();
                    return Consumer<NotificationProvider>(

                        builder: (context, value, child)
                        {
                          value.getAdminNotifications();

                          return  Text(
                            value.adminNotificationLength.toString(),
                            style: TextStyle(
                                color: Colors.white, fontWeight: FontWeight.bold),
                          );
                        });
                  }
                ),
                child: ImageIcon(AssetImage(
                    'assets/Icon/notification.png'
                ), color: Colors.blueGrey,size: 25.sp,
                ),
              )
            ),


          ///ICON BUTTON CHANGE THE ID OF ADMIN
          /// IT OPENS BUTTOMSHEETVIEW TO CHANGE THE ID
          ///
          ///
          IconButton(
            onPressed: () {
            Navigator.push(context, MaterialPageRoute(builder: (context)=> ChangeAdminCredentials()));
            },
            icon: ImageIcon(
               AssetImage('assets/Icon/change.png'),
              size: 25.sp,
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
                ///ADMIN PANEL TEXT
                RichText(text: TextSpan(
                    children: [
                      TextSpan(text: "Admin", style: TextStyle(color: Colors.black, fontSize: 25.spMin,fontWeight: FontWeight.bold,fontFamily: 'Righteous',)),
                      TextSpan(text: "Panel", style: TextStyle(color: Colors.deepOrangeAccent, fontSize: 25.spMin,fontWeight: FontWeight.bold,fontFamily: 'Righteous',),),


                    ]
                )),

                SizedBox(height: 30.h,),
                /// GET ADMIN EMAIL
                FutureBuilder(
                    future: Provider.of<LocalStorageProvider>(context, listen: false).getAdminEmail() ,
                    builder: (context, snapshot){
                      if(snapshot.hasData){
                        return Text(snapshot.data.toString(),  style: TextStyle(
                          letterSpacing: 1,
                          color: Colors.black,
                          fontSize: 15.spMin,
                        ),
                        );
                      }else{
                        return Text('adminemail@gmail.com ',  style: TextStyle(
                          letterSpacing: 1,
                          color: Colors.black,
                          fontSize: 15.spMin,
                          fontWeight: FontWeight.bold,
                        ),);
                      }
                    }),

                SizedBox(height: 30.h,),
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
                                fontSize: 10.sp));
                      }
                      return Text(
                        'locating you...',
                        style: TextStyle(color: Colors.deepOrangeAccent,fontSize: 10.spMin, fontWeight: FontWeight.bold),
                      );
                    }),
                SizedBox(
                  height: 30.h,
                ),

                ///TOGGLE BUTTON TO SHOW FOOD IS ONLINE
               _hasInternet ? LiteRollingSwitch(
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
                          .SwitchOnline(
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
                ) : NoInternetConnection(),
                SizedBox(
                  height: 30.h,
                ),
                Text(
                  'Upload Food Items Here',
                  style: TextStyle(fontSize: 15.sp, color: Colors.blueGrey),
                ),

                _isLoading ? SearchLoadingOutLook() : initAdminCard(),
                SizedBox(
                  height: 30.h,
                ),

                ///ROW OF BUTTONS TO SELECT THE FOOD COLLECTION YOU WAN TO UPLOAD

                Text('Please Select Collection bellow before Uploading Product and to view your uploads',
                    style: TextStyle(
                        fontSize: 10.sp,
                        color: Colors.blueGrey,
                        fontWeight: FontWeight.bold), textAlign: TextAlign.center,),

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
                          fontFamily: 'Righteous',
                          color: Colors.white,
                          letterSpacing: 3,
                          fontWeight: FontWeight.bold),
                    ),
                  ),
                ),
                SizedBox(
                  height: 30.h,
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
                                height: 150.h,
                                width: 150.h,
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
                            SizedBox(height: 20.h,),
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

                            SizedBox(height: 20.h,),
                            ///TEXTFIELD FOR MERCHANT ADMINCONTACT
                            Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: TextFormField(
                                keyboardType: TextInputType.number,
                                style: TextStyle(
                                  color: Colors.black,
                                ),
                                controller: adminContactController,
                                decoration: InputDecoration(
                                  filled: true,
                                  fillColor: Colors.deepOrange.shade50,
                                  labelText: 'Admin Contact',
                                  labelStyle: TextStyle(color: Colors.black),
                                  hintStyle: TextStyle(color: Colors.black),
                                  hintText: 'Admin Contact',
                                  border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(10),
                                    borderSide: BorderSide(
                                        color: Colors.deepOrangeAccent


                                    ),
                                  ),
                                ),
                                validator: (value) {
                                  if (value!.isEmpty) {
                                    return 'Please Enter Your Contact';
                                  }
                                  return null;
                                },
                              ),
                            ),
                            SizedBox(
                              height: 20.h,
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
                              height: 20.h,
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
                              height: 20.h,
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
                              height: 20.h,
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
                              height: 20.h,
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
                              height: 20.h,
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),

                SizedBox(
                  height: 20.h,
                ),

                ///UPLOAD FUNCTION FOR ADMIN
                SizedBox(
                  width: 200.w,
                  height: 50.h,
                  child: _isLoading
                      ? SearchLoadingOutLook()
                      : ElevatedButton(
                          style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.deepOrangeAccent
                          ),
                          onPressed: () {
                            if (_formkey.currentState!.validate() &&
                                _image?.path != null) {
                              uploadFood(
                                  UploadModel(
                                  latitude : Provider.of<LocationProvider>(context,listen: false).Lat.toDouble(),
                                  longitude: Provider.of<LocationProvider>(context,listen: false).Long.toDouble() ,
                                  isAvailable: true,
                                  imageUrl: imageUrl,
                                  restaurant: restaurantController.text.toLowerCase().trim(),
                                  foodName: foodNameController.text.toLowerCase().trim(),
                                  price: double.parse(priceController.text.trim()),
                                  location: locationController.text.toLowerCase().trim(),
                                  time: timeController.text.trim(),
                                  vendorId: int.parse(idController.text.trim()),
                                    adminEmail: Provider.of<LocalStorageProvider>(context,listen: false).adminEmail ,
                                    adminContact: int.parse(adminContactController.text),

                              ));

                              ///clearing the text fields
                              idController.clear();
                              restaurantController.clear();
                              foodNameController.clear();
                              priceController.clear();
                              locationController.clear();
                              timeController.clear();
                              adminContactController.clear();
                              setState(() {
                                _image = null;
                              });
                            } else {
                             Notify(context, 'Please pick an image and fill all fields ', Colors.red);
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

                SizedBox(height: 30.h,)
              ],
            ),
          ),
        ),
      ),
    );
  }
}
