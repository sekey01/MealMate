import 'dart:io';

import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';

class AdminId extends ChangeNotifier {
   int adminID = 0 ;

  get id => adminID; // Use camelCase for variable names



  Future<void> changeId(int newValue) async {
    try {
      final directory = await getApplicationDocumentsDirectory();
      final filepath = '${directory.path}/AdminId.txt';
      final file = File(filepath);

      // Check if the file exists
      if (!await file.exists()) {
        await file.create(
            recursive: true); // Create the file if it doesn't exist
      }

      // Write the new value to the file
      await file.writeAsString(newValue.toString());

      // Update the adminID
      adminID = newValue.toInt();

      // Notify listeners of the change
      notifyListeners();
    } catch (e) {
      // Handle any exceptions
      print("Error changing ID: $e");
      // You can throw the error or handle it as needed
    }
  }

  Future<void> loadId() async {
    try {
      final directory = await getApplicationDocumentsDirectory();
      final filepath = '${directory.path}/AdminId.txt';
      final file = File(filepath);

      // Check if the file exists
      if (await file.exists()) {
        // Read the contents of the file
        String contents = await file.readAsString();
        adminID = int.parse(contents); // Parse the contents to an integer
      } else {
        adminID = 0; // Default value if the file doesn't exist
      }

      // Notify listeners of the change
      notifyListeners();
    } catch (e) {
      // Handle any exceptions
      print("Error loading ID: $e");
      // You can throw the error or handle it as needed
    }
  }


}
