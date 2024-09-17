import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';


Material verticalCard(
  String imgUrl,
  String restaurant,
  String foodName,
  double price,
  String location,
  String time,
  String vendorId,
  bool isAvailable,
    String adminEmail,
    int adminContact,
) {
  return Material(
    borderRadius: BorderRadius.circular(10),
    shadowColor: Colors.black,
    color: Colors.black,
    elevation: 3,
    child: Container(
      height: 200.h,
      color: Colors.white,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          GestureDetector(
            onTap: () {},
            child: Badge(
              ///BADGE TO DISPLAY DISCOUNT ON FOOD
              alignment: Alignment.topCenter,
              backgroundColor: isAvailable ? Colors.green : Colors.red,
              label: Text(
                ///'Discount: ${((price.toInt() / 400) * 100).toInt()} %',
                isAvailable ? 'Online' : 'Not Available',
                style: TextStyle(
                    letterSpacing: 1,
                    color: Colors.white,
                    fontSize: 8.spMin,
                    fontWeight: FontWeight.bold),
              ),
              child: Container(
                color: Colors.white,
                height: 100.h,
                width: 180.h,
                margin: EdgeInsets.all(5),
                //margin: EdgeInsets.fromLTRB(0, 1, 0, 1),
                child: imgUrl.isEmpty
                    ? Center(
                        child: Icon(
                          ///NO IMAGE ICON WHEN THE IMAGE URL IS EMPTY
                          ///
                          Icons.image_not_supported_outlined,
                          color: Colors.deepOrange,
                          size: 120.spMin,
                        ),
                      )
                    : ClipRRect(
                        borderRadius: BorderRadius.circular(13),
                        child: Image(
                          fit: BoxFit.fill,
                          image: NetworkImage(imgUrl),
                          height: 90.h,
                          width: 120.w,
                        ),
                      ),
              ),
            ),
          ),
          SizedBox(
            height: 2,
          ),
          Text(
            ///NAME OF RESTAURANT
            '$restaurant',
            style: TextStyle(
                fontSize: 9.spMin,
                letterSpacing: 1,
                fontWeight: FontWeight.w600,
                color: Colors.black),
          ),
          Text(
            ///NAME OF FOOD
            '$foodName',
            style: TextStyle(
                fontSize: 10.spMin,
                letterSpacing: 2,
                //fontWeight: FontWeight.w600,
                color: Colors.black),
          ),
///PRICE OF FOD
    RichText(text: TextSpan(
        children: [
          TextSpan(text: "GHC  ", style: TextStyle(color: Colors.deepOrangeAccent, fontSize: 10.spMin, fontWeight: FontWeight.bold)),
          TextSpan(text: '$price '+'0', style: TextStyle(color: Colors.black, fontSize: 10.spMin, fontWeight: FontWeight.bold)),


        ]
    )),

          //Row for location
          Row(mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                Icons.location_on,
                color: Colors.deepOrangeAccent,
                size: 10.h,
              ),
              Text(
                ///LOCATION OF RESTAURANT
                ' $location ',
                style: TextStyle(
                    color: Colors.deepOrangeAccent,
                    fontSize: 10.spMin,
                    overflow: TextOverflow.ellipsis,
                    letterSpacing: 1),
              ),
            ],
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              ///
              Icon(
                size: 10.spMin,
                Icons.timelapse_rounded,
                color: Colors.deepOrange,
              ),
              Text('  $time  ',
                  style: TextStyle(
                      fontSize: 8.spMin,
                      color: Colors.black,
                      fontWeight: FontWeight.bold)),
              SizedBox(width: 10.h,),

              Icon(
                size: 10.spMin,
                Icons.phone_callback_rounded,
                color: Colors.deepOrange,
              ),
              Text(
                /// CONTACT OF VENDOR
                ///
                ' $adminContact',
                style: TextStyle(
                    fontSize: 10.spMin,
                    color: Colors.black,
                    fontWeight: FontWeight.bold),
              ),
            ],
          ),
        ],
      ),
    ),
  );
}
