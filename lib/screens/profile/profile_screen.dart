// screens/profile_screen.dart
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../providers/auth_provider.dart';
import '../../theme/app_theme.dart';
import '../../utils/responsive_helper.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final user = context.watch<AuthProvider>().user;

    return Scaffold(
      appBar: AppBar(title: const Text('My Profile')),
      body: Center(
        child: ConstrainedBox(
          constraints: BoxConstraints(
            maxWidth: ResponsiveHelper.isDesktop(context)
                ? 600
                : double.infinity,
          ),
          child: Padding(
            padding: ResponsiveHelper.getPadding(context),
            child: user == null
                ? const Center(child: Text('No user data'))
                : Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      CircleAvatar(
                        radius: ResponsiveHelper.getValue(
                          context: context,
                          mobile: 40,
                          tablet: 50,
                          desktop: 60,
                        ),
                        backgroundColor: AppTheme.kGold,
                        child: Text(
                          user.initials,
                          style: TextStyle(
                            color: AppTheme.kDark,
                            fontSize: ResponsiveHelper.getFontSize(context, 24),
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                      SizedBox(
                        height: ResponsiveHelper.getValue(
                          context: context,
                          mobile: 16,
                          tablet: 20,
                          desktop: 24,
                        ),
                      ),
                      Text(
                        user.name,
                        style: TextStyle(
                          fontSize: ResponsiveHelper.getFontSize(context, 20),
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      SizedBox(
                        height: ResponsiveHelper.getValue(
                          context: context,
                          mobile: 8,
                          tablet: 12,
                          desktop: 16,
                        ),
                      ),
                      Text(
                        user.email,
                        style: TextStyle(
                          fontSize: ResponsiveHelper.getFontSize(context, 16),
                        ),
                      ),
                      SizedBox(
                        height: ResponsiveHelper.getValue(
                          context: context,
                          mobile: 8,
                          tablet: 12,
                          desktop: 16,
                        ),
                      ),
                      Text(
                        user.phone,
                        style: TextStyle(
                          fontSize: ResponsiveHelper.getFontSize(context, 16),
                        ),
                      ),
                      SizedBox(
                        height: ResponsiveHelper.getValue(
                          context: context,
                          mobile: 24,
                          tablet: 32,
                          desktop: 40,
                        ),
                      ),
                      SizedBox(
                        width: ResponsiveHelper.isDesktop(context)
                            ? 300
                            : double.infinity,
                        child: ElevatedButton(
                          onPressed: () {
                            context.read<AuthProvider>().logout();
                            Navigator.pushNamedAndRemoveUntil(
                              context,
                              '/login',
                              (route) => false,
                            );
                          },
                          child: const Text('Logout'),
                        ),
                      ),
                    ],
                  ),
          ),
        ),
      ),
    );
  }
}
