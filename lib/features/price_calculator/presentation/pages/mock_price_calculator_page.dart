import 'package:flutter/material.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_typography.dart';
import '../../../../core/widgets/custom_app_bar.dart';
import '../../../../core/widgets/glass_card.dart';

class MockPriceCalculatorPage extends StatelessWidget {
  const MockPriceCalculatorPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(
        title: 'Price Calculator',
        subtitle: 'Unit Price & Grocery Value',
        accentColor: AppColors.modulePriceCalc,
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
              gradient: AppColors.priceCalcGradient,
              borderRadius: 20,
              padding: const EdgeInsets.all(24),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'PHASE 2 MODULE',
                        style: AppTypography.badgeText.copyWith(
                          color: Colors.white,
                        ),
                      ),
                      const Icon(
                        Icons.calculate_rounded,
                        color: Colors.white,
                        size: 28,
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  Text(
                    'Smart Unit Price Calculator',
                    style: AppTypography.displayMedium.copyWith(color: Colors.white),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'Side-by-side product comparison normalizing grams, kilos, milliliters, liters, and pieces with Best Deal badges.',
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
              icon: Icons.compare_arrows_rounded,
              title: 'Multi-Item Comparison Grid',
              description: 'Compare up to 4 items simultaneously with mismatched packaging units.',
            ),
            _buildFeatureItem(
              icon: Icons.percent_rounded,
              title: 'Savings & Best Value Badges',
              description: 'Real-time calculation showing exact percentage saved on bulk vs retail.',
            ),
            _buildFeatureItem(
              icon: Icons.history_rounded,
              title: 'Quick Benchmark History',
              description: 'Save favorite grocery item benchmarks for offline price comparison.',
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
                color: AppColors.modulePriceCalc.withAlpha(30),
                borderRadius: BorderRadius.circular(10),
              ),
              child: Icon(icon, color: AppColors.modulePriceCalc, size: 20),
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
