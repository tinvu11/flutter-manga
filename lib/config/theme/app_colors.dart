import 'package:flutter/material.dart';

class AppColors {
  // Light Theme Colors
  static const Color lightPrimary = Color(0xFF2196F3);
  static const Color lightPrimaryVariant = Color(0xFF1976D2);
  static const Color lightSecondary = Color(0xFF4CAF50);
  static const Color lightSecondaryVariant = Color(0xFF388E3C);
  static const Color lightBackground = Color(0xFFFAFAFA);
  static const Color lightSurface = Color(0xFFFFFFFF);
  static const Color lightError = Color(0xFFE53935);
  static const Color lightOnPrimary = Colors.white;
  static const Color lightOnSecondary = Colors.white;
  static const Color lightOnBackground = Color(0xFF1C1C1C);
  static const Color lightOnSurface = Color(0xFF1C1C1C);
  static const Color lightOnError = Colors.white;

  // Dark Theme Colors
  static const Color darkPrimary = Color(0xFF4CAF50);
  static const Color darkSecondary = Color.fromARGB(255, 46, 46, 46);
  static const Color darkSurface = Color(0xFF1E1E1E); // nhẹ hơn đen để phân lớp
  static const Color darkError = Color(0xFFED6B69);
  static const Color darkOnPrimary = Colors.white; // Đổi từ xám sang trắng
  static const Color darkOnSecondary = Color(0xFFF5F5F5);
  static const Color darkOnBackground = Color(0xFFE0E0E0);
  static const Color darkOnSurface = Color(0xFFE0E0E0);
  static const Color darkOnError = Colors.white; // Đổi từ xám sang trắng

  // Gradient Colors
  static const List<Color> primaryGradient = [Color(0xFF81C784), Color(0xFF4CAF50), Color(0xFF388E3C)];

  static const List<Color> secondaryGradient = [Color(0xFF64B5F6), Color(0xFF2196F3), Color(0xFF1976D2)];

  // Gray Scale
  static const Color gray50 = Color(0xFFFAFAFA);
  static const Color gray100 = Color(0xFFF5F5F5);
  static const Color gray200 = Color(0xFFEEEEEE);
  static const Color gray300 = Color(0xFFE0E0E0);
  static const Color gray400 = Color(0xFFBDBDBD);
  static const Color gray500 = Color(0xFF9E9E9E);
  static const Color gray600 = Color(0xFF757575);
  static const Color gray700 = Color(0xFF616161);
  static const Color gray800 = Color(0xFF424242);
  static const Color gray900 = Color(0xFF212121);

  // Comic specific colors
  static const Color ratingYellow = Color(0xFFFFC107);
  static const Color likeBlue = Color(0xFF2196F3);
  static const Color dislikeRed = Color(0xFFE53935);
  static const Color bookmarkOrange = Color(0xFFFF9800);

  // Status colors
  static const Color success = Color(0xFF4CAF50);
  static const Color warning = Color(0xFFFF9800);
  static const Color info = Color(0xFF2196F3);
  static const Color danger = Color(0xFFE53935);
}
