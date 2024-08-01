import 'package:flutter/material.dart';
import 'package:mealmate/components/mainCards/mealPayCard.dart';

class OrderList extends StatefulWidget {
  const OrderList({super.key});

  @override
  State<OrderList> createState() => _OrderListState();
}

class _OrderListState extends State<OrderList> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        automaticallyImplyLeading: false,
        centerTitle: true,
        title: const Text('Order List'),
        titleTextStyle: const TextStyle(
          color: Colors.deepOrangeAccent,
          fontWeight: FontWeight.bold,
          letterSpacing: 3,
          fontSize: 17,
        ),
        backgroundColor: Colors.white,
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          //A user profile page with a profile picture, name, and email address, logout button, and a list of orders.
          children: [
            SizedBox(
              height: 10,
            ),
            MatePayCard(
                'Premium Card', 'XXXX-XXXX-XXXX-0123', " SEKEY PRINCE", "768"),
            SizedBox(height: 40),
            Container(
              child: Column(
                children: [
                  Text(
                    'Order List',
                    style: TextStyle(
                      color: Colors.black,
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  Icon(Icons.book_outlined, size: 120, color: Colors.black),
                  Text(
                    'You have no orders yet',
                    style: TextStyle(
                      color: Colors.black,
                      fontSize: 15,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            )
            /* Expanded(
              child: ListView.builder(
                itemCount: 9,
                itemBuilder: (context, index) {
                  return Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: ListTile(
                      tileColor: Colors.grey,
                      title: const Text(
                        'Wakye and Chicken',
                        style: TextStyle(
                          color: Colors.black,
                          fontSize: 15,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      subtitle: const Text(
                        'GHC 200.00',
                        style: TextStyle(
                          color: Colors.black,
                          fontSize: 15,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      leading: const Icon(
                        Icons.fastfood,
                        color: Colors.black,
                      ),
                      trailing: const Icon(
                        Icons.arrow_forward_ios,
                        color: Colors.black,
                      ),
                    ),
                  );
                },
              ),
            )*/
          ],
        ),
      ),
    );
  }
}
