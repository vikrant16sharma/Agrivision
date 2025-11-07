import 'package:flutter/material.dart';

class AppColors {
  // Primary Colors - Agricultural Green Theme
  static const Color primary = Color(0xFF16A34A); // green-600
  static const Color primaryDark = Color(0xFF15803D); // green-700
  static const Color primaryLight = Color(0xFF22C55E); // green-500
  static const Color primaryLighter = Color(0xFF4ADE80); // green-400

  // Secondary Colors
  static const Color secondary = Color(0xFF059669); // emerald-600
  static const Color secondaryDark = Color(0xFF047857); // emerald-700

  // Accent Colors
  static const Color accent = Color(0xFF3B82F6); // blue-500
  static const Color accentDark = Color(0xFF2563EB); // blue-600

  // Status Colors
  static const Color success = Color(0xFF10B981); // green-500
  static const Color warning = Color(0xFFF59E0B); // amber-500
  static const Color error = Color(0xFFEF4444); // red-500
  static const Color info = Color(0xFF3B82F6); // blue-500

  // Urgency Colors (for disease severity)
  static const Color urgencyHigh = Color(0xFFEF4444); // red-500
  static const Color urgencyMedium = Color(0xFFF59E0B); // amber-500
  static const Color urgencyLow = Color(0xFF10B981); // green-500

  // Background Colors
  static const Color backgroundLight = Color(0xFFF9FAFB); // gray-50
  static const Color backgroundWhite = Color(0xFFFFFFFF);
  static const Color backgroundGray = Color(0xFFF3F4F6); // gray-100

  // Surface Colors
  static const Color surface = Color(0xFFFFFFFF);
  static const Color surfaceVariant = Color(0xFFF3F4F6); // gray-100

  // Text Colors
  static const Color textPrimary = Color(0xFF111827); // gray-900
  static const Color textSecondary = Color(0xFF6B7280); // gray-500
  static const Color textTertiary = Color(0xFF9CA3AF); // gray-400
  static const Color textOnPrimary = Color(0xFFFFFFFF);

  // Border Colors
  static const Color border = Color(0xFFE5E7EB); // gray-200
  static const Color borderDark = Color(0xFFD1D5DB); // gray-300

  // Gradient Colors
  static const LinearGradient primaryGradient = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [
      Color(0xFF16A34A), // green-600
      Color(0xFF059669), // emerald-600
    ],
  );

  static const LinearGradient accentGradient = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [
      Color(0xFF3B82F6), // blue-500
      Color(0xFF2563EB), // blue-600
    ],
  );

  static const LinearGradient backgroundGradient = LinearGradient(
    begin: Alignment.topCenter,
    end: Alignment.bottomCenter,
    colors: [
      Color(0xFFF0FDF4), // green-50
      Color(0xFFFFFFFF), // white
    ],
  );

  // Category Colors
  static const Color categoryFungal = Color(0xFFDC2626); // red-600
  static const Color categoryBacterial = Color(0xFFEA580C); // orange-600
  static const Color categoryViral = Color(0xFF9333EA); // purple-600
  static const Color categoryHealthy = Color(0xFF16A34A); // green-600

  // Chart Colors
  static const List<Color> chartColors = [
    Color(0xFF16A34A), // green-600
    Color(0xFF3B82F6), // blue-500
    Color(0xFFF59E0B), // amber-500
    Color(0xFF8B5CF6), // violet-500
    Color(0xFFEC4899), // pink-500
    Color(0xFF06B6D4), // cyan-500
  ];

  // Shadow Colors
  static const Color shadowLight = Color(0x0A000000); // 4% black
  static const Color shadowMedium = Color(0x14000000); // 8% black
  static const Color shadowDark = Color(0x1F000000); // 12% black

  // Opacity variations
  static Color withOpacity(Color color, double opacity) {
    return color.withOpacity(opacity);
  }
}
