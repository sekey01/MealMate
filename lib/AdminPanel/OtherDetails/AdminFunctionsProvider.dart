import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';

import '../collectionUploadModelProvider/collectionProvider.dart';

class AdminFunctions extends ChangeNotifier {
  Future<void> deleteItem(BuildContext context, String imgUrl) async {
    final CollectionReference collectionRef = FirebaseFirestore.instance.collection(
        '${Provider.of<AdminCollectionProvider>(context, listen: false).collectionToUpload}');

    try {
      // Query the collection for documents where 'imageUrl' field matches imgUrl
      final QuerySnapshot snapshot =
          await collectionRef.where('imageUrl', isEqualTo: imgUrl).get();

      // Iterate through each document and delete it
      for (var doc in snapshot.docs) {
        await doc.reference.delete();
      }

      print('Document(s) Updated successfully');
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        elevation: 20,
        content: Center(
          child: Text(
            'Item Successfully Deleted...',
            style: TextStyle(
                color: Colors.white, fontSize: 20, fontWeight: FontWeight.bold),
          ),
        ),
        backgroundColor: Colors.red,
      ));
    } catch (e) {
      print('Error deleting document(s): $e');
    }
  }

  Future<void> Switch(BuildContext context, int id, bool isActive) async {
    final CollectionReference collectionRef = FirebaseFirestore.instance.collection(
        '${Provider.of<AdminCollectionProvider>(context, listen: false).collectionToUpload}');

    try {
      // Query the collection for documents where 'imageUrl' field matches imgUrl
      final QuerySnapshot snapshot =
          await collectionRef.where('vendorId', isEqualTo: id).get();

      // Iterate through each document and update it
      for (var doc in snapshot.docs) {
        await doc.reference.update({'isActive': isActive});
      }

      print('Document(s) Updated successfully');
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        elevation: 20,
        content: Center(
          child: Text(
            isActive ? 'You\'re Online Now ...' : 'You\'re Offline Now',
            style: TextStyle(
                color: Colors.white,
                fontSize: 20.sp,
                fontWeight: FontWeight.bold),
          ),
        ),
        backgroundColor: isActive ? Colors.green : Colors.red,
      ));
    } catch (e) {
      print('Error deleting document(s): $e');
    }
  }

  /*///BELLOW IS THE FUNCTION TO FREQUENTLY UPDATE THE ADMIN ON INCOMING ORDERS
///
  Future<List<OrderInfo>> IncomingOrders(String collection) async {
    int retryCount = 3;
    int attempt = 0;
    while (attempt < retryCount) {
      try {
        QuerySnapshot snapshot =
        await FirebaseFirestore.instance.collection(collection).get();
        return snapshot.docs.map((doc) => OrderInfo.fromMap(doc.data() as Map<String, dynamic>, doc.id))
            .toList();
      } on SocketException catch (e) {
        attempt++;
        if (attempt >= retryCount) {
          print("Internet Problem: $e");
          return [];
        }
        await Future.delayed(Duration(seconds: 2)); // wait before retrying
      } catch (e) {
        print("Error fetching food items: $e");
        return [];
      }
    }
    return [];
  }
  */
}
