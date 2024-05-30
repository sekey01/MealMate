import 'package:flutter/material.dart';
import 'package:mealmate/AdminPanel/components/adminHorizontalCard.dart';

class Uploaded extends StatefulWidget {
  const Uploaded({super.key});

  @override
  State<Uploaded> createState() => _UploadedState();
}

class _UploadedState extends State<Uploaded> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.deepOrangeAccent,

        /// automaticallyImplyLeading: false,
        centerTitle: true,
        title: Text(
          'My Uploads',
          style: TextStyle(letterSpacing: 3, fontWeight: FontWeight.bold),
        ),
        titleTextStyle: TextStyle(
          letterSpacing: 3,
          color: Colors.white,
          fontSize: 20,
        ),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: SafeArea(
            child: Column(
              children: [
                adminHorizontalCard(
                    'assets/images/food2.webp',
                    'Ella\'s Spaghetti Restaurant ',
                    'Kpetoe - Agorkpodzi',
                    'Jollof Rice and Chicken',
                    25,
                    1122334466,
                    '20 mins'),
                adminHorizontalCard(
                    'assets/images/food3.webp',
                    'Elikem\'s  Restaurant ',
                    'Kpetoe - Barrier',
                    'Fufu with LightSoup',
                    25,
                    1122334466,
                    '20 mins')
              ],
            ),
          ),
        ),
      ),
    );
  }
}
