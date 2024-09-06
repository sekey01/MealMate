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
  final _phoneNumberController = TextEditingController();
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


                     Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: CircleAvatar(radius: 60,
                        backgroundColor: Colors.deepOrangeAccent,
                        child: ImageIcon(
                          color: Colors.white,
                          size: 100,
                          AssetImage('assets/Icon/yummy.png')
                        ),
                      ),
                    ),



                  Center(
                    child:  Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: FutureBuilder(
                          future: Provider.of<LocalStorageProvider>(context, listen: false).getUsername() ,
                          builder: (context, snapshot){
                            if(snapshot.hasData){
                              return Text(snapshot.data.toString(),  style: TextStyle(
                                letterSpacing: 1,
                                color: Colors.black,
                                fontSize: 25.sp,
                                fontWeight: FontWeight.bold,
                              ),);
                            }else{
                              return Text(' Username ', style: TextStyle(
                                letterSpacing: 1,
                                color: Colors.black,
                                fontSize: 25.sp,
                                fontWeight: FontWeight.bold,
                              ),);
                            }
                          }),
                    )

                  ),
                  SizedBox(
                    height: 10.h,
                  ),
                  FutureBuilder(
                      future: Provider.of<LocalStorageProvider>(context, listen: false).getNumber() ,
                      builder: (context, snapshot){
                    if(snapshot.hasData){
                      return Text(snapshot.data.toString(),  style: TextStyle(
                        letterSpacing: 1,
                        color: Colors.black,
                        fontSize: 15.sp,
                      ),
                      );
                    }else{
                      return Text('+233 XX - XXX - XXXX ',  style: TextStyle(
                        letterSpacing: 1,
                        color: Colors.black,
                        fontSize: 15.sp,
                        fontWeight: FontWeight.bold,
                      ),);
                    }
                  }),
                  SizedBox(
                    height: 20.h,
                  ),
           GestureDetector(
             onTap: (){
               showModalBottomSheet(
                 isScrollControlled: true,
                   backgroundColor: Colors.white,
                   isDismissible: true,
                   context: context,
                   builder: (BuildContext context)
               {
                 return Container(
                   height: 600.h,
                   child: SingleChildScrollView(
                     child: Column(
                       children: [
                      Padding(padding: EdgeInsets.all(8),
                        child: Image(image: AssetImage('assets/images/logo.png'), height: 150, width: 150,),
                      ),
                      Padding(padding: EdgeInsets.all(8),
                      child: TextField(
                        controller: _usernameController,
                        decoration: InputDecoration(
                            hintText: 'Change Username',
                            border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(10.sp),
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
                         Padding(padding: EdgeInsets.all(8),
                           child: TextField(
                             controller: _phoneNumberController,
                             decoration: InputDecoration(
                                 hintText: 'Change Telephone Number',
                                 border: OutlineInputBorder(
                                     borderRadius: BorderRadius.circular(10.sp),
                                     borderSide: BorderSide(color: Colors.grey)),
                                 fillColor: Colors.grey,
                                 filled: true),
                             onSubmitted: (value) {
                               setState(() {
                                 Provider.of<LocalStorageProvider>(context,
                                     listen: false)
                                     .storeNumber(_phoneNumberController.text);
                               });
                               _phoneNumberController.clear();
                             },
                           ),
                         ),
                         SizedBox(height: 80.h,)
                       ],
                     ),
                   ),
                 );
               });
             },

             ///EDIT PROFILE
             ///
             ///
             child:  Badge(
               backgroundColor: Colors.white70,
               alignment: Alignment.bottomRight,
               label: Row(
                 mainAxisAlignment: MainAxisAlignment.spaceBetween,
                 children: [
                   Icon(Icons.edit, size: 18,color: Colors.blueGrey,),
                   SizedBox(
                     width: 10.w,
                   ),                  Text('Edit profile',  style: TextStyle(
                     letterSpacing: 1,
                     color: Colors.black,
                     fontSize: 10.sp,
                   ),),
                 ],
               ),),
           ),


                  ClipRRect(
                      child: Image(
                    image: AssetImage('assets/images/notFound.jpg'),
                    width: 130,
                    height: 150,
                  )),
                  Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      ExpansionTile(
                        title: Text('Promo Codes ', style: TextStyle(color: Colors.black,fontWeight: FontWeight.bold, letterSpacing:  1,),),
                        //leading: ImageIcon(AssetImage('assets/Icon/coupon.png'),
                        //  size: 30,color: Colors.deepOrangeAccent,),
                        children: [
                          ListTile(
                            title: Text('No promo available', style: TextStyle(color: Colors.blueGrey,fontSize: 15.spMax),),
                          )
                        ],
                      ),
                      ExpansionTile(
                        title: Text('Transactions ', style: TextStyle(color: Colors.black,fontWeight: FontWeight.bold, letterSpacing: 1,),),
                       // leading: ImageIcon(AssetImage('assets/Icon/transaction.png'),
                         // size: 30,color: Colors.deepOrangeAccent,),
                        children: [
                          ListTile(
                            title: Text('No recorded Transactions', style: TextStyle(color: Colors.blueGrey,fontSize: 15.spMax),),
                          )
                        ],
                      ),
                      ExpansionTile(
                        title: Text('Logout ', style: TextStyle(color: Colors.black,fontWeight: FontWeight.bold, letterSpacing: 1),),
                        //leading:Icon(Icons.login_outlined, color: Colors.deepOrangeAccent, size: 30,),
                        children: [
                          ListTile(
                            title: Text('Buy something before logging out 😊', style: TextStyle(color: Colors.blueGrey,fontSize: 15.spMax),),
                          )
                        ],
                      ),
                      ExpansionTile(
                        title: Text('Version ', style: TextStyle(color: Colors.blueGrey, letterSpacing: 1),),
                        //leading: ImageIcon(AssetImage('assets/Icon/version.png'),
                         // size: 30,color: Colors.deepOrangeAccent,),
                        children: [
                          ListTile(
                            title: Text('Version 1.0.0', style: TextStyle(color: Colors.black,fontSize: 10.spMax),),
                          )
                        ],
                      )
                    ],

                  )
                ],
              ),
            ),
          ),
        ),
       );
  }
}
