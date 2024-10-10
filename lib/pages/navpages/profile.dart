import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:mealmate/components/Notify.dart';
import 'package:mealmate/pages/navpages/edit_profile.dart';
import 'package:provider/provider.dart';

import '../../Local_Storage/Locall_Storage_Provider/StoreCredentials.dart';
import '../authpages/login.dart';

class Profile extends StatefulWidget {
  Profile({super.key});

  @override

  State<Profile> createState() => _ProfileState();
}

class _ProfileState extends State<Profile> {

  @override
  void initState() {
    super.initState();
   /* ///I CALLED THE getUsername() and getNumber() METHODS HERE SO THAT ALL THE NAME S WILL BE CALLED AND DISPLAYED IN THE PROFILE
    ///PAGE PAGE TO PREVENT ANY FORM OF DELAY
    ///I WRAPPED IT IN A "WidgetsBinding.instance.addPostFrameCallback()" in other for the function to be called when the the UI o the tree that contains the function is rendered since this is just
    ///the initial phase of the TREE /APP and it needs to access the function from the inside
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final localStorageProvider = Provider.of<LocalStorageProvider>(context, listen: false);
      localStorageProvider.getUsername();
      localStorageProvider.getPhoneNumber();
    });*/
   /* final localStorageProvider = Provider.of<LocalStorageProvider>(context, listen: false);
    localStorageProvider.getUsername();
    localStorageProvider.getPhoneNumber();*/
  }
  Widget build(BuildContext context) {
    Provider.of<LocalStorageProvider>(context, listen: false).getPhoneNumber();
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


                  /// IMAGE DISPLAYED HERE
                  ///
                  ///
                  ///

                  FutureBuilder(
                      future: Provider.of<LocalStorageProvider>(context, listen: false).getImageUrl() ,
                      builder: (context, snapshot){
                        if(snapshot.hasData){
                          return Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: CircleAvatar(radius: 50.r,
                              backgroundColor: Colors.deepOrangeAccent,
                              child: ClipRRect(child: Image(image: NetworkImage(snapshot.data.toString()), fit: BoxFit.fill,), borderRadius: BorderRadius.circular(60.r),),
                            ),
                          );
                        }else{
                          return   Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: CircleAvatar(radius: 60.r,
                        backgroundColor: Colors.deepOrangeAccent,
                        child: ImageIcon(
                          color: Colors.white,
                          size: 100.sp,
                          AssetImage('assets/Icon/yummy.png')
                        ),
                      ),
                    );
                        }
                      }),



                  SizedBox(
                    height: 10.h,
                  ),

                  ///EMAIL DISPLAYED HERE
                  ///
                  ///
                  ///
                  FutureBuilder(
                      future: Provider.of<LocalStorageProvider>(context, listen: false).getEmail() ,
                      builder: (context, snapshot){
                        if(snapshot.hasData){
                          return Text(snapshot.data.toString(),  style: TextStyle(
                            letterSpacing: 1,
                            color: Colors.black,
                            fontSize: 15.sp,
                            fontWeight: FontWeight.bold
                          ),
                          );
                        }else{
                          return Text('useremail@gmail.com',  style: TextStyle(
                            letterSpacing: 1,
                            color: Colors.black,
                            fontSize: 15.sp,
                            fontWeight: FontWeight.bold,
                          ),);
                        }
                      }),


                  /// USER NAME DISPLAYED HERE
                  ///
                  ///
                  ///
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
                                fontFamily: 'Righteous',

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

                  ///  TELEPHONE NUMBER HERE
                  ///
                  ///
                  ///
                  FutureBuilder(
                      future: Provider.of<LocalStorageProvider>(context, listen: false).getPhoneNumber(),
                      builder: (context, snapshot){
                    if(snapshot.hasData){
                      return Text(snapshot.data.toString(),  style: TextStyle(
                        fontFamily: 'Righteous',

                        letterSpacing: 1,
                        color: Colors.deepOrangeAccent,
                        fontSize: 20.sp,
                      ),
                      );
                    }else{
                      return Text('+233 XX - XXX - XXXX ',  style: TextStyle(
                        fontFamily: 'Righteous',

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
             Navigator.push(context, MaterialPageRoute(builder: (context)=> EditProfile()));
             },

             ///EDIT PROFILE BUTTON HERE
             ///
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
                     fontFamily: 'Righteous',

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
                            title: Text('Buy something before logging out 😊', style: TextStyle(color: Colors.blueGrey,fontSize: 10.spMin),),
                            subtitle: TextButton(onPressed: () async{
                              final GoogleSignIn _googleSignIn = GoogleSignIn();
                              await _googleSignIn.signOut();
                              Navigator.pushAndRemoveUntil(context, MaterialPageRoute(builder: (context)=>Login()),
                              (route) => false,
                              );
                              Notify(context, 'Logout Successfully', Colors.green);

                            }, child: Text('Logout', style: TextStyle(color: Colors.red,fontWeight: FontWeight.bold,fontSize: 15.spMin),)),
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
