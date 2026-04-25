import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:cached_network_image/cached_network_image.dart';
import '../../providers/product_provider.dart';
import '../../providers/cart_provider.dart';
import '../../providers/auth_provider.dart';
import '../../models/product_model.dart';
import '../../theme/app_theme.dart';
import '../../utils/responsive_helper.dart';

class MainScreen extends StatefulWidget {
  const MainScreen({super.key});

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  int _selectedIndex = 1; // Shop is selected

  final List<String> categories = const [
    'All',
    'Women',
    'Men',
    'Kids',
    'Accessories',
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
    switch (index) {
      case 0:
        Navigator.pushReplacementNamed(context, '/home');
        break;
      case 1:
        // Already here
        break;
      case 2:
        Navigator.pushNamed(context, '/cart');
        break;
      case 3:
        _showLogoutDialog();
        break;
    }
  }

  void _showLogoutDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Logout'),
        content: const Text('Are you sure you want to logout?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              context.read<AuthProvider>().logout();
              Navigator.pushNamedAndRemoveUntil(
                context,
                '/login',
                (route) => false,
              );
            },
            child: const Text('Logout'),
          ),
        ],
      ),
    );
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
            leading: const Icon(Icons.logout),
            title: const Text('Logout'),
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
        BottomNavigationBarItem(icon: Icon(Icons.logout), label: 'Logout'),
      ],
      currentIndex: _selectedIndex,
      selectedItemColor: AppTheme.kGold,
      unselectedItemColor: Colors.grey,
      onTap: _onItemTapped,
    );
  }

  @override
  Widget build(BuildContext context) {
    // ✅ FIX 1: Renamed 'cart' to 'cartProvider' to match usage later in the code
    final auth = context.watch<AuthProvider>();
    final cartProvider = context.watch<CartProvider>();
    final productProvider = context.watch<ProductProvider>();

    return Scaffold(
      backgroundColor: AppTheme.kBg,
      drawer: ResponsiveHelper.isDesktop(context) ? _buildDrawer(auth) : null,
      bottomNavigationBar: ResponsiveHelper.isDesktop(context)
          ? null
          : _buildBottomNavigationBar(),
      body: SafeArea(
        child: Column(
          children: [
            // Unified Top Bar
            _buildTopBar(auth, cartProvider), // ✅ Passing cartProvider here
            // CATEGORY FILTER
            SizedBox(
              height: 50,
              child: ListView.builder(
                padding: const EdgeInsets.symmetric(horizontal: 12),
                scrollDirection: Axis.horizontal,
                itemCount: categories.length,
                itemBuilder: (context, index) {
                  final category = categories[index];
                  return Padding(
                    padding: const EdgeInsets.only(right: 8),
                    child: ChoiceChip(
                      label: Text(category),
                      selected: productProvider.selectedCategory == category,
                      onSelected: (_) => productProvider.setCategory(category),
                    ),
                  );
                },
              ),
            ),
            // VIEW ALL
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              child: Align(
                alignment: Alignment.centerRight,
                child: TextButton(
                  onPressed: () => productProvider.clearFilters(),
                  child: const Text('View All'),
                ),
              ),
            ),
            // PRODUCT GRID
            Expanded(
              child: productProvider.filteredProducts.isEmpty
                  ? const Center(child: Text('No products found'))
                  : Padding(
                      padding: ResponsiveHelper.getPadding(context),
                      child: GridView.builder(
                        itemCount: productProvider.filteredProducts.length,
                        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: ResponsiveHelper.getGridColumns(
                            context,
                          ),
                          childAspectRatio: ResponsiveHelper.isMobile(context)
                              ? 0.68
                              : 0.75,
                          crossAxisSpacing: 12,
                          mainAxisSpacing: 12,
                        ),
                        itemBuilder: (context, index) {
                          final Product product =
                              productProvider.filteredProducts[index];
                          return GestureDetector(
                            onTap: () => Navigator.pushNamed(
                              context,
                              '/product-details',
                              arguments: product,
                            ),
                            child: Card(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Expanded(
                                    child: CachedNetworkImage(
                                      imageUrl: product.imageUrl,
                                      fit: BoxFit.cover,
                                      width: double.infinity,
                                      errorWidget: (_, __, ___) =>
                                          const Icon(Icons.image_not_supported),
                                    ),
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.all(8),
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          product.name,
                                          maxLines: 1,
                                          overflow: TextOverflow.ellipsis,
                                          style: TextStyle(
                                            fontWeight: FontWeight.bold,
                                            fontSize:
                                                ResponsiveHelper.getFontSize(
                                                  context,
                                                  14,
                                                ),
                                          ),
                                        ),
                                        const SizedBox(height: 4),
                                        Text(
                                          '\$${product.price.toStringAsFixed(2)}',
                                          style: TextStyle(
                                            fontSize:
                                                ResponsiveHelper.getFontSize(
                                                  context,
                                                  14,
                                                ),
                                          ),
                                        ),
                                        const SizedBox(height: 6),
                                        SizedBox(
                                          width: double.infinity,
                                          child: ElevatedButton(
                                            onPressed: () =>
                                                cartProvider.addItem(
                                                  product,
                                                  product.sizes.first,
                                                ),
                                            child: Text(
                                              'Add to Cart',
                                              style: TextStyle(
                                                fontSize:
                                                    ResponsiveHelper.getFontSize(
                                                      context,
                                                      12,
                                                    ),
                                              ),
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          );
                        },
                      ),
                    ),
            ),
          ],
        ),
      ),
      // ✅ FIX 2: REMOVED the duplicate "CHECKOUT BAR" code that was floating here outside the Scaffold.
      // It was causing a syntax error. You already have a cart button in the Bottom Navigation Bar.
    );
  }

  Widget _buildTopBar(AuthProvider auth, CartProvider cart) {
    return Padding(
      padding: ResponsiveHelper.getPadding(context),
      child: Row(
        children: [
          GestureDetector(
            onTap: () {
              // Note: Ensure '/profile' route is defined in main.dart or this will crash
              // If not defined, you might want to comment this out or create the screen.
              Navigator.pushNamed(context, '/profile');
            },
            child: Row(
              children: [
                CircleAvatar(
                  radius: ResponsiveHelper.getValue(
                    context: context,
                    mobile: 18,
                    tablet: 20,
                    desktop: 22,
                  ),
                  backgroundColor: AppTheme.kGold,
                  child: Text(
                    auth.user?.initials ?? '',
                    style: TextStyle(
                      color: AppTheme.kDark,
                      fontWeight: FontWeight.bold,
                      fontSize: ResponsiveHelper.getFontSize(context, 14),
                    ),
                  ),
                ),
                const SizedBox(width: 8),
                Text(
                  auth.user?.name ?? 'Guest',
                  style: TextStyle(
                    fontWeight: FontWeight.w600,
                    fontSize: ResponsiveHelper.getFontSize(context, 14),
                  ),
                ),
              ],
            ),
          ),
          const Spacer(),
          Stack(
            children: [
              IconButton(
                icon: const Icon(Icons.shopping_cart_outlined),
                onPressed: () => Navigator.pushNamed(context, '/cart'),
              ),
              if (cart.itemCount > 0)
                Positioned(
                  right: 4,
                  top: 4,
                  child: CircleAvatar(
                    radius: ResponsiveHelper.getValue(
                      context: context,
                      mobile: 8,
                      tablet: 10,
                      desktop: 12,
                    ),
                    backgroundColor: AppTheme.kRed,
                    child: Text(
                      cart.itemCount.toString(),
                      style: TextStyle(
                        color: AppTheme.kWhite,
                        fontSize: ResponsiveHelper.getFontSize(context, 10),
                      ),
                    ),
                  ),
                ),
            ],
          ),
          if (ResponsiveHelper.isDesktop(context))
            Builder(
              builder: (context) => IconButton(
                icon: const Icon(Icons.menu),
                onPressed: () => Scaffold.of(context).openDrawer(),
              ),
            ),
        ],
      ),
    );
  }
}
