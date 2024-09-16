import 'package:card_loading/card_loading.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:mealmate/Local_Storage/Locall_Storage_Provider/StoreCredentials.dart';
import 'package:mealmate/components/Notify.dart';
import 'package:provider/provider.dart';

import '../OtherDetails/ID.dart';

class ChangeAdminCredentials extends StatefulWidget {
  const ChangeAdminCredentials({super.key});

  @override
  State<ChangeAdminCredentials> createState() => _ChangeAdminCredentialsState();
}

class _ChangeAdminCredentialsState extends State<ChangeAdminCredentials> {
  TextEditingController changeIdController = TextEditingController();
  TextEditingController changeEmailController = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body:

       SingleChildScrollView(
         child: Column(
           mainAxisAlignment: MainAxisAlignment.center,
           children: [
             Center(
               child: Padding(
                 padding: const EdgeInsets.all(28.0),
                 child: Column(
                   children: [
                     SizedBox(
                       height: 30.h,
                     ),

                     CardLoading(
                       borderRadius: BorderRadius.circular(10),
                       height: 80,
                       child: Image(
                         image: AssetImage("assets/images/logo.png"),
                         height: 50.h,
                         width: 150.w,
                       ),
                     ),
                     SizedBox(
                       height: 30.h,
                     ),
                     Text(
                       "Change Admin ID ",
                       style: TextStyle(
                           color: Colors.black,
                           letterSpacing: 2,
                           fontWeight: FontWeight.bold,
                           fontSize: 15.sp),
                     ),
                     SizedBox(
                       height: 30.h,
                     ),
                     ///CHANGE ID HERE
                     TextField(
                       onSubmitted: (value){
                         Provider.of<AdminId>(context,listen: false).changeId(int.parse(value));
                         Provider.of<AdminId>(context,listen: false).loadId();
    Notify(context, 'Id changed successfully', Colors.green);
                         setState(() {});

                       },
                       controller: changeIdController,
                       keyboardType: TextInputType.number,
                       style: TextStyle(color: Colors.deepOrange),
                       decoration: InputDecoration(
                           enabledBorder: OutlineInputBorder(
                               borderRadius: BorderRadius.circular(10),
                               borderSide: BorderSide(color: Colors.red)),
                           hintStyle: TextStyle(
                               color: Colors.red, fontSize: 20.sp, letterSpacing: 2),
                           border: OutlineInputBorder(
                               borderRadius: BorderRadius.circular(10),
                               borderSide: BorderSide(
                                   color: Colors.red, style: BorderStyle.solid)),
                           label: Text('enter ID '),
                           labelStyle: TextStyle(
                             color: Colors.black,
                           )),
                     ),
                     SizedBox(height: 30.h,),
         
                     ///CHANGE EMAIL HERE
                     TextField(
                       onSubmitted: (value){
                         Provider.of<LocalStorageProvider>(context,listen: false).storeAdminEmail(value.toString());
                         Provider.of<LocalStorageProvider>(context,listen: false).getAdminEmail();
                         Notify(context, 'Email changed successfully', Colors.green);
                         setState(() {});


                       },
                       controller: changeEmailController,
                       keyboardType: TextInputType.text,
                       style: TextStyle(color: Colors.deepOrange),
                       decoration: InputDecoration(
                           enabledBorder: OutlineInputBorder(
                               borderRadius: BorderRadius.circular(10),
                               borderSide: BorderSide(color: Colors.red)),
                           hintStyle: TextStyle(
                               color: Colors.red, fontSize: 20.sp, letterSpacing: 2),
                           border: OutlineInputBorder(
                               borderRadius: BorderRadius.circular(10),
                               borderSide: BorderSide(
                                   color: Colors.red, style: BorderStyle.solid)),
                           label: Text('enter email  '),
                           labelStyle: TextStyle(
                             color: Colors.black,
                           )),
                     ),



                   ],
                 ),
               ),
             ),
           ],
         ),
       ));
    }
  }
