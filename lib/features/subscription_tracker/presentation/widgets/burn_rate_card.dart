import 'package:flutter/material.dart';
import '../../../../core/localization/app_localizations.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_typography.dart';
import '../../../../core/widgets/glass_card.dart';

class BurnRateCard extends StatelessWidget {
  final double monthlyBurn;
  final double yearlyBurn;
  final int activeCount;
  final int totalCount;
  final String? currencySymbol;

  const BurnRateCard({
    super.key,
    required this.monthlyBurn,
    required this.yearlyBurn,
    required this.activeCount,
    required this.totalCount,
    this.currencySymbol,
  });

  @override
  Widget build(BuildContext context) {
    final curr = currencySymbol ?? '\$';
    final l10n = context.l10n;

    return GlassCard(
      gradient: AppColors.subscriptionGradient,
      borderRadius: 20,
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                l10n.monthlyCashBurn,
                style: AppTypography.badgeText.copyWith(
                  color: Colors.white,
                  letterSpacing: 1.0,
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                decoration: BoxDecoration(
                  color: Colors.black26,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Text(
                  l10n.activeCount(activeCount, totalCount),
                  style: AppTypography.labelSmall.copyWith(
                    color: Colors.white,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 10),
          Text(
            l10n.formatCurrency(monthlyBurn, curr),
            style: AppTypography.displayLarge.copyWith(
              color: Colors.white,
              fontSize: 34,
            ),
          ),
          const SizedBox(height: 14),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
            decoration: BoxDecoration(
              color: Colors.white.withAlpha(25),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  l10n.projectedAnnualCost,
                  style: AppTypography.bodyMedium.copyWith(
                    color: Colors.white70,
                  ),
                ),
                Text(
                  l10n.formatYearlyBurn(yearlyBurn, curr),
                  style: AppTypography.titleMedium.copyWith(
                    color: Colors.white,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
