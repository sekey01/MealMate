class OrderInfo {
  final int vendorId;
  final String foodName;
  final double price;
  final String phoneNumber;
  final double Latitude;
  final double Longitude;
  final int quantity;
  final String message;
  final DateTime time;
  final bool delivered;
  final bool courier;
  final bool served;


  OrderInfo({
    required this.vendorId,
    required this.foodName,
    required this.price,
    required this.phoneNumber,
    required this.Latitude,
    required this.Longitude,
    required this.quantity,
    required this.message,
    required this.time,
    required this.served,
    required this.courier,
    required this.delivered,
  });

  Map<String, dynamic> toMap() {
    return {
      'vendorId': vendorId,
      'foodName': foodName,
      'price': price,
      'phoneNumber': phoneNumber,
      'Latitude': Latitude,
      'Longitude': Longitude,
      'quantity': quantity,
      'others': message, // 'others' is a new field that was added to the OrderInfo model
      'time': time,
      'served': served,
      'courier' : courier,
      'delivered': delivered,
    };
  }

  factory OrderInfo.fromMap(Map<String, dynamic> data, String id) {
    return OrderInfo(
      vendorId: data['vendorId'],
      foodName: data['foodName'],
      price: data['price'],
      phoneNumber: data['phoneNumber'],
      Latitude: data['Latitude'],
      Longitude: data['Longitude'],
      quantity: data['quantity'],
      message: data['others'],
      time: data['time'].toDate(),
      served: data['served']?? false,
      courier: data['courier']?? false,
      delivered: data['delivered']?? false,
    );
  }
}
