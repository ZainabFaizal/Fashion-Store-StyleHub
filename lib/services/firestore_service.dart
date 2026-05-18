import 'package:cloud_firestore/cloud_firestore.dart' hide Order;
import '../models/cart_item_model.dart';
import '../models/order_model.dart';
import '../models/product_model.dart';
import '../data/products_data.dart';

class FirestoreService {
  final FirebaseFirestore _db = FirebaseFirestore.instance;

  // ---- PRODUCTS ----
  Future<List<Product>> fetchProducts() async {
    try {
      final snapshot = await _db.collection('products').get();
      if (snapshot.docs.isEmpty) {
        await _seedProducts();
        return productsData;
      }
      return snapshot.docs
          .map((doc) => Product.fromMap(doc.data()))
          .toList();
    } catch (_) {
      return productsData;
    }
  }

  Future<void> _seedProducts() async {
    final batch = _db.batch();
    for (final product in productsData) {
      final ref = _db.collection('products').doc(product.id);
      batch.set(ref, product.toMap());
    }
    await batch.commit();
  }

  // ---- CART ----
  Future<List<CartItem>> fetchCart(String userId) async {
    try {
      final snapshot = await _db
          .collection('carts')
          .doc(userId)
          .collection('items')
          .get();
      return snapshot.docs
          .map((doc) => CartItem.fromMap(doc.data()))
          .toList();
    } catch (_) {
      return [];
    }
  }

  Future<void> saveCartItem(String userId, CartItem item) async {
    await _db
        .collection('carts')
        .doc(userId)
        .collection('items')
        .doc(item.cartKey)
        .set(item.toMap());
  }

  Future<void> removeCartItem(String userId, String cartKey) async {
    await _db
        .collection('carts')
        .doc(userId)
        .collection('items')
        .doc(cartKey)
        .delete();
  }

  Future<void> clearCart(String userId) async {
    final snapshot = await _db
        .collection('carts')
        .doc(userId)
        .collection('items')
        .get();
    final batch = _db.batch();
    for (final doc in snapshot.docs) {
      batch.delete(doc.reference);
    }
    await batch.commit();
  }

  // ---- ORDERS ----
  Future<String> placeOrder({
    required String userId,
    required List<CartItem> items,
    required double totalAmount,
    required Map<String, String> deliveryAddress,
    required String paymentMethod,
  }) async {
    final orderId = 'ORD-${DateTime.now().millisecondsSinceEpoch}';
    await _db.collection('orders').doc(orderId).set({
      'orderId': orderId,
      'userId': userId,
      'items': items.map((e) => e.toMap()).toList(),
      'totalAmount': totalAmount,
      'deliveryAddress': deliveryAddress,
      'paymentMethod': paymentMethod,
      'status': 'Processing',
      'createdAt': FieldValue.serverTimestamp(),
    });
    return orderId;
  }

  Future<List<Order>> fetchOrders(String userId) async {
    try {
      final snapshot = await _db
          .collection('orders')
          .where('userId', isEqualTo: userId)
          .get();

      final orders = snapshot.docs.map((doc) {
        final data = Map<String, dynamic>.from(doc.data());
        final ts = data['createdAt'];
        data['createdAt'] = ts is Timestamp
            ? ts.toDate().toIso8601String()
            : DateTime.now().toIso8601String();
        return Order.fromMap(data);
      }).toList();

      orders.sort((a, b) => b.createdAt.compareTo(a.createdAt));
      return orders;
    } catch (_) {
      return [];
    }
  }
}
