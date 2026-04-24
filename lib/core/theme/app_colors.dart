import 'package:flutter/material.dart';

/// Central color definitions for the app
/// Supports both light and dark mode
abstract class AppColors {
  // Primary palette
  static const Color primary = Color(0xFF1B5E20);
  static const Color primaryLight = Color(0xFF4CAF50);
  static const Color primaryDark = Color(0xFF0A3D0E);

  // Secondary palette
  static const Color secondary = Color(0xFFF9A825);
  static const Color secondaryLight = Color(0xFFFFF176);
  static const Color secondaryDark = Color(0xFFC17900);

  // Neutral palette
  static const Color white = Color(0xFFFFFFFF);
  static const Color background = Color(0xFFF5F5F5);
  static const Color surface = Color(0xFFFFFFFF);
  static const Color grey50 = Color(0xFFFAFAFA);
  static const Color grey100 = Color(0xFFF5F5F5);
  static const Color grey200 = Color(0xFFEEEEEE);
  static const Color grey300 = Color(0xFFE0E0E0);
  static const Color grey400 = Color(0xFFBDBDBD);
  static const Color grey500 = Color(0xFF9E9E9E);
  static const Color grey600 = Color(0xFF757575);
  static const Color grey700 = Color(0xFF616161);
  static const Color grey800 = Color(0xFF424242);
  static const Color grey900 = Color(0xFF212121);

  // Semantic colors
  static const Color success = Color(0xFF4CAF50);
  static const Color error = Color(0xFFE53935);
  static const Color warning = Color(0xFFFFA726);
  static const Color info = Color(0xFF29B6F6);

  // Verification badge colors
  static const Color verifiedBadge = Color(0xFF4CAF50);
  static const Color communityTrustedBadge = Color(0xFF1565C0);
  static const Color unverifiedBadge = Color(0xFF9E9E9E);

  // Dark mode overrides
  static const Color darkBackground = Color(0xFF121212);
  static const Color darkSurface = Color(0xFF1E1E1E);
  static const Color darkCard = Color(0xFF2C2C2C);
  static const Color darkTextPrimary = Color(0xFFE0E0E0);
  static const Color darkTextSecondary = Color(0xFFB0B0B0);

  // Mosque markers
  static const Color markerVerified = Color(0xFF4CAF50);
  static const Color markerNormal = Color(0xFF1B5E20);
  static const Color markerSelected = Color(0xFFF9A825);
}
