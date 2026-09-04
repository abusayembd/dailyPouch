import 'package:flutter/material.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_typography.dart';
import '../../../../core/widgets/custom_app_bar.dart';
import '../../../../core/widgets/glass_card.dart';

class MockPantryExpiryPage extends StatelessWidget {
  const MockPantryExpiryPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(
        title: 'Pantry & Expiry',
        subtitle: 'Food & Medicine Shelf-Life Tracker',
        accentColor: AppColors.modulePantry,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new_rounded),
          onPressed: () => Navigator.of(context).pop(),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            GlassCard(
              gradient: AppColors.pantryGradient,
              borderRadius: 20,
              padding: const EdgeInsets.all(24),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'PHASE 3 MODULE',
                        style: AppTypography.badgeText.copyWith(color: Colors.white),
                      ),
                      const Icon(
                        Icons.inventory_2_rounded,
                        color: Colors.white,
                        size: 28,
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  Text(
                    'Pantry & Medicine Expiry',
                    style: AppTypography.displayMedium.copyWith(color: Colors.white),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'Barcode scanning, multi-zone classification (Fridge, Freezer, Pantry, Medicine Kit), and color-coded freshness badges.',
                    style: AppTypography.bodyLarge.copyWith(color: Colors.white.withAlpha(220)),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 24),
            Text(
              'Planned Architecture Features',
              style: AppTypography.headlineMedium,
            ),
            const SizedBox(height: 12),
            _buildFeatureItem(
              icon: Icons.qr_code_scanner_rounded,
              title: 'Barcode Scanner Integration',
              description: 'Quick product capture with manual override and category tagging.',
            ),
            _buildFeatureItem(
              icon: Icons.kitchen_rounded,
              title: 'Zone Management',
              description: 'Filter items into Fridge, Freezer, Dry Pantry, or Medicine Cabinet.',
            ),
            _buildFeatureItem(
              icon: Icons.alarm_on_rounded,
              title: 'Proactive Expiration Alerts',
              description: 'Notifications before items spoil to prevent food waste and expired meds.',
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildFeatureItem({
    required IconData icon,
    required String title,
    required String description,
  }) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: GlassCard(
        borderColor: AppColors.cardBorder,
        borderRadius: 14,
        padding: const EdgeInsets.all(16),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: AppColors.modulePantry.withAlpha(30),
                borderRadius: BorderRadius.circular(10),
              ),
              child: Icon(icon, color: AppColors.modulePantry, size: 20),
            ),
            const SizedBox(width: 14),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(title, style: AppTypography.titleMedium),
                  const SizedBox(height: 4),
                  Text(description, style: AppTypography.bodyMedium),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
