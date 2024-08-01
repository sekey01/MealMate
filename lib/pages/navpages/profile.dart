import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';

import '../../Local_Storage/Locall_Storage_Provider/StoreCredentials.dart';

class Profile extends StatefulWidget {
  Profile({super.key});

  @override
  State<Profile> createState() => _ProfileState();
}

class _ProfileState extends State<Profile> {
  final _usernameController = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.white,
        body: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: SingleChildScrollView(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                //crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(
                    height: 50.h,
                  ),
                  Center(
                    child: Text(
                      Provider.of<LocalStorageProvider>(context, listen: false)
                          .userName
                          .toString(),
                      style: TextStyle(
                        letterSpacing: 1,
                        color: Colors.black,
                        fontSize: 25,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  SizedBox(
                    height: 10.h,
                  ),
                  Text(
                    Provider.of<LocalStorageProvider>(context, listen: false)
                        .phoneNumber,
                    style: TextStyle(
                      color: Colors.black,
                      fontSize: 15.sp,
                      fontWeight: FontWeight.normal,
                    ),
                  ),
                  SizedBox(
                    height: 10.h,
                  ),
                  ClipRRect(
                      child: Image(
                    image: AssetImage('assets/images/notFound.jpg'),
                    width: 130,
                    height: 150,
                  )),
                  Column(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        Container(
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              Icon(
                                Icons.discount_outlined,
                                size: 30,
                                color: Colors.black,
                              ),
                              SizedBox(
                                width: 40,
                              ),
                              Text(
                                'Promo codes ',
                                style: TextStyle(
                                  color: Colors.black,
                                  fontSize: 20.sp,
                                  fontWeight: FontWeight.normal,
                                ),
                              ),
                            ],
                          ),
                        ),
                        SizedBox(
                          height: 30,
                        ),
                        Container(
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              Icon(
                                Icons.payment_sharp,
                                size: 30.sp,
                                color: Colors.black,
                              ),
                              SizedBox(
                                width: 40,
                              ),
                              Text(
                                'Payment ',
                                style: TextStyle(
                                  color: Colors.black,
                                  fontSize: 20.sp,
                                  fontWeight: FontWeight.normal,
                                ),
                              ),
                            ],
                          ),
                        ),
                        SizedBox(
                          height: 30.h,
                        ),
                        Container(
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              Icon(
                                Icons.error_outline_outlined,
                                size: 30.sp,
                                color: Colors.black,
                              ),
                              SizedBox(
                                width: 40.w,
                              ),
                              Text(
                                'About Us  ',
                                style: TextStyle(
                                  color: Colors.black,
                                  fontSize: 20.sp,
                                  fontWeight: FontWeight.normal,
                                ),
                              ),
                            ],
                          ),
                        ),
                        SizedBox(
                          height: 30.h,
                        ),
                        Container(
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              Icon(
                                Icons.contact_support_outlined,
                                size: 30.sp,
                                color: Colors.black,
                              ),
                              SizedBox(
                                width: 40,
                              ),
                              Text(
                                'Support',
                                style: TextStyle(
                                  color: Colors.black,
                                  fontSize: 20,
                                  fontWeight: FontWeight.normal,
                                ),
                              ),
                            ],
                          ),
                        ),
                        SizedBox(
                          height: 30.h,
                        ),
                        Container(
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              Icon(
                                Icons.logout,
                                size: 30.sp,
                                color: Colors.black,
                              ),
                              SizedBox(
                                width: 40,
                              ),
                              Text(
                                'logout',
                                style: TextStyle(
                                  color: Colors.black,
                                  fontSize: 20.sp,
                                  fontWeight: FontWeight.normal,
                                ),
                              ),
                            ],
                          ),
                        )
                      ])
                ],
              ),
            ),
          ),
        ),
        floatingActionButton: FloatingActionButton(
          onPressed: () {
            showModalBottomSheet(
                backgroundColor: Colors.white,
                isDismissible: true,
                context: context,
                builder: (BuildContext context) {
                  return Container(
                    height: 400.h,
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: TextField(
                        controller: _usernameController,
                        decoration: InputDecoration(
                            hintText: 'Change Username',
                            border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(25.sp),
                                borderSide: BorderSide(color: Colors.grey)),
                            fillColor: Colors.grey,
                            filled: true),
                        onSubmitted: (value) {
                          setState(() {
                            Provider.of<LocalStorageProvider>(context,
                                    listen: false)
                                .storeUsername(_usernameController.text);
                          });
                          _usernameController.clear();
                        },
                      ),
                    ),
                  );
                });
          },
          child: Icon(Icons.edit),
          backgroundColor: Colors.deepOrangeAccent,
        ));
  }
}
