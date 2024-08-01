import 'package:flutter/material.dart';

Material verticalCard(
  String imgUrl,
  String restaurant,
  String foodName,
  double price,
  String location,
  String time,
  String vendorId,
  bool isAvailable,
) {
  return Material(
    borderRadius: BorderRadius.circular(10),
    shadowColor: Colors.black,
    color: Colors.black,
    elevation: 3,
    child: Container(
      height: 220,
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
                    fontSize: 8,
                    fontWeight: FontWeight.bold),
              ),
              child: Container(
                color: Colors.white,
                height: 100,
                width: 180,
                margin: EdgeInsets.all(5),
                //margin: EdgeInsets.fromLTRB(0, 1, 0, 1),
                child: imgUrl.isEmpty
                    ? Center(
                        child: Icon(
                          ///NO IMAGE ICON WHEN THE IMAGE URL IS EMPTY
                          ///
                          Icons.image_not_supported_outlined,
                          color: Colors.deepOrange,
                          size: 120,
                        ),
                      )
                    : ClipRRect(
                        borderRadius: BorderRadius.circular(13),
                        child: Image(
                          fit: BoxFit.fill,
                          image: NetworkImage(imgUrl),
                          height: 90,
                          width: 120,
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
                fontSize: 9,
                letterSpacing: 1,
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
            'GHC $price 0',
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
