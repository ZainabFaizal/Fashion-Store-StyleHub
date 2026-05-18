// screens/checkout_screen.dart
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../providers/cart_provider.dart';
import '../../providers/order_provider.dart';
import '../../providers/auth_provider.dart';
import '../../theme/app_theme.dart';
import '../../utils/responsive_helper.dart';

class CheckoutScreen extends StatefulWidget {
  const CheckoutScreen({super.key});

  @override
  State<CheckoutScreen> createState() => _CheckoutScreenState();
}

class _CheckoutScreenState extends State<CheckoutScreen> {
  late final TextEditingController _nameController;
  late final TextEditingController _phoneController;
  late final TextEditingController _addressController;
  final _cityController = TextEditingController();
  final _zipController = TextEditingController();
  final _countryController = TextEditingController(text: 'Sri Lanka');
  String _paymentMethod = 'Cash on Delivery';
  bool _isLoading = false;
  int _selectedIndex = 2;

  @override
  void initState() {
    super.initState();
    final user = context.read<AuthProvider>().user;
    _nameController = TextEditingController(text: user?.name ?? '');
    _phoneController = TextEditingController(text: user?.phone ?? '');
    _addressController = TextEditingController(text: user?.address ?? '');
  }

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
        Navigator.pushNamed(context, '/cart');
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

  bool _validate() {
    return _nameController.text.isNotEmpty &&
        _phoneController.text.isNotEmpty &&
        _addressController.text.isNotEmpty &&
        _cityController.text.isNotEmpty &&
        _zipController.text.isNotEmpty;
  }

  void _showSuccessDialog() {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (_) => AlertDialog(
        title: const Text('Order Successful ✅'),
        content: const Text(
          'Your order has been placed successfully.\n\nThank you for shopping with StyleHub!',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pushNamedAndRemoveUntil(
              context,
              '/main',
              (route) => false,
            ),
            child: const Text('Continue Shopping'),
          ),
        ],
      ),
    );
  }

  Future<void> _placeOrder() async {
    if (!_validate()) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please fill all required fields')),
      );
      return;
    }

    final cartProvider = context.read<CartProvider>();
    final orderProvider = context.read<OrderProvider>();
    final authProvider = context.read<AuthProvider>();
    final userId = authProvider.user?.uid;

    if (userId == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please login to place an order')),
      );
      return;
    }

    setState(() => _isLoading = true);

    try {
      await orderProvider.placeOrder(
        userId: userId,
        items: cartProvider.items,
        total: cartProvider.total,
        delivery: {
          'name': _nameController.text.trim(),
          'phone': _phoneController.text.trim(),
          'address': _addressController.text.trim(),
          'city': _cityController.text.trim(),
          'zip': _zipController.text.trim(),
          'country': _countryController.text.trim(),
        },
        paymentMethod: _paymentMethod,
      );
      cartProvider.clearCart();
      setState(() => _isLoading = false);
      if (mounted) _showSuccessDialog();
    } catch (e) {
      setState(() => _isLoading = false);
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Order failed: ${e.toString()}')),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final auth = context.watch<AuthProvider>();
    final cart = context.watch<CartProvider>();
    return Scaffold(
      appBar: AppBar(title: const Text('Checkout')),
      drawer: ResponsiveHelper.isDesktop(context) ? _buildDrawer(auth) : null,
      bottomNavigationBar: ResponsiveHelper.isDesktop(context)
          ? null
          : _buildCustomBottomBar(cart),
      body: LayoutBuilder(
        builder: (context, constraints) {
          if (ResponsiveHelper.isDesktop(context)) {
            return Row(
              children: [
                Expanded(
                  flex: 2,
                  child: SingleChildScrollView(
                    padding: ResponsiveHelper.getPadding(context),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        _buildFormSection('Delivery Information', [
                          _field('Full Name', _nameController),
                          _field('Phone Number', _phoneController),
                          _field('Address', _addressController),
                          _field('City', _cityController),
                          _field('ZIP Code', _zipController),
                          _field('Country', _countryController),
                        ]),
                        const SizedBox(height: 24),
                        _buildPaymentSection(),
                      ],
                    ),
                  ),
                ),
                Expanded(
                  flex: 1,
                  child: Container(
                    color: Colors.grey[100],
                    padding: ResponsiveHelper.getPadding(context),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const SizedBox(height: 20),
                        Text(
                          'Order Summary',
                          style: TextStyle(
                            fontSize: ResponsiveHelper.getFontSize(context, 18),
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 16),
                        ...cart.items.map(
                          (item) => Padding(
                            padding: const EdgeInsets.only(bottom: 12),
                            child: Row(
                              children: [
                                Expanded(
                                  child: Text(
                                    '${item.name} (${item.size}) x${item.quantity}',
                                    style: TextStyle(
                                      fontSize: ResponsiveHelper.getFontSize(
                                        context,
                                        14,
                                      ),
                                    ),
                                  ),
                                ),
                                Text(
                                  '\$${item.total.toStringAsFixed(2)}',
                                  style: TextStyle(
                                    fontSize: ResponsiveHelper.getFontSize(
                                      context,
                                      14,
                                    ),
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                        const Divider(height: 24),
                        Text(
                          'Total: \$${cart.total.toStringAsFixed(2)}',
                          style: TextStyle(
                            fontSize: ResponsiveHelper.getFontSize(context, 18),
                            fontWeight: FontWeight.bold,
                            color: AppTheme.kGold,
                          ),
                        ),
                        const SizedBox(height: 24),
                        SizedBox(
                          width: double.infinity,
                          child: ElevatedButton(
                            onPressed: _isLoading ? null : _placeOrder,
                            child: _isLoading
                                ? const SizedBox(
                                    height: 20,
                                    width: 20,
                                    child: CircularProgressIndicator(
                                      color: AppTheme.kDark,
                                      strokeWidth: 2,
                                    ),
                                  )
                                : const Text('Place Order'),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            );
          }
          return SingleChildScrollView(
            padding: ResponsiveHelper.getPadding(context),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildFormSection('Delivery Information', [
                  _field('Full Name', _nameController),
                  _field('Phone Number', _phoneController),
                  _field('Address', _addressController),
                  _field('City', _cityController),
                  _field('ZIP Code', _zipController),
                  _field('Country', _countryController),
                ]),
                const SizedBox(height: 24),
                _buildPaymentSection(),
                const SizedBox(height: 24),
                Text(
                  'Order Summary',
                  style: TextStyle(
                    fontSize: ResponsiveHelper.getFontSize(context, 18),
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 16),
                ...cart.items.map(
                  (item) => Padding(
                    padding: const EdgeInsets.only(bottom: 12),
                    child: Row(
                      children: [
                        Expanded(
                          child: Text(
                            '${item.name} (${item.size}) x${item.quantity}',
                            style: TextStyle(
                              fontSize: ResponsiveHelper.getFontSize(
                                context,
                                14,
                              ),
                            ),
                          ),
                        ),
                        Text(
                          '\$${item.total.toStringAsFixed(2)}',
                          style: TextStyle(
                            fontSize: ResponsiveHelper.getFontSize(context, 14),
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                const Divider(height: 24),
                Text(
                  'Total: \$${cart.total.toStringAsFixed(2)}',
                  style: TextStyle(
                    fontSize: ResponsiveHelper.getFontSize(context, 18),
                    fontWeight: FontWeight.bold,
                    color: AppTheme.kGold,
                  ),
                ),
                const SizedBox(height: 24),
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: _isLoading ? null : _placeOrder,
                    child: _isLoading
                        ? const SizedBox(
                            height: 20,
                            width: 20,
                            child: CircularProgressIndicator(
                              color: AppTheme.kDark,
                              strokeWidth: 2,
                            ),
                          )
                        : const Text('Place Order'),
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _buildFormSection(String title, List<Widget> fields) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: TextStyle(
            fontSize: ResponsiveHelper.getFontSize(context, 16),
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 16),
        ...fields,
      ],
    );
  }

  Widget _buildPaymentSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Payment Method',
          style: TextStyle(
            fontSize: ResponsiveHelper.getFontSize(context, 16),
            fontWeight: FontWeight.bold,
          ),
        ),
        _paymentOption('Cash on Delivery', Icons.money),
        _paymentOption('Credit Card', Icons.credit_card),
      ],
    );
  }

  Widget _paymentOption(String value, IconData icon) {
    final selected = _paymentMethod == value;
    return InkWell(
      onTap: () => setState(() => _paymentMethod = value),
      borderRadius: BorderRadius.circular(8),
      child: Container(
        margin: const EdgeInsets.only(bottom: 8),
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
        decoration: BoxDecoration(
          border: Border.all(
            color: selected ? AppTheme.kGold : Colors.grey.shade300,
            width: selected ? 2 : 1,
          ),
          borderRadius: BorderRadius.circular(8),
          color: selected ? AppTheme.kGold.withValues(alpha: 0.08) : null,
        ),
        child: Row(
          children: [
            Icon(icon, color: selected ? AppTheme.kGold : Colors.grey),
            const SizedBox(width: 12),
            Text(
              value,
              style: TextStyle(
                fontSize: ResponsiveHelper.getFontSize(context, 14),
                fontWeight: selected ? FontWeight.bold : FontWeight.normal,
                color: selected ? AppTheme.kDark : Colors.grey.shade700,
              ),
            ),
            const Spacer(),
            if (selected)
              const Icon(Icons.check_circle, color: AppTheme.kGold, size: 20),
          ],
        ),
      ),
    );
  }

  Widget _field(String label, TextEditingController controller) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: TextField(
        controller: controller,
        decoration: InputDecoration(
          labelText: label,
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
        ),
      ),
    );
  }
}
