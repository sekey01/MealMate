 import 'package:card_loading/card_loading.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:rflutter_alert/rflutter_alert.dart';

Future<bool?>  Inform(BuildContext context){
  return  Alert(
    context: context,
    style: AlertStyle(
      backgroundColor: Colors.transparent,
      alertPadding: EdgeInsets.all(88),
      isButtonVisible: true,
      descStyle: TextStyle(
        color: Colors.green,
        fontSize: 15,
      ),
    ),
    desc: "Food added to Cart",
    buttons: [
      DialogButton(
        child: CardLoading(
          height: 25,
          child: Text(
            '  Okay  ',
            style: TextStyle(color: Colors.deepOrange),
          ),
        ),
        onPressed: () => Navigator.pop(context),
        width: 100,
      ),
    ],
  ).show();
 }






 Future<bool?>  InformAdmin(BuildContext context){
   return  Alert(
     context: context,
     style: AlertStyle(
       backgroundColor: Colors.white,
       alertPadding: EdgeInsets.all(88),
       isButtonVisible: true,
       descStyle: TextStyle(
         color: Colors.green,
         fontSize: 15,
       ),
     ),
     desc: "Welcome to Admin Panel",
     buttons: [
       DialogButton(
         child: CardLoading(
           height: 25,
           child: Text(
             '  Okay  ',
             style: TextStyle(color: Colors.deepOrange),
           ),
         ),
         onPressed: () {

           Navigator.pop(context);
         },
         width: 100,
       ),
     ],
   ).show();
 }