import 'package:flutter/material.dart';
import '../theme/app_theme.dart';

class CustomButton extends StatelessWidget {
  final String label;
  final VoidCallback onPressed;
  final bool isLoading;
  final ButtonVariant variant;
  final double? width;
  final double? height;
  final IconData? icon;

  const CustomButton({
    super.key,
    required this.label,
    required this.onPressed,
    this.isLoading = false,
    this.variant = ButtonVariant.filled,
    this.width,
    this.height,
    this.icon,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: width,
      height: height ?? 48,
      child: _buildButton(context),
    );
  }

  Widget _buildButton(BuildContext context) {
    if (variant == ButtonVariant.filled) {
      return ElevatedButton.icon(
        onPressed: isLoading ? null : onPressed,
        icon: isLoading
            ? SizedBox(
                width: 20,
                height: 20,
                child: CircularProgressIndicator(
                  strokeWidth: 2,
                  valueColor: AlwaysStoppedAnimation<Color>(Colors.grey[600]!),
                ),
              )
            : (icon != null ? Icon(icon) : const SizedBox.shrink()),
        label: isLoading
            ? const SizedBox.shrink()
            : Text(label, style: const TextStyle(fontWeight: FontWeight.w600)),
        style: ElevatedButton.styleFrom(
          backgroundColor: AppTheme.kDark,
          foregroundColor: AppTheme.kWhite,
          disabledBackgroundColor: Colors.grey[400],
        ),
      );
    } else if (variant == ButtonVariant.outlined) {
      return OutlinedButton.icon(
        onPressed: isLoading ? null : onPressed,
        icon: isLoading
            ? const SizedBox(
                width: 20,
                height: 20,
                child: CircularProgressIndicator(
                  strokeWidth: 2,
                  valueColor: AlwaysStoppedAnimation<Color>(AppTheme.kDark),
                ),
              )
            : (icon != null ? Icon(icon) : const SizedBox.shrink()),
        label: isLoading
            ? const SizedBox.shrink()
            : Text(label, style: const TextStyle(fontWeight: FontWeight.w600)),
        style: OutlinedButton.styleFrom(
          foregroundColor: AppTheme.kDark,
          disabledForegroundColor: Colors.grey[400],
          side: BorderSide(
            color: isLoading ? Colors.grey[400]! : AppTheme.kDark,
          ),
        ),
      );
    } else {
      return TextButton(
        onPressed: isLoading ? null : onPressed,
        child: isLoading
            ? const SizedBox(
                width: 20,
                height: 20,
                child: CircularProgressIndicator(
                  strokeWidth: 2,
                  valueColor: AlwaysStoppedAnimation<Color>(AppTheme.kDark),
                ),
              )
            : Text(label, style: const TextStyle(fontWeight: FontWeight.w600)),
      );
    }
  }
}

enum ButtonVariant { filled, outlined, text }
