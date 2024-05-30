import 'package:fluid_bottom_nav_bar/fluid_bottom_nav_bar.dart';
import 'package:flutter/material.dart';
import 'package:mealmate/pages/navpages/order.dart';
import 'package:mealmate/pages/navpages/search.dart';

import 'cart.dart';
import 'index.dart';

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  final List<Widget> _pages = [
    Index(),
    Search(),
    Cart(),
    OrderList(),
  ];
  int _currentIndex = 0;

  final TextEditingController textController = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.grey.shade200,
        body: _pages[_currentIndex],
        bottomNavigationBar: FluidNavBar(
          icons: [
            FluidNavBarIcon(icon: Icons.home, extras: {"label": "Home"}),
            FluidNavBarIcon(icon: Icons.search, extras: {"label": "Search"}),
            FluidNavBarIcon(
                icon: Icons.shopping_cart, extras: {"label": "Cart"}),
            FluidNavBarIcon(
                icon: Icons.list_alt, extras: {"label": "OrderList"}),
          ],
          onChange: (index) {
            setState(() {
              _currentIndex = index;
            });
          },
          style: FluidNavBarStyle(
              barBackgroundColor: Colors.white,
              iconBackgroundColor: Colors.deepOrangeAccent,
              iconSelectedForegroundColor: Colors.white,
              iconUnselectedForegroundColor: Colors.white),
        ));
  }
}
