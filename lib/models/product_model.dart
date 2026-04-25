class Product {
  final String id;
  final String name;
  final String description;
  final String category;
  final String imageUrl;
  final String badge;
  final double price;
  final double? originalPrice;
  final double rating;
  final int reviewCount;
  final List<String> sizes;

  const Product({
    required this.id,
    required this.name,
    required this.description,
    required this.category,
    required this.imageUrl,
    this.badge = '',
    required this.price,
    this.originalPrice,
    this.rating = 0.0,
    this.reviewCount = 0,
    this.sizes = const ['XS', 'S', 'M', 'L', 'XL', 'XXL'],
  });

  factory Product.fromMap(Map<String, dynamic> map) {
    return Product(
      id: map['id'],
      name: map['name'],
      description: map['description'],
      category: map['category'],
      imageUrl: map['imageUrl'],
      badge: map['badge'] ?? '',
      price: (map['price'] as num).toDouble(),
      originalPrice: map['originalPrice'] != null
          ? (map['originalPrice'] as num).toDouble()
          : null,
      rating: (map['rating'] as num?)?.toDouble() ?? 0.0,
      reviewCount: map['reviewCount'] ?? 0,
      sizes: List<String>.from(
        map['sizes'] ?? ['XS', 'S', 'M', 'L', 'XL', 'XXL'],
      ),
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'description': description,
      'category': category,
      'imageUrl': imageUrl,
      'badge': badge,
      'price': price,
      'originalPrice': originalPrice,
      'rating': rating,
      'reviewCount': reviewCount,
      'sizes': sizes,
    };
  }

  double get discountPercentage {
    if (originalPrice == null) return 0;
    return double.parse(
      (((originalPrice! - price) / originalPrice!) * 100).toStringAsFixed(0),
    );
  }

  Product copyWith({
    String? id,
    String? name,
    String? description,
    String? category,
    String? imageUrl,
    String? badge,
    double? price,
    double? originalPrice,
    double? rating,
    int? reviewCount,
    List<String>? sizes,
  }) {
    return Product(
      id: id ?? this.id,
      name: name ?? this.name,
      description: description ?? this.description,
      category: category ?? this.category,
      imageUrl: imageUrl ?? this.imageUrl,
      badge: badge ?? this.badge,
      price: price ?? this.price,
      originalPrice: originalPrice ?? this.originalPrice,
      rating: rating ?? this.rating,
      reviewCount: reviewCount ?? this.reviewCount,
      sizes: sizes ?? this.sizes,
    );
  }
}
