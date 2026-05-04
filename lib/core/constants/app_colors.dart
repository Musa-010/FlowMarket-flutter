import 'package:flutter/material.dart';

class AppColors {
  AppColors._();

  // Primary Brand — lavender/violet
  static const primary = Color(0xFFCEBDFF);
  static const primaryDark = Color(0xFF8B5CF6);
  static const primaryLight = Color(0xFF3C1989);

  // Container accent
  static const primaryContainer = Color(0xFFA78BFA);

  // Secondary — teal
  static const accent = Color(0xFF4DDCC6);
  static const accentLight = Color(0xFF1A4D47);

  // Gradient endpoints
  static const gradientStart = Color(0xFF8B5CF6);
  static const gradientEnd = Color(0xFFD946EF);

  // Pink / warning
  static const warning = Color(0xFFFFAFD3);
  static const warningLight = Color(0xFF4A1A2E);

  // Error
  static const error = Color(0xFFFFB4AB);
  static const errorLight = Color(0xFF93000A);

  // Background / surface — always dark glass
  static const background = Color(0xFF101415);
  static const surface = Color(0xFF1A1D27);
  static const surfaceVariant = Color(0xFF252836);
  static const surfaceGlass = Color(0x0FFFFFFF); // ~6% white

  // Borders
  static const border = Color(0x14FFFFFF);       // ~8% white
  static const borderDark = Color(0x1AFFFFFF);   // ~10% white

  // Text
  static const textPrimary = Color(0xFFFFFFFF);
  static const textSecondary = Color(0xCCFFFFFF); // 80%
  static const textTertiary = Color(0x80FFFFFF);  // 50%
  static const textDisabled = Color(0x40FFFFFF);  // 25%

  // Dark mode aliases (same values — app is always dark)
  static const backgroundDark = background;
  static const surfaceDark = surface;
  static const surfaceVariantDark = surfaceVariant;
  static const borderDarkMode = border;
  static const textPrimaryDark = textPrimary;
  static const textSecondaryDark = textSecondary;
  static const textTertiaryDark = textTertiary;

  // Category accent colors
  static const categoryEmail = Color(0xFF4DDCC6);
  static const categoryLead = Color(0xFF8B5CF6);
  static const categoryCRM = Color(0xFFFFAFD3);
  static const categorySocial = Color(0xFFD946EF);
  static const categoryInvoice = Color(0xFFCEBDFF);
  static const categoryEcom = Color(0xFF4DDCC6);
  static const categoryReport = Color(0xFFA78BFA);
  static const categoryNotif = Color(0xFFFFAFD3);
  static const categoryCustom = Color(0xFF8B5CF6);

  // Glow blobs
  static const blobTopLeft = Color(0xFF3C1989);
  static const blobBottomRight = Color(0xFF6A0045);
}
