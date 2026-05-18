import 'package:flutter/material.dart';
import '../models/cart_item_model.dart';
import '../models/product_model.dart';
import '../services/firestore_service.dart';

class CartProvider extends ChangeNotifier {
  final FirestoreService _firestoreService = FirestoreService();
  final List<CartItem> _items = [];
  String? _userId;

  List<CartItem> get items => _items;

  int get itemCount => _items.fold(0, (sum, item) => sum + item.quantity);

  double get subtotal => _items.fold(0.0, (sum, item) => sum + item.total);

  double get shippingCost => subtotal >= 100 ? 0.0 : 9.99;

  double get total => subtotal + shippingCost;

  bool isInCart(String productId, String size) {
    return _items.any(
      (item) => item.productId == productId && item.size == size,
    );
  }

  Future<void> setUser(String? userId) async {
    _userId = userId;
    if (userId != null) {
      await _loadCart(userId);
    } else {
      _items.clear();
      notifyListeners();
    }
  }

  Future<void> _loadCart(String userId) async {
    try {
      final cartItems = await _firestoreService.fetchCart(userId);
      _items.clear();
      _items.addAll(cartItems);
      notifyListeners();
    } catch (_) {}
  }

  void addItem(Product product, String size) {
    final existingIndex = _items.indexWhere(
      (item) => item.productId == product.id && item.size == size,
    );

    if (existingIndex >= 0) {
      updateQuantity('${product.id}-$size', _items[existingIndex].quantity + 1);
    } else {
      final item = CartItem(
        productId: product.id,
        name: product.name,
        price: product.price,
        size: size,
        quantity: 1,
        imageUrl: product.imageUrl,
        category: product.category,
      );
      _items.add(item);
      if (_userId != null) {
        _firestoreService.saveCartItem(_userId!, item);
      }
      notifyListeners();
    }
  }

  void removeItem(String cartKey) {
    _items.removeWhere((item) => item.cartKey == cartKey);
    if (_userId != null) {
      _firestoreService.removeCartItem(_userId!, cartKey);
    }
    notifyListeners();
  }

  void updateQuantity(String cartKey, int quantity) {
    final index = _items.indexWhere((item) => item.cartKey == cartKey);
    if (index >= 0) {
      if (quantity <= 0) {
        removeItem(cartKey);
        return;
      }
      _items[index] = _items[index].copyWith(quantity: quantity);
      if (_userId != null) {
        _firestoreService.saveCartItem(_userId!, _items[index]);
      }
      notifyListeners();
    }
  }

  void clearCart() {
    _items.clear();
    if (_userId != null) {
      _firestoreService.clearCart(_userId!);
    }
    notifyListeners();
  }

  CartItem? getItem(String cartKey) {
    try {
      return _items.firstWhere((item) => item.cartKey == cartKey);
    } catch (_) {
      return null;
    }
  }
}
