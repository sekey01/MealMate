import 'dart:convert';
import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:mealmate/Local_Storage/Locall_Storage_Provider/storeOrderModel.dart';
import 'package:path_provider/path_provider.dart';

class LocalStorageProvider extends ChangeNotifier {
  /// Just making use of this Provider to get the upgdated value for the notification page
  int notificationLength = 1;
///

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

  Future <String> getNumber() async {
    try {
      final directory = await getApplicationDocumentsDirectory();
      final filepath = '${directory.path}/phoneNumber.txt';
      final file = File(filepath);

      // Check if the file exists
      if (await file.exists()) {
        // Read the contents of the file
        String contents = await file.readAsString();
        phoneNumber = contents;// Parse the contents to an integer
        return phoneNumber.toString();
      } else {
       return  phoneNumber = '+233 XX XXX XXXX '; // Default value if the file doesn't exist
      }

      // Notify listeners of the change
      notifyListeners();
    } catch (e) {
      // Handle any exceptions
    return 'Username';
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


  Future <String>getUsername() async {
    try {
      final directory = await getApplicationDocumentsDirectory();
      final filepath = '${directory.path}/Username.txt';
      final file = File(filepath);

      // Check if the file exists
      if (await file.exists()) {
        // Read the contents of the file
        String contents = await file.readAsString();
        userName = contents; // Parse the contents to an integer

          return userName;
      } else {
      return userName = 'Username'; // Default value if the file doesn't exist
      }

      // Notify listeners of the change
      notifyListeners();
    } catch (e) {
      // Handle any exceptions
      return 'Username';
      print("Error loading Username: $e");
      // You can throw the error or handle it as needed
    }
  }




   String fileName = 'orders.json';

   Future<String> get _localPath async {
         final directory = await getApplicationDocumentsDirectory();
         return directory.path;
  }

   Future<File> get _localFile async {
         final path = await _localPath;
         return File('$path/$fileName');
  }

   Future<void> saveOrders(List<StoreOrderLocally> storeOrders) async {
         final file = await _localFile;
         if (!await file.exists()) {
           await file.create(
               recursive: true); // Create the file if it doesn't exist
         }
         final data = storeOrders.map((order) => order.toJson()).toList();
  await file.writeAsString(json.encode(data));
  }

   Future<List<StoreOrderLocally>> loadOrders() async {
  try {
        final file = await _localFile;
        final contents = await file.readAsString();
        final data = json.decode(contents) as List;
              return data.map((item) => StoreOrderLocally.fromJson(item)).toList();
     } catch (e) {
  // If encountering an error, return an empty list
  return [];
            }
  }

   Future<void> addOrder(StoreOrderLocally storeOrders) async {
            final orders = await loadOrders();
                  orders.add(storeOrders);
  await saveOrders(orders);
  }
  }


