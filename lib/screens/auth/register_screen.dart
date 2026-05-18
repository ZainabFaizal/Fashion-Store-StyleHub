// screens/register_screen.dart
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../providers/auth_provider.dart';
import '../../providers/cart_provider.dart';
import '../../theme/app_theme.dart';
import '../../widgets/custom_button.dart';
import '../../utils/responsive_helper.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final _name = TextEditingController();
  final _email = TextEditingController();
  final _phone = TextEditingController();
  final _password = TextEditingController();
  final _confirm = TextEditingController();
  bool _obscure1 = true;
  bool _obscure2 = true;

  @override
  void dispose() {
    _name.dispose();
    _email.dispose();
    _phone.dispose();
    _password.dispose();
    _confirm.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          Container(
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                colors: [Color(0xFF1A1A2E), Color(0xFF16213E), Color(0xFF0F3460)],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
            ),
          ),
          // Register Form Content
          Center(
            child: ConstrainedBox(
              constraints: BoxConstraints(
                maxWidth: ResponsiveHelper.isMobile(context)
                    ? double.infinity
                    : 500,
              ),
              child: SingleChildScrollView(
                padding: ResponsiveHelper.getPadding(context),
                child: Card(
                  color: Colors.black.withValues(alpha: 0.4),
                  elevation: 6,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: Padding(
                    padding: ResponsiveHelper.getPadding(context),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(
                          'Create Account',
                          style: TextStyle(
                            fontSize: ResponsiveHelper.getFontSize(context, 26),
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                        ),
                        const SizedBox(height: 24),
                        _input(_name, 'Full Name', Icons.person_outline),
                        _input(_email, 'Email', Icons.email_outlined),
                        _input(_phone, 'Phone', Icons.phone_outlined),
                        _passwordField(
                          _password,
                          'Password',
                          _obscure1,
                          () => setState(() => _obscure1 = !_obscure1),
                        ),
                        _passwordField(
                          _confirm,
                          'Confirm Password',
                          _obscure2,
                          () => setState(() => _obscure2 = !_obscure2),
                        ),
                        const SizedBox(height: 24),
                        Consumer<AuthProvider>(
                          builder: (context, auth, _) {
                            return CustomButton(
                              label: 'Register',
                              isLoading: auth.isLoading,
                              width: double.infinity,
                              onPressed: () async {
                                if (_password.text != _confirm.text) {
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    const SnackBar(
                                      content: Text('Passwords do not match'),
                                      backgroundColor: Colors.red,
                                    ),
                                  );
                                  return;
                                }

                                final cartProvider =
                                    context.read<CartProvider>();
                                final navigator = Navigator.of(context);
                                final messenger =
                                    ScaffoldMessenger.of(context);

                                final success = await auth.register(
                                  name: _name.text,
                                  email: _email.text,
                                  password: _password.text,
                                  confirmPassword: _confirm.text,
                                  phone: _phone.text,
                                );

                                if (!mounted) return;

                                if (success) {
                                  final uid = auth.user!.uid;
                                  await cartProvider.setUser(uid);
                                  navigator.pushReplacementNamed('/main');
                                } else if (auth.errorMessage != null) {
                                  messenger.showSnackBar(
                                    SnackBar(
                                      content: Text(auth.errorMessage!),
                                      backgroundColor: Colors.red,
                                    ),
                                  );
                                }
                              },
                            );
                          },
                        ),
                        const SizedBox(height: 20),
                        GestureDetector(
                          onTap: () => Navigator.pop(context),
                          child: const Text(
                            'Already have an account? Login',
                            style: TextStyle(
                              color: AppTheme.kGold,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _input(TextEditingController c, String label, IconData icon) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: TextField(
        controller: c,
        style: const TextStyle(color: Colors.white),
        decoration: InputDecoration(
          labelText: label,
          labelStyle: const TextStyle(color: Colors.white70),
          prefixIcon: Icon(icon, color: Colors.white70),
          filled: true,
          fillColor: Colors.white.withValues(alpha: 0.1),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: const BorderSide(color: Colors.white38),
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: const BorderSide(color: Colors.white38),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: const BorderSide(color: AppTheme.kGold),
          ),
        ),
      ),
    );
  }

  Widget _passwordField(
    TextEditingController c,
    String label,
    bool obscure,
    VoidCallback toggle,
  ) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: TextField(
        controller: c,
        obscureText: obscure,
        style: const TextStyle(color: Colors.white),
        decoration: InputDecoration(
          labelText: label,
          labelStyle: const TextStyle(color: Colors.white70),
          prefixIcon: const Icon(Icons.lock_outline, color: Colors.white70),
          suffixIcon: IconButton(
            icon: Icon(
              obscure ? Icons.visibility_off : Icons.visibility,
              color: Colors.white70,
            ),
            onPressed: toggle,
          ),
          filled: true,
          fillColor: Colors.white.withValues(alpha: 0.1),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: const BorderSide(color: Colors.white38),
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: const BorderSide(color: Colors.white38),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: const BorderSide(color: AppTheme.kGold),
          ),
        ),
      ),
    );
  }
}
