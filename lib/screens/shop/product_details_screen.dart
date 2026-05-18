// screens/product_details_screen.dart
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../models/product_model.dart';
import '../../providers/cart_provider.dart';
import '../../providers/auth_provider.dart';
import '../../theme/app_theme.dart';
import '../../utils/responsive_helper.dart';

class ProductDetailsScreen extends StatefulWidget {
  const ProductDetailsScreen({super.key});

  @override
  State<ProductDetailsScreen> createState() => _ProductDetailsScreenState();
}

class _ProductDetailsScreenState extends State<ProductDetailsScreen> {
  String? _selectedSize;
  int _quantity = 1; // ✅ NEW: State for quantity
  int _selectedIndex = 1;

  void _incrementQuantity() {
    setState(() {
      _quantity++;
    });
  }

  void _decrementQuantity() {
    if (_quantity > 1) {
      setState(() {
        _quantity--;
      });
    }
  }

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
    switch (index) {
      case 0:
        Navigator.pushReplacementNamed(context, '/main');
        break;
      case 1:
        Navigator.pushReplacementNamed(context, '/main');
        break;
      case 2:
        Navigator.pushNamed(context, '/cart');
        break;
      case 3:
        Navigator.pushNamed(context, '/profile');
        break;
    }
  }

  Widget _buildDrawer(AuthProvider auth) {
    return Drawer(
      child: ListView(
        padding: EdgeInsets.zero,
        children: [
          DrawerHeader(
            decoration: const BoxDecoration(color: AppTheme.kGold),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                CircleAvatar(
                  radius: 30,
                  backgroundColor: AppTheme.kDark,
                  child: Text(
                    auth.user?.initials ?? '',
                    style: const TextStyle(
                      color: AppTheme.kGold,
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                const SizedBox(height: 10),
                Text(
                  auth.user?.name ?? 'Guest',
                  style: const TextStyle(
                    color: AppTheme.kDark,
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Text(
                  auth.user?.email ?? '',
                  style: const TextStyle(color: AppTheme.kDark, fontSize: 14),
                ),
              ],
            ),
          ),
          ListTile(
            leading: const Icon(Icons.home),
            title: const Text('Home'),
            selected: _selectedIndex == 0,
            onTap: () => _onItemTapped(0),
          ),
          ListTile(
            leading: const Icon(Icons.shopping_bag),
            title: const Text('Shop'),
            selected: _selectedIndex == 1,
            onTap: () => _onItemTapped(1),
          ),
          ListTile(
            leading: const Icon(Icons.shopping_cart),
            title: const Text('Cart'),
            selected: _selectedIndex == 2,
            onTap: () => _onItemTapped(2),
          ),
          const Divider(),
          ListTile(
            leading: const Icon(Icons.person_outline),
            title: const Text('Profile'),
            selected: _selectedIndex == 3,
            onTap: () => _onItemTapped(3),
          ),
        ],
      ),
    );
  }

  Widget _buildBottomNavigationBar() {
    return BottomNavigationBar(
      type: BottomNavigationBarType.fixed,
      items: const [
        BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Home'),
        BottomNavigationBarItem(icon: Icon(Icons.shopping_bag), label: 'Shop'),
        BottomNavigationBarItem(icon: Icon(Icons.shopping_cart), label: 'Cart'),
        BottomNavigationBarItem(icon: Icon(Icons.person_outline), label: 'Profile'),
      ],
      currentIndex: _selectedIndex,
      selectedItemColor: AppTheme.kGold,
      unselectedItemColor: Colors.grey,
      onTap: _onItemTapped,
    );
  }

  // ✅ NEW: Widget for Quantity Selector
  Widget _buildQuantitySelector() {
    return Container(
      height: 50,
      width: 140, // Fixed width for consistency
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border.all(color: AppTheme.kGold),
        borderRadius: BorderRadius.circular(30),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          IconButton(
            icon: const Icon(Icons.remove, size: 20, color: AppTheme.kDark),
            padding: EdgeInsets.zero,
            constraints: const BoxConstraints(),
            onPressed: _quantity > 1 ? _decrementQuantity : null,
          ),
          Text(
            '$_quantity',
            style: const TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: AppTheme.kDark,
            ),
          ),
          IconButton(
            icon: const Icon(Icons.add, size: 20, color: AppTheme.kDark),
            padding: EdgeInsets.zero,
            constraints: const BoxConstraints(),
            onPressed: _incrementQuantity,
          ),
        ],
      ),
    );
  }

  // ✅ NEW: Reusable Widget for Product Details (To avoid code duplication)
  Widget _buildProductDetails(Product product, bool isWideScreen) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Brand/Category
        Text(
          'Style Hub', // Or product.category if available
          style: TextStyle(
            fontSize: ResponsiveHelper.getFontSize(context, 12),
            color: AppTheme.kGray,
            letterSpacing: 1,
          ),
        ),
        const SizedBox(height: 8),

        // Product Name
        Text(
          product.name,
          style: TextStyle(
            fontSize: ResponsiveHelper.getFontSize(context, 28),
            fontWeight: FontWeight.bold,
            color: AppTheme.kDark,
            height: 1.2,
          ),
        ),
        const SizedBox(height: 16),

        // Price
        Row(
          children: [
            Text(
              '\$${product.price.toStringAsFixed(2)}',
              style: TextStyle(
                fontSize: ResponsiveHelper.getFontSize(context, 24),
                fontWeight: FontWeight.bold,
                color: AppTheme.kGold,
              ),
            ),
            if (product.originalPrice != null) ...[
              const SizedBox(width: 12),
              Text(
                '\$${product.originalPrice!.toStringAsFixed(2)}',
                style: TextStyle(
                  fontSize: ResponsiveHelper.getFontSize(context, 18),
                  color: AppTheme.kGray,
                  decoration: TextDecoration.lineThrough,
                ),
              ),
            ],
          ],
        ),
        const SizedBox(height: 24),

        // Description
        Text(
          'Description',
          style: TextStyle(
            fontSize: ResponsiveHelper.getFontSize(context, 16),
            fontWeight: FontWeight.w600,
            color: AppTheme.kDark,
          ),
        ),
        const SizedBox(height: 8),
        Text(
          product.description,
          style: TextStyle(
            fontSize: ResponsiveHelper.getFontSize(context, 14),
            color: AppTheme.kGray,
            height: 1.5,
          ),
        ),
        const SizedBox(height: 24),

        // Size Selection
        Text(
          'Select Size',
          style: TextStyle(
            fontSize: ResponsiveHelper.getFontSize(context, 16),
            fontWeight: FontWeight.w600,
            color: AppTheme.kDark,
          ),
        ),
        const SizedBox(height: 12),
        Wrap(
          spacing: 8,
          runSpacing: 8,
          children: product.sizes.map((size) {
            return ChoiceChip(
              label: Text(size),
              selected: size == _selectedSize,
              selectedColor: AppTheme.kGold,
              onSelected: (_) => setState(() => _selectedSize = size),
              labelStyle: TextStyle(
                color: size == _selectedSize ? AppTheme.kDark : AppTheme.kGray,
              ),
            );
          }).toList(),
        ),
        const SizedBox(height: 32),

        // ✅ NEW: Quantity Selection
        Text(
          'Quantity',
          style: TextStyle(
            fontSize: ResponsiveHelper.getFontSize(context, 16),
            fontWeight: FontWeight.w600,
            color: AppTheme.kDark,
          ),
        ),
        const SizedBox(height: 12),
        _buildQuantitySelector(),

        const SizedBox(height: 40),

        // Add to Cart Button
        SizedBox(
          width: double.infinity,
          height: 50,
          child: ElevatedButton(
            onPressed: () {
              // Loop to add items based on quantity
              for (int i = 0; i < _quantity; i++) {
                context.read<CartProvider>().addItem(product, _selectedSize!);
              }

              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text('$_quantity item(s) added to cart'),
                  backgroundColor: AppTheme.kDark,
                ),
              );
              Navigator.pop(context);
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: AppTheme.kGold,
              foregroundColor: AppTheme.kDark,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
              ),
            ),
            child: Text(
              'Add to Cart'.toUpperCase(),
              style: const TextStyle(
                fontWeight: FontWeight.bold,
                letterSpacing: 1,
              ),
            ),
          ),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    final auth = context.watch<AuthProvider>();
    final Product product =
        ModalRoute.of(context)!.settings.arguments as Product;
    _selectedSize ??= product.sizes.first;

    return Scaffold(
      backgroundColor: AppTheme.kBg,
      appBar: AppBar(
        title: const Text(
          'Style Hub',
          style: TextStyle(color: AppTheme.kDark, fontWeight: FontWeight.bold),
        ),
        backgroundColor: Colors.white,
        elevation: 0,
        iconTheme: const IconThemeData(color: AppTheme.kDark),
      ),
      drawer: ResponsiveHelper.isDesktop(context) ? _buildDrawer(auth) : null,
      bottomNavigationBar: ResponsiveHelper.isDesktop(context)
          ? null
          : _buildBottomNavigationBar(),
      body: LayoutBuilder(
        builder: (context, constraints) {
          // --- DESKTOP & TABLET LAYOUT (Side by Side) ---
          if (ResponsiveHelper.isTablet(context) ||
              ResponsiveHelper.isDesktop(context)) {
            return Row(
              children: [
                // Left: Image Section
                Expanded(
                  flex: 1,
                  child: SingleChildScrollView(
                    child: Padding(
                      padding: ResponsiveHelper.getPadding(
                        context,
                      ).copyWith(bottom: 48),
                      child: Column(
                        children: [
                          const SizedBox(height: 20),
                          ClipRRect(
                            borderRadius: BorderRadius.circular(12),
                            child: product.imageUrl.startsWith('http')
                                ? Image.network(
                                    product.imageUrl,
                                    height: ResponsiveHelper.getImageHeight(context),
                                    width: double.infinity,
                                    fit: BoxFit.contain,
                                    errorBuilder: (_, __, ___) => const Icon(
                                      Icons.image_not_supported,
                                      size: 100,
                                    ),
                                  )
                                : Image.asset(
                                    product.imageUrl,
                                    height: ResponsiveHelper.getImageHeight(context),
                                    width: double.infinity,
                                    fit: BoxFit.contain,
                                  ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
                // Right: Details Section
                Expanded(
                  flex: 1,
                  child: SingleChildScrollView(
                    padding: ResponsiveHelper.getPadding(
                      context,
                    ).copyWith(bottom: 48),
                    child: _buildProductDetails(product, true),
                  ),
                ),
              ],
            );
          }

          // --- MOBILE LAYOUT (Vertical Stack) ---
          return SingleChildScrollView(
            padding: ResponsiveHelper.getPadding(context).copyWith(bottom: 32),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 10),
                ClipRRect(
                  borderRadius: BorderRadius.circular(12),
                  child: product.imageUrl.startsWith('http')
                      ? Image.network(
                          product.imageUrl,
                          height: ResponsiveHelper.getImageHeight(context),
                          width: double.infinity,
                          fit: BoxFit.cover,
                          errorBuilder: (_, __, ___) =>
                              const Icon(Icons.image_not_supported, size: 80),
                        )
                      : Image.asset(
                          product.imageUrl,
                          height: ResponsiveHelper.getImageHeight(context),
                          width: double.infinity,
                          fit: BoxFit.cover,
                        ),
                ),
                const SizedBox(height: 24),
                _buildProductDetails(product, false),
              ],
            ),
          );
        },
      ),
    );
  }
}
