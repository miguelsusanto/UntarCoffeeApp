import 'package:flutter/material.dart';
import 'cart_item.dart';

class CartProvider with ChangeNotifier {
  final List<CartItem> _cartItems = [];

  List<CartItem> get cartItems => _cartItems;

  void addToCart(CartItem item) {
    // Check if the item already exists in the cart
    int index = _cartItems.indexWhere((cartItem) => cartItem.name == item.name && cartItem.sugarLevel == item.sugarLevel && cartItem.iceLevel == item.iceLevel);

    if (index != -1) {
      // If it exists, update the quantity
      _cartItems[index] = _cartItems[index].copyWith(quantity: _cartItems[index].quantity + item.quantity);
    } else {
      // If it doesn't exist, add the new item
      _cartItems.add(item);
    }

    notifyListeners();
  }

  void removeFromCart(int index) {
    _cartItems.removeAt(index);
    notifyListeners();
  }

  // Method to clear the cart
  void clearCart() {
    _cartItems.clear(); // Clear all items from the cart
    notifyListeners();  // Notify listeners about the change
  }

  double get totalPrice {
    return _cartItems.fold(0, (total, item) => total + (item.price * item.quantity));
  }
}
