import 'package:card_loading/card_loading.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';

import '../OtherDetails/ID.dart';

Container changeIdWidget() {
  TextEditingController changeIdController = TextEditingController();
  return Container(
    color: Colors.white,
    height: 990,
    child: Center(
      child: Padding(
        padding: const EdgeInsets.all(28.0),
        child: Column(
          children: [
            CardLoading(
              borderRadius: BorderRadius.circular(10),
              height: 80,
              child: Image(
                image: AssetImage("assets/images/logo.png"),
                height: 50.h,
                width: 100.w,
              ),
            ),
            SizedBox(
              height: 20.h,
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
              height: 20.h,
            ),
            TextField(
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
                  label: Text('Enter ID '),
                  labelStyle: TextStyle(
                    color: Colors.black,
                  )),
            ),
            SizedBox(height: 20.h,),
            Consumer<AdminId>(builder: (context, value, child) {
              return ElevatedButton(
                  style: ElevatedButton.styleFrom(

                      backgroundColor: Colors.deepOrangeAccent
                  ),
                  onPressed: (){
                int newId = int.parse(changeIdController.text);
                print(newId);
                value.changeId(newId);
                value.loadId();
                Navigator.pop(context);
              }, child: Text('Change', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15.sp, color: Colors.white)));
            }),
            SizedBox(
              height: 290,
            )
          ],
        ),
      ),
    ),
  );
}
