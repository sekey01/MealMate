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
  void initState() {
    super.initState();
    ///I CALLED THE getUsername() and getNumber() METHODS HERE SO THAT ALL THE NAME S WILL BE CALLED AND DISPLAYED IN THE PROFILE
    ///PAGE PAGE TO PREVENT ANY FORM OF DELAY
    ///I WRAPPED IT IN A "WidgetsBinding.instance.addPostFrameCallback()" in other for the function to be called when the the UI o the tree that contains the function is rendered since this is just
    ///the initial phase of the TREE /APP and it needs to access the function from the inside
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final localStorageProvider = Provider.of<LocalStorageProvider>(context, listen: false);
      localStorageProvider.getUsername();
      localStorageProvider.getNumber();
    });
  }
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Theme.of(context).scaffoldBackgroundColor,
        appBar: AppBar(
          automaticallyImplyLeading: false,
          leading: IconButton(onPressed: (){Navigator.pop(context);}, icon: Icon(Icons.arrow_back_ios, color: Colors.black,)),
          title: Text('Account', style: TextStyle(color: Colors.blueGrey, letterSpacing: 3, fontWeight: FontWeight.bold),), centerTitle: true,
          backgroundColor: Colors.white,
          actions: [
            Padding(
              padding: EdgeInsets.fromLTRB(0, 0, 30, 0),
              child: Icon(Icons.qr_code_2_outlined, color: Colors.deepOrangeAccent,),
            )
          ],
        ),
        body: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(14.0),
            child: SingleChildScrollView(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                //crossAxisAlignment: CrossAxisAlignment.start,
                children: [

                  CircleAvatar(radius: 60,
                    backgroundColor: Colors.deepOrangeAccent,
                    child: ImageIcon(
                      color: Colors.white,
                      size: 100,
                      AssetImage('assets/Icon/yummy.png')
                    ),
                  ),
                  Center(
                    child: Text(
                      Provider.of<LocalStorageProvider>(context, listen: false)
                          .userName
                          .toString(),
                      style: TextStyle(
                        letterSpacing: 1,
                        color: Colors.black,
                        fontSize: 25.sp,
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
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        ExpansionTile(
                          title: Text('Promo Codes ', style: TextStyle(color: Colors.black,fontWeight: FontWeight.bold, letterSpacing: 3,),),
                          leading: ImageIcon(AssetImage('assets/Icon/coupon.png'),
                            size: 30,color: Colors.deepOrangeAccent,),
                          children: [
                            ListTile(
                              title: Text('No Coupon Available', style: TextStyle(color: Colors.deepOrangeAccent,),),
                            )
                          ],
                        ),
                        ExpansionTile(
                          title: Text('Transactions ', style: TextStyle(color: Colors.black,fontWeight: FontWeight.bold, letterSpacing: 3,),),
                          leading: ImageIcon(AssetImage('assets/Icon/transaction.png'),
                            size: 30,color: Colors.deepOrangeAccent,),
                          children: [
                            ListTile(
                              title: Text('No recorded Transactions', style: TextStyle(color: Colors.deepOrangeAccent,),),
                            )
                          ],
                        ),
                        ExpansionTile(
                          title: Text('Logout ', style: TextStyle(color: Colors.black,fontWeight: FontWeight.bold, letterSpacing: 3),),
                          leading:Icon(Icons.login_outlined, color: Colors.deepOrangeAccent, size: 30,),
                          children: [
                            ListTile(
                              title: Text('Are you sure ?', style: TextStyle(color: Colors.deepOrangeAccent,),),
                            )
                          ],
                        ),
                        ExpansionTile(
                          title: Text('Version ', style: TextStyle(color: Colors.blueGrey, letterSpacing: 3),),
                          leading: ImageIcon(AssetImage('assets/Icon/version.png'),
                            size: 30,color: Colors.deepOrangeAccent,),
                          children: [
                            ListTile(
                              title: Text('Version 1.0.0', style: TextStyle(color: Colors.deepOrangeAccent,),),
                            )
                          ],
                        )
                      ],

                    ),
                  )
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
          child: ImageIcon( AssetImage('assets/Icon/refresh.png'), size: 40, color: Colors.white,),
          backgroundColor: Colors.deepOrangeAccent,
        ));
  }
}
