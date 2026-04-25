import '../models/cart_item_model.dart';
import '../models/order_model.dart';
import '../models/product_model.dart';
import '../data/products_data.dart';

class FirestoreService {
  // ---- PRODUCT MOCK ----
  Future<List<Product>> fetchProducts() async {
    return productsData;
  }

  // ---- CART MOCK ----
  Future<void> saveCartItem(String userId, CartItem item) async {
    return;
  }

  Future<void> removeCartItem(String userId, String cartKey) async {
    return;
  }

  Future<void> clearCart(String userId) async {
    return;
  }

  // ---- ORDER MOCK ----
  Future<String> placeOrder({
    required String userId,
    required List<CartItem> items,
    required double totalAmount,
    required Map<String, String> deliveryAddress,
    required String paymentMethod,
  }) async {
    return DateTime.now().millisecondsSinceEpoch.toString();
  }

  Future<List<Order>> fetchOrders(String userId) async {
    return [];
  }
}
