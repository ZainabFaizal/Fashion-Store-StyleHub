import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../providers/auth_provider.dart';
import '../../providers/cart_provider.dart';
import '../../theme/app_theme.dart';
import '../../utils/responsive_helper.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final user = context.watch<AuthProvider>().user;

    return Scaffold(
      appBar: AppBar(title: const Text('My Profile')),
      body: user == null
          ? const Center(child: Text('Please login to view profile'))
          : Center(
              child: ConstrainedBox(
                constraints: BoxConstraints(
                  maxWidth: ResponsiveHelper.isDesktop(context)
                      ? 600
                      : double.infinity,
                ),
                child: SingleChildScrollView(
                  padding: ResponsiveHelper.getPadding(context),
                  child: Column(
                    children: [
                      const SizedBox(height: 24),
                      CircleAvatar(
                        radius: 50,
                        backgroundColor: AppTheme.kGold,
                        child: Text(
                          user.initials,
                          style: const TextStyle(
                            color: AppTheme.kDark,
                            fontSize: 28,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                      const SizedBox(height: 16),
                      Text(
                        user.name,
                        style: const TextStyle(
                          fontSize: 22,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 6),
                      Text(
                        user.email,
                        style: const TextStyle(
                          fontSize: 14,
                          color: AppTheme.kGray,
                        ),
                      ),
                      const SizedBox(height: 28),
                      Card(
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Padding(
                          padding: const EdgeInsets.all(16),
                          child: Column(
                            children: [
                              _infoRow(
                                Icons.phone_outlined,
                                'Phone',
                                user.phone.isEmpty ? 'Not set' : user.phone,
                              ),
                              const Divider(height: 24),
                              _infoRow(
                                Icons.location_on_outlined,
                                'Address',
                                user.address.isEmpty
                                    ? 'Not set'
                                    : user.address,
                              ),
                            ],
                          ),
                        ),
                      ),
                      const SizedBox(height: 16),
                      _menuTile(
                        context,
                        icon: Icons.edit_outlined,
                        label: 'Edit Profile',
                        onTap: () =>
                            Navigator.pushNamed(context, '/edit-profile'),
                      ),
                      _menuTile(
                        context,
                        icon: Icons.shopping_bag_outlined,
                        label: 'My Orders',
                        onTap: () => Navigator.pushNamed(context, '/orders'),
                      ),
                      const SizedBox(height: 16),
                      SizedBox(
                        width: double.infinity,
                        child: OutlinedButton.icon(
                          icon: const Icon(Icons.logout, color: AppTheme.kRed),
                          label: const Text(
                            'Logout',
                            style: TextStyle(color: AppTheme.kRed),
                          ),
                          style: OutlinedButton.styleFrom(
                            side: const BorderSide(color: AppTheme.kRed),
                            padding: const EdgeInsets.symmetric(vertical: 14),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                          ),
                          onPressed: () async {
                            final cartProvider = context.read<CartProvider>();
                            final authProvider = context.read<AuthProvider>();
                            final navigator = Navigator.of(context);

                            await authProvider.logout();
                            await cartProvider.setUser(null);

                            navigator.pushNamedAndRemoveUntil(
                              '/login',
                              (route) => false,
                            );
                          },
                        ),
                      ),
                      const SizedBox(height: 24),
                    ],
                  ),
                ),
              ),
            ),
    );
  }

  Widget _infoRow(IconData icon, String label, String value) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Icon(icon, color: AppTheme.kGold, size: 20),
        const SizedBox(width: 12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                label,
                style: const TextStyle(color: AppTheme.kGray, fontSize: 12),
              ),
              const SizedBox(height: 4),
              Text(value, style: const TextStyle(fontWeight: FontWeight.w500)),
            ],
          ),
        ),
      ],
    );
  }

  Widget _menuTile(
    BuildContext context, {
    required IconData icon,
    required String label,
    required VoidCallback onTap,
  }) {
    return Card(
      margin: const EdgeInsets.only(bottom: 8),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: ListTile(
        leading: Icon(icon, color: AppTheme.kDark),
        title: Text(label),
        trailing: const Icon(Icons.chevron_right, color: AppTheme.kGray),
        onTap: onTap,
      ),
    );
  }
}
