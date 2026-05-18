// screens/orders_screen.dart
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import '../../providers/order_provider.dart';
import '../../providers/auth_provider.dart';
import '../../theme/app_theme.dart';
import '../../utils/responsive_helper.dart';

class OrdersScreen extends StatefulWidget {
  const OrdersScreen({super.key});

  @override
  State<OrdersScreen> createState() => _OrdersScreenState();
}

class _OrdersScreenState extends State<OrdersScreen> {
  int _selectedIndex = 3;

  Color _getStatusColor(String status) {
    switch (status) {
      case 'Processing':
        return AppTheme.kGold;
      case 'Delivered':
        return AppTheme.kGreen;
      default:
        return AppTheme.kGray;
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
    final auth = context.watch<AuthProvider>();
    return Scaffold(
      appBar: AppBar(title: const Text('My Orders')),
      drawer: ResponsiveHelper.isDesktop(context) ? _buildDrawer(auth) : null,
      bottomNavigationBar: ResponsiveHelper.isDesktop(context)
          ? null
          : _buildBottomNavigationBar(),
      body: Consumer<OrderProvider>(
        builder: (context, provider, _) {
          if (provider.orders.isEmpty) {
            return const Center(child: Text('No orders yet'));
          }

          return LayoutBuilder(
            builder: (context, constraints) {
              if (ResponsiveHelper.isDesktop(context)) {
                return Padding(
                  padding: ResponsiveHelper.getPadding(context),
                  child: SingleChildScrollView(
                    child: DataTable(
                      columns: const [
                        DataColumn(label: Text('Order ID')),
                        DataColumn(label: Text('Date')),
                        DataColumn(label: Text('Status')),
                      ],
                      rows: provider.orders.map((order) {
                        final date = DateFormat(
                          'MMM dd, yyyy',
                        ).format(order.createdAt);
                        return DataRow(
                          cells: [
                            DataCell(Text('Order ${order.orderId}')),
                            DataCell(Text(date)),
                            DataCell(
                              Text(
                                order.status,
                                style: TextStyle(
                                  color: _getStatusColor(order.status),
                                ),
                              ),
                            ),
                          ],
                        );
                      }).toList(),
                    ),
                  ),
                );
              }
              return ListView.builder(
                padding: ResponsiveHelper.getPadding(context),
                itemCount: provider.orders.length,
                itemBuilder: (context, i) {
                  final order = provider.orders[i];
                  final date = DateFormat(
                    'MMM dd, yyyy',
                  ).format(order.createdAt);
                  return Card(
                    margin: const EdgeInsets.only(bottom: 12),
                    child: ListTile(
                      title: Text('Order ${order.orderId}'),
                      subtitle: Text(date),
                      trailing: Text(
                        order.status,
                        style: TextStyle(color: _getStatusColor(order.status)),
                      ),
                    ),
                  );
                },
              );
            },
          );
        },
      ),
    );
  }
}
