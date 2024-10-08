import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:mealmate/pages/detail&checkout/track_Order.dart';

class OrderSent extends StatefulWidget {
  final int vendorId;
  final DateTime time;
  final String restaurant;
  final adminEmail;
  final adminContact;
  const OrderSent({super.key, required this.vendorId, required this.time, required this.restaurant, required this.adminEmail, required this.adminContact} );

  @override
  State<OrderSent> createState() => _OrderSentState();
}

class _OrderSentState extends State<OrderSent> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.all(18.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [

                Padding(padding: EdgeInsets.all(18),
                child: Image(image: AssetImage('assets/images/logo.png'), height: 150,width: 150,),),
                Padding(
                  padding: EdgeInsets.all(0),
                  child: Text(
                    'Order Sent ',
                    style: TextStyle(
                        fontSize: 25,
                        color: Colors.black,
                        fontWeight: FontWeight.bold),
                  ),
                ),
                SizedBox(height: 30,),
                Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: ClipRRect(
                      borderRadius: BorderRadius.circular(10),
                      child: Image(
                          image: AssetImage('assets/images/delivery.jpg'), height: 100,)),
                ),

                SizedBox(
                  height: 30,
                ),
                Padding(
                  padding: EdgeInsets.all(10),
                  child: Text(
                    " Your Order will Arrive Soon..",
                    style: TextStyle(
                        color: Colors.green,
                        fontWeight: FontWeight.bold,
                        fontSize: 15.sp),
                  ),
                ),
                SizedBox(
                  height: 30,
                ),

                Text('Please don\'t leave the order tracking page Until order is received ...', style: TextStyle(fontSize: 15.sp,color: Colors.blueGrey),),
                SizedBox(
                  height: 30,
                ),
                Material(
                  borderRadius: BorderRadius.circular(20),
                  color: Colors.deepOrange,
                  elevation: 3,
                  child: TextButton(
                      onPressed: () {
                        Navigator.push(context, MaterialPageRoute(builder: (context)=> TrackOrder(vendorId: widget.vendorId,time: widget.time, restaurant: widget.restaurant,adminEmail: widget.adminEmail,adminContact: widget.adminContact,)));
                      },
                      child: Text(
                        'Track Order Now',
                        style: TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                            fontSize: 15.spMin),
                      )),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
