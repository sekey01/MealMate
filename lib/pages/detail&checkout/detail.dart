/*import 'package:flutter/material.dart';

class Detail extends StatefulWidget {
  const Detail({super.key, required this.label});
  final Widget label; // Now a Widget, not a String

  @override
  State<Detail> createState() => _DetailState();
}

class _DetailState extends State<Detail> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(children: [
          label
        ]),
      ),
    );
  }
}*/
import 'package:flutter/material.dart';

class Detail extends StatefulWidget {
  final Widget detail; // Now a Widget, not a String

  // Constructor with required label of type Widget
  const Detail({Key? key, required this.detail}) : super(key: key);

  @override
  State<Detail> createState() => _DetailState();
}

class _DetailState extends State<Detail> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text('MealMate'),
        titleTextStyle: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
            letterSpacing: 3,
            fontSize: 17),
        backgroundColor: Colors.deepOrange,
      ),
      backgroundColor: Colors.white,
      body: SingleChildScrollView(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Container(
              padding: EdgeInsets.all(10),
              color: Colors.white,
              child: widget
                  .detail, // Place the widget directly inside the Container
            ),
          ],
        ),
      ),
    );
  }
}
