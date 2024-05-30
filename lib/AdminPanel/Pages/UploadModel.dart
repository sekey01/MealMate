class UploadModel {
  final String imageUrl;
  final String restaurant;
  final String foodName;
  final double price;
  final String location;
  final String time;
  final int vendorId;

  UploadModel({
    required this.imageUrl,
    required this.restaurant,
    required this.foodName,
    required this.price,
    required this.vendorId,
    required this.location,
    required this.time,
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
    };
  }
}
