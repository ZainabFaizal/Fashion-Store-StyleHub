class CartItem {
  final String productId;
  final String name;
  final double price;
  final String size;
  final int quantity;
  final String imageUrl;
  final String category;

  const CartItem({
    required this.productId,
    required this.name,
    required this.price,
    required this.size,
    required this.quantity,
    required this.imageUrl,
    required this.category,
  });

  String get cartKey => '$productId-$size';

  double get total => price * quantity;

  factory CartItem.fromMap(Map<String, dynamic> map) {
    return CartItem(
      productId: map['productId'],
      name: map['name'],
      price: (map['price'] as num).toDouble(),
      size: map['size'],
      quantity: map['quantity'],
      imageUrl: map['imageUrl'],
      category: map['category'],
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'productId': productId,
      'name': name,
      'price': price,
      'size': size,
      'quantity': quantity,
      'imageUrl': imageUrl,
      'category': category,
    };
  }

  CartItem copyWith({int? quantity}) {
    return CartItem(
      productId: productId,
      name: name,
      price: price,
      size: size,
      quantity: quantity ?? this.quantity,
      imageUrl: imageUrl,
      category: category,
    );
  }
}
