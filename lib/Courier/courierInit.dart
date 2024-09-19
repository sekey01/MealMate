import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:mealmate/Courier/trackbuyer.dart';
import 'package:provider/provider.dart';

import '../UserLocation/LocationProvider.dart';
import '../components/card1.dart';

class CourierInit extends StatefulWidget {
  const CourierInit({super.key});

  @override
  State<CourierInit> createState() => _CourierInitState();
}

class _CourierInitState extends State<CourierInit> {
  final _formKey = GlobalKey<FormState>();

  final TextEditingController LatitudeController = TextEditingController();
  final TextEditingController LongitudeController = TextEditingController();
  final TextEditingController PhoneNumberController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    ///I RUN THE DETERMIN LOCATION HERE TO GET THE LAT AND LONG QUICKLY
    Provider.of<LocationProvider>(
        context,
        listen: false).determinePosition();
    return  Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      appBar: AppBar(
        automaticallyImplyLeading: false,
        leading: IconButton(onPressed: (){
          Navigator.pop(context);
        }, icon: Icon(Icons.arrow_back_ios), color: Colors.blueGrey,),
        backgroundColor: Colors.white,
        title: RichText(text: TextSpan(
            children: [
              TextSpan(text: "Courier", style: TextStyle(color: Colors.black, fontSize: 20.spMin,fontWeight: FontWeight.bold)),
              TextSpan(text: "Panel", style: TextStyle(color: Colors.deepOrangeAccent, fontSize: 20.spMin,fontWeight: FontWeight.bold)),

            ]
        )),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Center(
          child: SingleChildScrollView(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                initCourierCard(),
                SizedBox(height: 50.h,),

                Badge(
                  backgroundColor: Colors.green,
                  alignment: Alignment.bottomLeft,
                  label: Text('Get rewarded MealMate Dress soon...', style: TextStyle(color: Colors.white,fontWeight: FontWeight.bold,fontSize: 10.sp),),
                  child: Padding(padding: EdgeInsets.all(1),
                      child: Image(image: AssetImage('assets/images/MealmateDress.png'),height: 150,width: 250,
                      )),
                ),
                SizedBox(height: 30.h,),
                ///CARD SHOWING THE INTRODUCTION OF THE APP AND COUROSEL OF IMAGES
            
            Form(
                key: _formKey,
                child: Column(
              children: [
                ///TEXTFIELD FOR BUYER PHONE NUMBER
                Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: TextFormField(
                        keyboardType: TextInputType.numberWithOptions(decimal: true, signed: true),
                        maxLength: 10,
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Please enter phone number';
                          }
                          double? phoneNumber = double.tryParse(value);
                          if (phoneNumber == null) {
                            return 'Please enter a valid number';
                          }
                          if (phoneNumber < 0 ) {
                            return 'Phone number must be positive';
                          }
                          //if phone number is not up to 10 digits
                          if (value.length < 10) {
                            return 'Phone number must be 10 digits';
                          }
                          return null;
                        },
                        style: TextStyle(color: Colors.black),
                        controller: PhoneNumberController,
                        decoration: InputDecoration(
                          filled: true,
                          fillColor: Colors.deepOrange.shade50,
                          hintStyle: TextStyle(color: Colors.black),
                          //label: Text('Restaurant Name'),
                          labelStyle: TextStyle(color: Colors.black),
                          labelText: 'Receiver Phone Number',
                          hintText: ' Tellephone Number',

                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10),
                            borderSide: BorderSide(
                                color: Colors.deepOrangeAccent


                            ),),))),
                SizedBox(height: 10.h,),
                ///TEXTFIELD FOR LATITUDE
                Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: TextFormField(
                        keyboardType: TextInputType.numberWithOptions(decimal: true, signed: true),
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Please enter longitude';
                          }
                          double? longitude = double.tryParse(value);
                          if (longitude == null) {
                            return 'Please enter a valid number';
                          }
                          if (longitude < -180 || longitude > 180) {
                            return 'Longitude must be between -180 and 180';
                          }
                          return null;
                        },
                        style: TextStyle(color: Colors.black),
                        controller: LatitudeController,
                        decoration: InputDecoration(
                          filled: true,
                          fillColor: Colors.deepOrange.shade50,
                          hintStyle: TextStyle(color: Colors.black),
                          //label: Text('Restaurant Name'),
                          labelStyle: TextStyle(color: Colors.black),
                          labelText: 'latitude',
                          hintText: ' Latitude',

                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10),
                            borderSide: BorderSide(
                                color: Colors.deepOrangeAccent


                            ),),))),
                SizedBox(height: 20.h,),

                ///TEXTFIELD FOR LONGITUDE
                Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: TextFormField(
                        keyboardType: TextInputType.numberWithOptions(decimal: true, signed: true),
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Please enter longitude';
                          }
                          double? longitude = double.tryParse(value);
                          if (longitude == null) {
                            return 'Please enter a valid number';
                          }
                          if (longitude < -180 || longitude > 180) {
                            return 'Longitude must be between -180 and 180';
                          }
                          return null;
                        },
                        style: TextStyle(color: Colors.black),
                        controller: LongitudeController,
                        decoration: InputDecoration(
                            filled: true,
                            fillColor: Colors.deepOrange.shade50,
                            hintStyle: TextStyle(color: Colors.black),
                            //label: Text('Restaurant Name'),
                            labelStyle: TextStyle(color: Colors.black),
                            labelText: 'Longitude',
                            hintText: ' Longitude',

                            border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(10),
                                borderSide: BorderSide(
                                    color: Colors.deepOrangeAccent)
                            ))
                    )
                ),
                SizedBox(height: 30.h,),

                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    elevation: 3,
                    backgroundColor: Colors.deepOrangeAccent,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                  onPressed: () {
                    if (_formKey.currentState!.validate()) {
                      Navigator.push(context,
                          MaterialPageRoute(builder: (context)=>
                              TrackBuyer(
                                  phoneNumber: int.parse(PhoneNumberController.text.toString()),
                                  Latitude: double.parse(LatitudeController.text.toString()),
                                  Longitude: double.parse(LongitudeController.text.toString())))
                      );

                    }
                  },
                  child: Text('Track Route ',style: TextStyle(fontSize: 15.sp,fontWeight: FontWeight.bold,color: Colors.white),),

                ),
                SizedBox(height: 50.h,),

              ],
            )),





              ],
            ),
          ),
        ),
      ),
    );
  }
}
