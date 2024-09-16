import 'package:google_maps_flutter/google_maps_flutter.dart';

class UploadModel {
  final String imageUrl;
  final String restaurant;
  final String foodName;
  final double price;
  final String location;
  final String time;
  final int vendorId;
  final bool isAvailable;
  final double latitude;
  final double longitude;
  final String adminEmail;

  UploadModel({
    required this.imageUrl,
    required this.restaurant,
    required this.foodName,
    required this.price,
    required this.vendorId,
    required this.location,
    required this.time,
    required this.isAvailable,
    required this.latitude,
    required this.longitude,
    required this.adminEmail

  });

  Map<String, dynamic> toMap() {
    return {
      'imageUrl': imageUrl,
      'restaurant': restaurant,
      'foodName': foodName,
      'price': price,
      'location': location,
      'time': time,
      'vendorId': vendorId,
      'isActive': isAvailable,
      'latitude' : latitude?? 0,
      'longitude': longitude?? 0,
      'adminEmail': adminEmail ?? ''
    };
  }
}
