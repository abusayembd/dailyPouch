import 'package:flutter/material.dart';
import '../../../../core/localization/app_localizations.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_typography.dart';
import '../../../../core/widgets/glass_card.dart';
import '../../domain/entities/budget_envelope_entity.dart';

class RunwayGaugeCard extends StatelessWidget {
  final BudgetEnvelopeEntity envelope;
  final String? currencySymbol;

  const RunwayGaugeCard({
    super.key,
    required this.envelope,
    this.currencySymbol,
  });

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final progress = envelope.burnProgressPercentage;
    final remaining = envelope.remainingAmount;
    final daily = envelope.dailyRunwayAllowance;
    final days = envelope.remainingDays;
    final curr = currencySymbol ?? envelope.currency;

    final isOverBudget = remaining < 0;
    final daysStr = l10n.formatNumber(days.toString());
    final dailyStr = l10n.formatNumber(daily.toStringAsFixed(2));
    final spentStr = l10n.formatNumber(envelope.spentAmount.toStringAsFixed(2));
    final targetStr = l10n.formatNumber(envelope.targetAmount.toStringAsFixed(2));

    return GlassCard(
      gradient: isOverBudget ? null : AppColors.budgeterGradient,
      backgroundColor: isOverBudget ? AppColors.error.withAlpha(40) : null,
      borderColor: isOverBudget ? AppColors.error : AppColors.moduleBudgeter.withAlpha(80),
      borderRadius: 20,
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                l10n.dailyRunway,
                style: AppTypography.badgeText.copyWith(color: Colors.white),
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                decoration: BoxDecoration(
                  color: Colors.black26,
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Text(
                  '$daysStr ${l10n.daysLeft}',
                  style: AppTypography.badgeText.copyWith(color: Colors.white),
                ),
              ),
            ],
          ),
          const SizedBox(height: 10),

          // Daily Allowance Header
          Row(
            crossAxisAlignment: CrossAxisAlignment.baseline,
            textBaseline: TextBaseline.alphabetic,
            children: [
              Text(
                '$curr$dailyStr',
                style: AppTypography.displayLarge.copyWith(color: Colors.white, fontSize: 34),
              ),
              const SizedBox(width: 6),
              Text(
                l10n.safeToSpend,
                style: AppTypography.bodyMedium.copyWith(color: Colors.white70),
              ),
            ],
          ),
          const SizedBox(height: 14),

          // Progress Bar
          ClipRRect(
            borderRadius: BorderRadius.circular(8),
            child: LinearProgressIndicator(
              value: progress.clamp(0.0, 1.0),
              minHeight: 10,
              backgroundColor: Colors.white24,
              valueColor: AlwaysStoppedAnimation<Color>(
                isOverBudget
                    ? AppColors.error
                    : progress > 0.85
                        ? AppColors.warning
                        : Colors.white,
              ),
            ),
          ),
          const SizedBox(height: 12),

          // Remaining & Spent breakdown
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                '${l10n.spent}: $curr$spentStr',
                style: AppTypography.labelSmall.copyWith(color: Colors.white70),
              ),
              Text(
                '${l10n.totalGoal}: $curr$targetStr',
                style: AppTypography.labelSmall.copyWith(color: Colors.white70),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
