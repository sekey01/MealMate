import 'package:flutter/material.dart';

Container noFoodFound() {
  return Container(
    child: Column(
      children: [
        SizedBox(
          height: 80,
        ),
        Icon(
          Icons.no_food_outlined,
          size: 70,
          color: Colors.red,
        ),
        SizedBox(
          height: 20,
        ),
        Text(
          'No Food Found...',
          style: TextStyle(
            fontSize: 20,
            color: Colors.red,
          ),
        ),
      ],
    ),
  );
}
