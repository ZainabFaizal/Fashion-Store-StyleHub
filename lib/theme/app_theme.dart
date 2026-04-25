import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class AppTheme {
  static const Color kDark = Color(0xFF1A1A1A);
  static const Color kGold = Color(0xFFC9A84C);
  static const Color kBg = Color(0xFFF7F5F1);
  static const Color kWhite = Color(0xFFFFFFFF);
  static const Color kGray = Color(0xFF888888);
  static const Color kLightGray = Color(0xFFEEEEEE);
  static const Color kRed = Color(0xFFD32F2F);
  static const Color kGreen = Color(0xFF4CAF50);

  static ThemeData get lightTheme {
    return ThemeData(
      useMaterial3: true,
      scaffoldBackgroundColor: kBg,
      textTheme: GoogleFonts.poppinsTextTheme(),

      // ✅ ADDED: Global Button Styling (Gold Background, Dark Text)
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: kGold,
          foregroundColor: kDark, // Text color
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
          padding: const EdgeInsets.symmetric(vertical: 12),
          elevation: 2,
        ),
      ),

      cardTheme: CardThemeData(
        color: kWhite,
        elevation: 2,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
      ),

      dialogTheme: DialogThemeData(
        backgroundColor: kWhite,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      ),
    );
  }
}
