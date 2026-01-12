import 'package:flutter/material.dart';

/// Application color palette
/// Designed for accessibility with WCAG AA contrast ratios
class AppColors {
  // Primary colors
  static const Color primary = Color(0xFF1976D2); // Blue
  static const Color primaryDark = Color(0xFF004BA0);
  static const Color primaryLight = Color(0xFF63A4FF);

  // Secondary colors
  static const Color secondary = Color(0xFFFFC107); // Amber
  static const Color secondaryDark = Color(0xFFC79100);

  // Metro line colors
  static const Color redLine = Color(0xFFE53935);
  static const Color blueLine = Color(0xFF1E88E5);
  static const Color yellowLine = Color(0xFFFDD835);
  static const Color greenLine = Color(0xFF43A047);
  static const Color violetLine = Color(0xFF8E24AA);
  static const Color pinkLine = Color(0xFFEC407A);
  static const Color magentaLine = Color(0xFFD81B60);
  static const Color greyLine = Color(0xFF757575);

  // UI colors
  static const Color background = Color(0xFFF5F5F5);
  static const Color surface = Color(0xFFFFFFFF);
  static const Color error = Color(0xFFD32F2F);
  static const Color success = Color(0xFF388E3C);
  static const Color warning = Color(0xFFF57C00);
  static const Color info = Color(0xFF0288D1);

  // Text colors
  static const Color textPrimary = Color(0xFF212121);
  static const Color textSecondary = Color(0xFF757575);
  static const Color textHint = Color(0xFFBDBDBD);
  static const Color textOnPrimary = Color(0xFFFFFFFF);

  // Semantic colors
  static const Color interchangeStation = Color(0xFFFF6F00);
  static const Color activeTicket = Color(0xFF4CAF50);
  static const Color expiredTicket = Color(0xFF9E9E9E);

  /// Get metro line color by code
  static Color getLineColor(String lineCode) {
    switch (lineCode.toUpperCase()) {
      case 'RL':
        return redLine;
      case 'BL':
        return blueLine;
      case 'YL':
        return yellowLine;
      case 'GL':
        return greenLine;
      case 'VL':
        return violetLine;
      case 'PL':
        return pinkLine;
      case 'ML':
        return magentaLine;
      case 'GRL':
        return greyLine;
      default:
        return primary;
    }
  }
}