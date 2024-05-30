import 'package:flutter/material.dart';

Material verticalCard(
  String imgUrl,
  String restaurant,
  String foodName,
  double price,
  String location,
  String time,
  String vendorId,
) {
  return Material(
    borderRadius: BorderRadius.circular(10),
    shadowColor: Colors.deepOrangeAccent,
    color: Colors.red,
    elevation: 3,
    child: Container(
      height: 200,
      color: Colors.white,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          GestureDetector(
            onTap: () {},
            child: Badge(
              ///BADGE TO DISPLAY DISCOUNT ON FOOD
              alignment: Alignment.topCenter,
              backgroundColor: Colors.red,
              label: Text(
                'Discount: ${((price.toInt() / 500) * 100).toInt()} %',
                style: TextStyle(color: Colors.white, fontSize: 5),
              ),
              child: Container(
                color: Colors.white,
                height: 100,
                width: 180,
                margin: EdgeInsets.all(5),
                //margin: EdgeInsets.fromLTRB(0, 1, 0, 1),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(14),
                  child: Image.network(
                      fit: BoxFit.fill,

                      ///IMAGE URL
                      "$imgUrl"),
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
                fontSize: 10,
                letterSpacing: 2,
                fontWeight: FontWeight.w600,
                color: Colors.black),
          ),
          Text(
            ///NAME OF FOOD
            '$foodName',
            style: TextStyle(
                fontSize: 10,
                letterSpacing: 2,
                //fontWeight: FontWeight.w600,
                color: Colors.black),
          ),

          Text(
            ///PRICE OF FOOD
            '₵ $price 0',
            style: TextStyle(
                fontSize: 12, fontWeight: FontWeight.bold, color: Colors.black),
          ),

          //Row for location
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                Icons.location_on,
                color: Colors.deepOrangeAccent,
                size: 10,
              ),
              Text(
                ///LOCATION OF RESTAURANT
                ' $location ',
                style: TextStyle(
                    color: Colors.deepOrangeAccent,
                    fontSize: 10,
                    overflow: TextOverflow.ellipsis,
                    letterSpacing: 1),
              ),
            ],
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              ///
              Icon(
                size: 13,
                Icons.timelapse_rounded,
                color: Colors.deepOrange,
              ),
              Text('  $time  ',
                  style: TextStyle(
                      fontSize: 8,
                      color: Colors.black,
                      fontWeight: FontWeight.bold)),

              Icon(
                size: 13,
                Icons.payments_outlined,
                color: Colors.deepOrange,
              ),
              Text(
                ///ID OF FOR TRANSANCTION
                ///
                ' $vendorId',
                style: TextStyle(
                    fontSize: 10,
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
