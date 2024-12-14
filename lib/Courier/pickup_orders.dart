import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class PickupOrders extends StatefulWidget {
  const PickupOrders({super.key});

  @override
  State<PickupOrders> createState() => _PickupOrdersState();
}

class _PickupOrdersState extends State<PickupOrders> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Pickup Orders'),
      ),
      body: Center(
        child: Text('Pickup Orders'),
      ),
    );
  }
}
