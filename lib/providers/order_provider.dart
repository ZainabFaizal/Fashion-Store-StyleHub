import 'package:flutter/material.dart';

import '../models/cart_item_model.dart';
import '../models/order_model.dart';
import '../services/firestore_service.dart';

class OrderProvider extends ChangeNotifier {
  final FirestoreService _firestoreService = FirestoreService();

  final List<Order> _orders = [];
  bool _isLoading = false;

  List<Order> get orders => _orders;
  bool get isLoading => _isLoading;

  // ── PLACE ORDER ─────────────────────────────────────────
  Future<String> placeOrder({
    required String userId, // kept for API consistency
    required List<CartItem> items,
    required double total,
    required Map<String, String> delivery,
    required String paymentMethod,
  }) async {
    _isLoading = true;
    notifyListeners();

    try {
      final orderId = await _firestoreService.placeOrder(
        userId: userId,
        items: items,
        totalAmount: total,
        deliveryAddress: delivery,
        paymentMethod: paymentMethod,
      );

      // ✅ Order model does NOT accept userId
      final order = Order(
        orderId: orderId,
        items: items,
        totalAmount: total,
        deliveryAddress: delivery,
        paymentMethod: paymentMethod,
        status: 'Processing',
        createdAt: DateTime.now(),
      );

      _orders.insert(0, order);
      _isLoading = false;
      notifyListeners();

      return orderId;
    } catch (e) {
      _isLoading = false;
      notifyListeners();
      rethrow;
    }
  }

  // ── LOAD ORDERS ─────────────────────────────────────────
  Future<void> loadOrders(String userId) async {
    _isLoading = true;
    notifyListeners();

    try {
      final fetched = await _firestoreService.fetchOrders(userId);
      _orders
        ..clear()
        ..addAll(fetched);
    } catch (_) {
      // fallback to local cache
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Order? getOrderById(String orderId) {
    try {
      return _orders.firstWhere((o) => o.orderId == orderId);
    } catch (_) {
      return null;
    }
  }

  void updateOrderStatus(String orderId, String newStatus) {
    final index = _orders.indexWhere((o) => o.orderId == orderId);
    if (index >= 0) {
      _orders[index] = _orders[index].copyWith(status: newStatus);
      notifyListeners();
    }
  }
}
