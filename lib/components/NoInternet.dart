import 'package:flutter/material.dart';

Widget NoInternetConnection() {
  return Padding(
    padding: const EdgeInsets.all(18.0),
    child: Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.error_outline_rounded,
            size: 50,
            color: Colors.black,
          ),
          Text(
            'Check Internet Connection',
            style: TextStyle(color: Colors.red),
          )
        ],
      ),
    ),
  );
}
