import 'package:flutter/material.dart';
import '../../../../core/localization/app_localizations.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_typography.dart';
import '../../../../core/widgets/glass_card.dart';
import '../../domain/entities/price_comparison_result.dart';

class BestDealBanner extends StatelessWidget {
  final PriceComparisonResult result;
  final String? currencySymbol;

  const BestDealBanner({
    super.key,
    required this.result,
    this.currencySymbol,
  });

  @override
  Widget build(BuildContext context) {
    final curr = currencySymbol ?? '\$';
    final l10n = context.l10n;

    if (result.hasMismatchedCategories) {
      return GlassCard(
        backgroundColor: AppColors.warning.withAlpha(20),
        borderColor: AppColors.warning.withAlpha(80),
        borderRadius: 18,
        padding: const EdgeInsets.all(16),
        child: Row(
          children: [
            const Icon(Icons.warning_amber_rounded, color: AppColors.warning, size: 24),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    l10n.mismatchedUnits,
                    style: AppTypography.titleMedium.copyWith(color: AppColors.warning),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    l10n.mismatchedUnitsDesc,
                    style: AppTypography.bodyMedium,
                  ),
                ],
              ),
            ),
          ],
        ),
      );
    }

    final best = result.bestDeal;
    if (best == null || best.price <= 0 || best.quantity <= 0) {
      return GlassCard(
        gradient: AppColors.heroCardGradient,
        borderRadius: 18,
        padding: const EdgeInsets.all(16),
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                color: AppColors.modulePriceCalc.withAlpha(30),
                borderRadius: BorderRadius.circular(12),
              ),
              child: const Icon(
                Icons.price_check_rounded,
                color: AppColors.modulePriceCalc,
                size: 24,
              ),
            ),
            const SizedBox(width: 14),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    l10n.enterPricesAndSizes,
                    style: AppTypography.titleMedium,
                  ),
                  const SizedBox(height: 2),
                  Text(
                    l10n.enterPricesAndSizesDesc,
                    style: AppTypography.bodyMedium,
                  ),
                ],
              ),
            ),
          ],
        ),
      );
    }

    final savings = result.maxSavingsPercentage;
    final localizedBestLabel = l10n.getLocalizedOptionLabel(best.label);

    return GlassCard(
      gradient: AppColors.priceCalcGradient,
      borderRadius: 20,
      padding: const EdgeInsets.all(20),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: Colors.white.withAlpha(30),
              shape: BoxShape.circle,
            ),
            child: const Icon(
              Icons.stars_rounded,
              color: Colors.white,
              size: 32,
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Text(
                      l10n.bestValueWinner,
                      style: AppTypography.badgeText.copyWith(color: Colors.white),
                    ),
                    if (savings > 0) ...[
                      const SizedBox(width: 8),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                        decoration: BoxDecoration(
                          color: AppColors.success,
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Text(
                          '${l10n.formatNumber(savings.toStringAsFixed(1))}% ${l10n.cheaper}',
                          style: AppTypography.badgeText.copyWith(
                            color: Colors.white,
                            fontSize: 9,
                          ),
                        ),
                      ),
                    ],
                  ],
                ),
                const SizedBox(height: 4),
                Text(
                  localizedBestLabel,
                  style: AppTypography.headlineMedium.copyWith(color: Colors.white),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: 2),
                Text(
                  '$curr${l10n.formatNumber(best.pricePerStandardUnit.toStringAsFixed(3))} ${l10n.getStandardUnitLabel(best.unit.category)}  ($curr${l10n.formatNumber(best.pricePerBulkUnit.toStringAsFixed(2))} ${l10n.getBulkUnitLabel(best.unit.category)})',
                  style: AppTypography.bodyMedium.copyWith(color: Colors.white70),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
