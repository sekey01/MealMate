import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:mealmate/Local_Storage/Locall_Storage_Provider/StoreCredentials.dart';
import 'package:mealmate/Local_Storage/Locall_Storage_Provider/storeOrderModel.dart';
import 'package:mealmate/components/NoFoodFound.dart';
import 'package:mealmate/components/mainCards/mealPayCard.dart';
import 'package:provider/provider.dart';

class OrderList extends StatefulWidget {
  const OrderList({super.key});

  @override
  State<OrderList> createState() => _OrderListState();
}

class _OrderListState extends State<OrderList> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      appBar: AppBar(
        automaticallyImplyLeading: false,
        centerTitle: true,
        title: const Text('Order List'),
        titleTextStyle: const TextStyle(
            color: Colors.blueGrey,
            fontSize: 20,
            fontWeight: FontWeight.bold,
            letterSpacing: 3
        ),
        backgroundColor: Colors.white,
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          //A user profile page with a profile picture, name, and email address, logout button, and a list of orders.
          children: [
            SizedBox(
              height: 10.h,
            ),
            MatePayCard(
                'Coming Soon', 'XXX - 0123', Provider.of<LocalStorageProvider>(context, listen: true).userName,Provider.of<LocalStorageProvider>(context, listen: true).phoneNumber.toString()),
            SizedBox(height: 40),


///ROW FOR 'ORDER HISTORY' AND 'DELETE ALL' BUTTON
            ///
            ///
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                RichText(text: TextSpan(
                    children: [
                      TextSpan(text: " Order ", style: TextStyle(color: Colors.black, fontSize: 20.spMin,)),
                      TextSpan(text: " History", style: TextStyle(color: Colors.deepOrangeAccent, fontSize: 20.spMin,)),


                    ]
                )),


                TextButton(onPressed: (){
                  setState(() {
                    Provider.of<LocalStorageProvider>(context,listen: false).deleteAllOrders();

                  });
                }, child: Text('Delete all', style: TextStyle(fontSize: 15.sp),))
              ],
            ),


             ///BELLOW IS THE LIST OF ORDERS
            ///
            ///
             Expanded(
              child: FutureBuilder<List<StoreOrderLocally>>(
                  future:  Provider.of<LocalStorageProvider>(context, listen: true).loadOrders(),

                  builder: (context, snapshot) {
                if(snapshot.hasData && snapshot.data!.isNotEmpty){
                  return ListView.builder(
                      itemCount: snapshot.data!.length,
                      itemBuilder: (context,index) {
                        final storedOder = snapshot.data![index];
                        final storedOrderNUmber = index+1;
return  Center(
  child: Padding(
    padding: const EdgeInsets.all(8.0),
    child: ExpansionTile(
      //showTrailingIcon: true,
      iconColor: Colors.black,
      collapsedBackgroundColor: Colors.grey.shade200,
      leading: Text('Order : '+ '$storedOrderNUmber', style: TextStyle(color: Colors.black, fontSize: 15.spMin,)),
      title:RichText(text: TextSpan(
        children: [
          TextSpan(text: "Meal", style: TextStyle(color: Colors.black, fontSize: 15.spMin, fontWeight: FontWeight.bold)),
          TextSpan(text: "Mate", style: TextStyle(color: Colors.deepOrangeAccent, fontSize: 15.spMin, fontWeight: FontWeight.bold)),


        ]
    )),
      children: [
        Text(storedOder.item, style: TextStyle(color: Colors.black, fontSize: 15.spMin,)),
        Text(storedOder.id, style: TextStyle(color: Colors.black, fontSize: 15.spMin,)),
        Text('GHC '+'${storedOder.price.toString()}''0', style: TextStyle(color: Colors.black, fontSize: 15.spMin,)),
        Text(storedOder.time.toString(), style: TextStyle(color: Colors.black, fontSize: 15.spMin,))




      ],
    ),
  ),
);

                      });
                }

                else{
                  return Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: noFoodFound(),
                  );
                }

                  })
            )
          ],
        ),
      ),
    );
  }
}
