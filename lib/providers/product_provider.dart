import 'package:flutter/material.dart';
import '../data/products_data.dart';
import '../models/product_model.dart';
import '../services/firestore_service.dart';

class ProductProvider extends ChangeNotifier {
  final FirestoreService _firestoreService = FirestoreService();

  // Products loaded from Firestore (Phase 2) or mock data (Phase 1)
  List<Product> _products = productsData;
  bool _isLoading = false;
  String? _error;

  final List<String> _wishlist = [];
  String _selectedCategory = 'All';
  String _searchQuery = '';
  String _sortBy = 'default';

  bool get isLoading => _isLoading;
  String? get error => _error;

  // ── Load products from Firestore (call on app start, Phase 2) ──────────
  Future<void> loadProducts() async {
    _isLoading = true;
    _error = null;
    notifyListeners();
    try {
      _products = await _firestoreService.fetchProducts();
    } catch (e) {
      _error = 'Failed to load products.';
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }
  // ────────────────────────────────────────────────────────────────────────

  List<String> get categories => ['All', 'Women', 'Men', 'Kids', 'Accessories'];

  String get selectedCategory => _selectedCategory;
  String get searchQuery => _searchQuery;
  String get sortBy => _sortBy;

  List<String> get wishlist => _wishlist;

  // Get all products (for search)
  List<Product> get allProducts => _products;

  List<Product> get filteredProducts {
    List<Product> result = _products;

    if (_selectedCategory != 'All') {
      result = result.where((p) => p.category == _selectedCategory).toList();
    }

    if (_searchQuery.isNotEmpty) {
      result = result.where((p) {
        final query = _searchQuery.toLowerCase();
        return p.name.toLowerCase().contains(query) ||
            p.description.toLowerCase().contains(query);
      }).toList();
    }

    switch (_sortBy) {
      case 'price_low':
        result.sort((a, b) => a.price.compareTo(b.price));
        break;
      case 'price_high':
        result.sort((a, b) => b.price.compareTo(a.price));
        break;
      case 'rating':
        result.sort((a, b) => b.rating.compareTo(a.rating));
        break;
      case 'newest':
        break;
      default:
        break;
    }

    return result;
  }

  List<Product> get featuredProducts {
    // FIXED: Added null safety check (?. and ?? false) for badge to prevent crashes
    return _products
        .where((p) => p.badge.isNotEmpty ?? false)
        .toList()
        .take(6)
        .toList();
  }

  List<Product> get newArrivals {
    return _products.where((p) => p.badge == 'New').toList();
  }

  void setCategory(String category) {
    if (_selectedCategory != category) {
      _selectedCategory = category;
      notifyListeners();
    }
  }

  void setSearch(String query) {
    if (_searchQuery != query) {
      _searchQuery = query;
      notifyListeners();
    }
  }

  void setSort(String sort) {
    if (_sortBy != sort) {
      _sortBy = sort;
      notifyListeners();
    }
  }

  void toggleWishlist(String productId) {
    if (_wishlist.contains(productId)) {
      _wishlist.remove(productId);
    } else {
      _wishlist.add(productId);
    }
    notifyListeners();
  }

  bool isWishlisted(String productId) {
    return _wishlist.contains(productId);
  }

  Product? getProductById(String id) {
    try {
      return _products.firstWhere((p) => p.id == id);
    } catch (e) {
      return null;
    }
  }

  void clearFilters() {
    _selectedCategory = 'All';
    _searchQuery = '';
    _sortBy = 'default';
    notifyListeners();
  }

  // NEW: Search products method for the search delegate
  List<Product> searchProducts(String query) {
    if (query.isEmpty) return [];

    return _products.where((product) {
      final nameLower = product.name.toLowerCase();
      final descriptionLower = product.description.toLowerCase();
      final queryLower = query.toLowerCase();

      return nameLower.contains(queryLower) ||
          descriptionLower.contains(queryLower);
    }).toList();
  }
}
