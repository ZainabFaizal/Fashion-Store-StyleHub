// screens/cart_screen.dart
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../providers/cart_provider.dart';
import '../../providers/auth_provider.dart';
import '../../theme/app_theme.dart';
import '../../utils/responsive_helper.dart';

class CartScreen extends StatefulWidget {
  const CartScreen({super.key});

  @override
  State<CartScreen> createState() => _CartScreenState();
}

class _CartScreenState extends State<CartScreen> {
  int _selectedIndex = 2; // Cart is selected

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
    switch (index) {
      case 0: // Home
        Navigator.pushReplacementNamed(context, '/main');
        break;
      case 1: // Shop
        Navigator.pushReplacementNamed(context, '/main');
        break;
      case 2: // Cart
        // Already here
        break;
      case 3: // Profile
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

  // --- Custom Bottom Bar ---
  Widget _buildCustomBottomBar(CartProvider cart) {
    return Container(
      height: 60,
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withValues(alpha: 0.2),
            blurRadius: 10,
            offset: const Offset(0, -2),
          ),
        ],
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          _buildNavItem(Icons.home, 'Home', 0),
          _buildNavItem(Icons.shopping_bag, 'Shop', 1),
          // Cart Item
          GestureDetector(
            onTap: () => _onItemTapped(2),
            child: SizedBox(
              width: 60,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Stack(
                    clipBehavior: Clip.none,
                    children: [
                      Icon(
                        Icons.shopping_cart,
                        color: _selectedIndex == 2
                            ? AppTheme.kGold
                            : Colors.grey,
                      ),
                      if (cart.itemCount > 0)
                        Positioned(
                          right: 0,
                          top: -6,
                          child: Container(
                            padding: const EdgeInsets.all(4),
                            decoration: const BoxDecoration(
                              color: AppTheme.kRed,
                              shape: BoxShape.circle,
                            ),
                            constraints: const BoxConstraints(
                              minWidth: 14,
                              minHeight: 14,
                            ),
                            child: Text(
                              cart.itemCount.toString(),
                              style: const TextStyle(
                                color: Colors.white,
                                fontSize: 8,
                                fontWeight: FontWeight.bold,
                              ),
                              textAlign: TextAlign.center,
                            ),
                          ),
                        ),
                    ],
                  ),
                  const SizedBox(height: 4),
                  Text(
                    'Cart',
                    style: TextStyle(
                      fontSize: 10,
                      color: _selectedIndex == 2 ? AppTheme.kGold : Colors.grey,
                    ),
                  ),
                ],
              ),
            ),
          ),
          _buildNavItem(Icons.person_outline, 'Profile', 3),
        ],
      ),
    );
  }

  Widget _buildNavItem(IconData icon, String label, int index) {
    return GestureDetector(
      onTap: () => _onItemTapped(index),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            icon,
            color: _selectedIndex == index ? AppTheme.kGold : Colors.grey,
          ),
          const SizedBox(height: 4),
          Text(
            label,
            style: TextStyle(
              fontSize: 10,
              color: _selectedIndex == index ? AppTheme.kGold : Colors.grey,
            ),
          ),
        ],
      ),
    );
  }

  Widget _quantityButton(IconData icon, VoidCallback onPressed) {
    return InkWell(
      onTap: onPressed,
      borderRadius: BorderRadius.circular(4),
      child: Container(
        width: 28,
        height: 28,
        decoration: BoxDecoration(
          border: Border.all(color: AppTheme.kGold),
          borderRadius: BorderRadius.circular(4),
        ),
        child: Icon(icon, size: 16, color: AppTheme.kDark),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final auth = context.watch<AuthProvider>();
    final cart = context.watch<CartProvider>();

    return Scaffold(
      appBar: AppBar(title: const Text('Your Cart')),
      drawer: ResponsiveHelper.isDesktop(context) ? _buildDrawer(auth) : null,
      bottomNavigationBar: ResponsiveHelper.isDesktop(context)
          ? null
          : _buildCustomBottomBar(cart),
      body: cart.items.isEmpty
          ? const Center(
              child: Text('Your cart is empty', style: TextStyle(fontSize: 16)),
            )
          : LayoutBuilder(
              builder: (context, constraints) {
                if (ResponsiveHelper.isDesktop(context)) {
                  return Row(
                    children: [
                      Expanded(
                        flex: 3,
                        child: ListView.builder(
                          padding: ResponsiveHelper.getPadding(context),
                          itemCount: cart.items.length,
                          itemBuilder: (context, index) {
                            final item = cart.items[index];
                            return Card(
                              margin: const EdgeInsets.only(bottom: 12),
                              child: Padding(
                                padding: const EdgeInsets.all(16),
                                child: Row(
                                  children: [
                                    item.imageUrl.startsWith('http')
                                        ? CachedNetworkImage(
                                            imageUrl: item.imageUrl,
                                            width: 80,
                                            height: 80,
                                            fit: BoxFit.cover,
                                          )
                                        : Image.asset(
                                            item.imageUrl,
                                            width: 80,
                                            height: 80,
                                            fit: BoxFit.cover,
                                          ),
                                    const SizedBox(width: 16),
                                    Expanded(
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            item.name,
                                            style: TextStyle(
                                              fontSize:
                                                  ResponsiveHelper.getFontSize(
                                                    context,
                                                    16,
                                                  ),
                                              fontWeight: FontWeight.bold,
                                            ),
                                          ),
                                          const SizedBox(height: 4),
                                          Text(
                                            'Size: ${item.size} × ${item.quantity}',
                                            style: TextStyle(
                                              fontSize:
                                                  ResponsiveHelper.getFontSize(
                                                    context,
                                                    14,
                                                  ),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                    Text(
                                      '\$${item.total.toStringAsFixed(2)}',
                                      style: TextStyle(
                                        fontSize: ResponsiveHelper.getFontSize(
                                          context,
                                          16,
                                        ),
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            );
                          },
                        ),
                      ),
                      Expanded(
                        flex: 1,
                        child: Container(
                          color: Colors.grey[100],
                          padding: ResponsiveHelper.getPadding(context),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                'Total: \$${cart.total.toStringAsFixed(2)}',
                                style: TextStyle(
                                  fontSize: ResponsiveHelper.getFontSize(
                                    context,
                                    18,
                                  ),
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              const SizedBox(height: 24),
                              SizedBox(
                                width: double.infinity,
                                child: ElevatedButton(
                                  onPressed: () =>
                                      Navigator.pushNamed(context, '/checkout'),
                                  child: const Text('Proceed to Checkout'),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  );
                }
                return Column(
                  children: [
                    Expanded(
                      child: ListView.builder(
                        padding: ResponsiveHelper.getPadding(context),
                        itemCount: cart.items.length,
                        itemBuilder: (context, index) {
                          final item = cart.items[index];
                          return Card(
                            margin: const EdgeInsets.only(bottom: 12),
                            child: Padding(
                              padding: const EdgeInsets.all(12),
                              child: Row(
                                children: [
                                  ClipRRect(
                                    borderRadius: BorderRadius.circular(8),
                                    child: item.imageUrl.startsWith('http')
                                        ? CachedNetworkImage(
                                            imageUrl: item.imageUrl,
                                            width: 70,
                                            height: 70,
                                            fit: BoxFit.cover,
                                          )
                                        : Image.asset(
                                            item.imageUrl,
                                            width: 70,
                                            height: 70,
                                            fit: BoxFit.cover,
                                          ),
                                  ),
                                  const SizedBox(width: 12),
                                  Expanded(
                                    child: Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          item.name,
                                          style: const TextStyle(
                                            fontWeight: FontWeight.bold,
                                            fontSize: 14,
                                          ),
                                          maxLines: 2,
                                          overflow: TextOverflow.ellipsis,
                                        ),
                                        const SizedBox(height: 4),
                                        Text(
                                          'Size: ${item.size}',
                                          style: const TextStyle(
                                            color: Colors.grey,
                                            fontSize: 12,
                                          ),
                                        ),
                                        const SizedBox(height: 8),
                                        Row(
                                          children: [
                                            _quantityButton(
                                              Icons.remove,
                                              () => cart.updateQuantity(
                                                item.cartKey,
                                                item.quantity - 1,
                                              ),
                                            ),
                                            Padding(
                                              padding: const EdgeInsets.symmetric(horizontal: 12),
                                              child: Text(
                                                '${item.quantity}',
                                                style: const TextStyle(
                                                  fontWeight: FontWeight.bold,
                                                  fontSize: 16,
                                                ),
                                              ),
                                            ),
                                            _quantityButton(
                                              Icons.add,
                                              () => cart.updateQuantity(
                                                item.cartKey,
                                                item.quantity + 1,
                                              ),
                                            ),
                                          ],
                                        ),
                                      ],
                                    ),
                                  ),
                                  Column(
                                    crossAxisAlignment: CrossAxisAlignment.end,
                                    children: [
                                      IconButton(
                                        icon: const Icon(Icons.delete_outline, color: Colors.red),
                                        onPressed: () => cart.removeItem(item.cartKey),
                                      ),
                                      Text(
                                        '\$${item.total.toStringAsFixed(2)}',
                                        style: const TextStyle(
                                          fontWeight: FontWeight.bold,
                                          fontSize: 14,
                                        ),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                          );
                        },
                      ),
                    ),
                    Container(
                      padding: ResponsiveHelper.getPadding(context),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        boxShadow: [
                          BoxShadow(
                            color: Colors.grey.withValues(alpha: 0.15),
                            blurRadius: 8,
                            offset: const Offset(0, -2),
                          ),
                        ],
                      ),
                      child: Column(
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              const Text('Subtotal'),
                              Text('\$${cart.subtotal.toStringAsFixed(2)}'),
                            ],
                          ),
                          const SizedBox(height: 4),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              const Text('Shipping'),
                              Text(
                                cart.shippingCost == 0 ? 'FREE' : '\$${cart.shippingCost.toStringAsFixed(2)}',
                                style: TextStyle(
                                  color: cart.shippingCost == 0 ? Colors.green : null,
                                ),
                              ),
                            ],
                          ),
                          const Divider(height: 16),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                'Total',
                                style: TextStyle(
                                  fontSize: ResponsiveHelper.getFontSize(context, 16),
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              Text(
                                '\$${cart.total.toStringAsFixed(2)}',
                                style: TextStyle(
                                  fontSize: ResponsiveHelper.getFontSize(context, 16),
                                  fontWeight: FontWeight.bold,
                                  color: AppTheme.kGold,
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 12),
                          SizedBox(
                            width: double.infinity,
                            child: ElevatedButton(
                              onPressed: () =>
                                  Navigator.pushNamed(context, '/checkout'),
                              child: const Text('Proceed to Checkout'),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                );
              },
            ),
    );
  }
}
