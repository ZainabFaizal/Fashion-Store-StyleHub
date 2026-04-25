import 'cart_item_model.dart';

class Order {
  final String orderId;
  final List<CartItem> items;
  final double totalAmount;
  final Map<String, String> deliveryAddress;
  final String paymentMethod;
  final String status;
  final DateTime createdAt;

  const Order({
    required this.orderId,
    required this.items,
    required this.totalAmount,
    required this.deliveryAddress,
    required this.paymentMethod,
    required this.status,
    required this.createdAt,
  });

  int get itemCount => items.fold(0, (sum, item) => sum + item.quantity);

  factory Order.fromMap(Map<String, dynamic> map) {
    return Order(
      orderId: map['orderId'],
      items: (map['items'] as List).map((e) => CartItem.fromMap(e)).toList(),
      totalAmount: (map['totalAmount'] as num).toDouble(),
      deliveryAddress: Map<String, String>.from(map['deliveryAddress']),
      paymentMethod: map['paymentMethod'],
      status: map['status'],
      createdAt: DateTime.parse(map['createdAt']),
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'orderId': orderId,
      'items': items.map((e) => e.toMap()).toList(),
      'totalAmount': totalAmount,
      'deliveryAddress': deliveryAddress,
      'paymentMethod': paymentMethod,
      'status': status,
      'createdAt': createdAt.toIso8601String(),
    };
  }

  Order copyWith({String? status}) {
    return Order(
      orderId: orderId,
      items: items,
      totalAmount: totalAmount,
      deliveryAddress: deliveryAddress,
      paymentMethod: paymentMethod,
      status: status ?? this.status,
      createdAt: createdAt,
    );
  }
}
