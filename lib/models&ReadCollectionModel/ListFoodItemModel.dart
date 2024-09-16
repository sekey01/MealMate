class FoodItem {
  final String imageUrl;
  final String restaurant;
  final String foodName;
  final double price;
  final String location;
  final int vendorId;
  final String time;
  final bool isAvailable;
  final double latitude;
  final double longitude;
  final String adminEmail;

  FoodItem( {
    required this.vendorId,
    required this.restaurant,
    required this.foodName,
    required this.price,
    required this.location,
    required this.time,
    required this.imageUrl,
    this.isAvailable = true,
    required this.latitude,
    required this.longitude,
    required this.adminEmail,
  });

  factory FoodItem.fromMap(Map<String, dynamic> data, String documentId) {
    return FoodItem(
      imageUrl: data['imageUrl'] ?? '',
      time: data['time'] ?? '',
      restaurant: data['restaurant'] ?? '',
      foodName: data['foodName'] ?? '',
      price: data['price'] ?? 0,
      location: data['location'] ?? '',
      vendorId: data['vendorId'],
      isAvailable: data['isActive'] ?? true,
      latitude: data['latitude'] ?? 0,
      longitude: data['longitude']??0,
      adminEmail: data['adminEmail']?? '',
    );
  }
}
