import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:path_provider/path_provider.dart';

class LocalStorageProvider extends ChangeNotifier {
  String phoneNumber = '';
  String userName = '';
  Future<void> storeNumber(String newValue) async {
    try {
      final directory = await getApplicationDocumentsDirectory();
      final filepath = '${directory.path}/phoneNumber.txt';
      final file = File(filepath);

      // Check if the file exists
      if (!await file.exists()) {
        await file.create(
            recursive: true); // Create the file if it doesn't exist
      }

      // Write the new value to the file
      await file.writeAsString( newValue.toString());

      // Update the telephone Number
      phoneNumber = newValue.toString();

      // Notify listeners of the change
      notifyListeners();
    } catch (e) {
      // Handle any exceptions
      print("Error Storing Number: $e");
      // You can throw the error or handle it as needed
    }
  }

  Future<void> getNumber() async {
    try {
      final directory = await getApplicationDocumentsDirectory();
      final filepath = '${directory.path}/phoneNumber.txt';
      final file = File(filepath);

      // Check if the file exists
      if (await file.exists()) {
        // Read the contents of the file
        String contents = await file.readAsString();
        phoneNumber = contents; // Parse the contents to an integer
      } else {
        phoneNumber = '+233 XX XXX XXXX '; // Default value if the file doesn't exist
      }

      // Notify listeners of the change
      notifyListeners();
    } catch (e) {
      // Handle any exceptions
      print("Error loading number: $e");
      // You can throw the error or handle it as needed
    }
  }



  Future<void> storeUsername(String newValue) async {
    try {
      final directory = await getApplicationDocumentsDirectory();
      final filepath = '${directory.path}/Username.txt';
      final file = File(filepath);

      // Check if the file exists
      if (!await file.exists()) {
        await file.create(
            recursive: true); // Create the file if it doesn't exist
      }

      // Write the new value to the file
      await file.writeAsString(newValue);

      // Update the telephone Number
      userName = newValue;

      // Notify listeners of the change
      notifyListeners();
    } catch (e) {
      // Handle any exceptions
      print("Error changing Username: $e");
      // You can throw the error or handle it as needed
    }
  }


  Future <void>getUsername() async {
    try {
      final directory = await getApplicationDocumentsDirectory();
      final filepath = '${directory.path}/Username.txt';
      final file = File(filepath);

      // Check if the file exists
      if (await file.exists()) {
        // Read the contents of the file
        String contents = await file.readAsString();
        userName = contents; // Parse the contents to an integer
      } else {
        userName = 'Username'; // Default value if the file doesn't exist
      }

      // Notify listeners of the change
      notifyListeners();
    } catch (e) {
      // Handle any exceptions
      print("Error loading Username: $e");
      // You can throw the error or handle it as needed
    }
  }

}
