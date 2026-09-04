import 'package:flutter/material.dart';

/// Central color token registry for the DailyPouch design system.
/// Styled with a modern, friendly cream-white aesthetic and soft pastel cards inspired by reference UI.
abstract class AppColors {
  // Base Surface & Background (Cream White Vibe)
  static const Color background = Color(0xFFF7F6F2); // Warm Cream White
  static const Color surface = Color(0xFFFFFFFF); // Pure White
  static const Color surfaceElevated = Color(0xFFFFFFFF);
  static const Color surfaceCard = Color(0xFFFFFFFF);
  static const Color cardBorder = Color(0xFFE5E5EB);
  static const Color cardBorderHover = Color(0xFF3B82F6);

  // Text Colors (Light / Cream Mode Base)
  static const Color textPrimary = Color(0xFF19191D);
  static const Color textSecondary = Color(0xFF5A5A62);
  static const Color textMuted = Color(0xFF8E8E93);

  // Status & System Accents
  static const Color primary = Color(0xFF2563EB); // Deep Royal Blue
  static const Color primaryLight = Color(0xFF3B82F6);
  static const Color accent = Color(0xFF6366F1);
  static const Color success = Color(0xFF10B981);
  static const Color warning = Color(0xFFF59E0B);
  static const Color error = Color(0xFFEF4444);

  // 6 Utility Module Accent Colors
  static const Color moduleSubscription = Color(0xFFE11D48); // Rose Crimson
  static const Color modulePriceCalc = Color(0xFFEA580C); // Tangerine Orange
  static const Color modulePantry = Color(0xFFD97706); // Honey Amber
  static const Color moduleCompressor = Color(0xFFDC2626); // Red Coral
  static const Color moduleBudgeter = Color(0xFF059669); // Emerald Cash
  static const Color moduleTimer = Color(0xFF7C3AED); // Deep Violet

  // -------------------------------------------------------------
  // Reference UI Pastel Card Colors & Gradients (from docs/ui.PNG)
  // -------------------------------------------------------------
  static const Color cardTextPrimary = Color(0xFF19191D);
  static const Color cardTextSecondary = Color(0xFF3C3C43);
  static const Color cardTextMuted = Color(0xFF636366);
  static const Color cardInfoButtonBg = Color(0x3DFFFFFF);
  static const Color cardInfoButtonBorder = Color(0x24000000);

  // Card 1: Soft Rose / Coral Pastel (Subscription Tracker)
  static const LinearGradient pastelSubscriptionCard = LinearGradient(
    colors: [Color(0xFFFFDFE7), Color(0xFFFFF2F5)],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  // Card 2: Soft Peach / Orange Pastel (Smart Price Calculator)
  static const LinearGradient pastelPriceCalcCard = LinearGradient(
    colors: [Color(0xFFFFDFCA), Color(0xFFFFF2E6)],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  // Card 3: Sunny Yellow / Cream Pastel (Pantry & Medicine Expiry)
  static const LinearGradient pastelPantryCard = LinearGradient(
    colors: [Color(0xFFFFF2A8), Color(0xFFFFFCE3)],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  // Card 4: Apricot / Warm Coral Pastel (Image Compressor & PDF)
  static const LinearGradient pastelCompressorCard = LinearGradient(
    colors: [Color(0xFFFFDBC8), Color(0xFFFFF0E4)],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  // Card 5: Mint / Seafoam Pastel (Micro Budgeter Runway)
  static const LinearGradient pastelBudgeterCard = LinearGradient(
    colors: [Color(0xFFC8F5DC), Color(0xFFE8FAF1)],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  // Card 6: Lavender / Periwinkle Pastel (Interval & Rest Timer)
  static const LinearGradient pastelTimerCard = LinearGradient(
    colors: [Color(0xFFE2DCFC), Color(0xFFF3F0FD)],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  // Module Accent Gradients
  static const LinearGradient primaryGradient = LinearGradient(
    colors: [Color(0xFF2563EB), Color(0xFF6366F1)],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  static const LinearGradient subscriptionGradient = LinearGradient(
    colors: [Color(0xFFE11D48), Color(0xFFFB7185)],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  static const LinearGradient priceCalcGradient = LinearGradient(
    colors: [Color(0xFFEA580C), Color(0xFFFB923C)],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  static const LinearGradient pantryGradient = LinearGradient(
    colors: [Color(0xFFD97706), Color(0xFFFBBF24)],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  static const LinearGradient compressorGradient = LinearGradient(
    colors: [Color(0xFFDC2626), Color(0xFFF87171)],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  static const LinearGradient budgeterGradient = LinearGradient(
    colors: [Color(0xFF059669), Color(0xFF34D399)],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  static const LinearGradient timerGradient = LinearGradient(
    colors: [Color(0xFF7C3AED), Color(0xFFA78BFA)],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  static const LinearGradient heroCardGradient = LinearGradient(
    colors: [Color(0xFFFFFFFF), Color(0xFFF3F4F6)],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );
}
