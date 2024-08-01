import 'package:flutter/material.dart';

class CartFood extends ChangeNotifier {
  final String imgUrl;
  final String restaurant;
  final String foodName;
  final double price;
  final int id;

  CartFood({
    required this.imgUrl,
    required this.restaurant,
    required this.foodName,
    required this.price,
    required this.id,
  });
}

class CartModel extends ChangeNotifier {
  List<CartFood> cart = [];

  double get tPrice {
    double total = 0;
    for (int i = 0; i < cart.length; i++) {
      total += cart[i].price;
    }
    return total;
  }

  int getId(int index) {
    if (index >= 0 && index < cart.length) {
      return cart[index].id;
    } else {
      throw RangeError('Index out of bounds');
    }
  }

  void add(CartFood cartItem) {
    cart.add(cartItem);
    notifyListeners();
  }

  void remove(int id) {
    for (int i = 0; i < cart.length; i++) {
      if (cart[i].id == id) {
        cart.removeAt(i);
        notifyListeners();
        break; // Remove only the first match
      }
    }
  }

  /// THESE FUNCTIONS ARE USED TO INCREASE AND DECREASE THE QUANTITY OF FOOD ITEM IN THE DETAIL PAGE AND NOT THE CART PAGE
  ///
  ///
  ///
  int quantity = 1;
  // getter for quantity
  int get getQuantity => quantity;

  //setter for quantity
  set setQuantity(int totalQuantity) {
    quantity = totalQuantity;
    notifyListeners();
  }

  //function to increase quantity
  void incrementQuantity() {
    quantity++;
    notifyListeners();
  }

  //function to decrease quantity
  void decrementQuantity() {
    if (quantity > 1) {
      quantity--;
    }
    notifyListeners();
  }
}
