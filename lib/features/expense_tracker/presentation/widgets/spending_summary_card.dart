import 'package:flutter/material.dart';
import '../../../../core/localization/app_localizations.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_typography.dart';
import '../../domain/entities/expense_transaction.dart';

class SpendingSummaryCard extends StatelessWidget {
  final FinancialSummary summary;
  final TimePeriodFilter period;
  final String currencySymbol;

  const SpendingSummaryCard({
    super.key,
    required this.summary,
    required this.period,
    required this.currencySymbol,
  });

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final isPositive = summary.netCashFlow >= 0;

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: AppColors.surfaceCard,
        borderRadius: BorderRadius.circular(22),
        border: Border.all(
          color: isPositive
              ? AppColors.moduleBudgeter.withAlpha(50)
              : AppColors.error.withAlpha(50),
          width: 1.2,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withAlpha(12),
            blurRadius: 14,
            offset: const Offset(0, 4),
          ),
          BoxShadow(
            color: (isPositive ? AppColors.moduleBudgeter : AppColors.error).withAlpha(20),
            blurRadius: 16,
            offset: const Offset(0, 6),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header: Period tag & Transaction count badge
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  Container(
                    width: 8,
                    height: 8,
                    decoration: BoxDecoration(
                      color: isPositive ? AppColors.moduleBudgeter : AppColors.error,
                      shape: BoxShape.circle,
                    ),
                  ),
                  const SizedBox(width: 8),
                  Text(
                    _getPeriodLabel(l10n, period).toUpperCase(),
                    style: AppTypography.badgeText.copyWith(
                      color: AppColors.textSecondary,
                      fontSize: 10.5,
                      fontWeight: FontWeight.w800,
                      letterSpacing: 0.8,
                    ),
                  ),
                ],
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                decoration: BoxDecoration(
                  color: AppColors.background,
                  borderRadius: BorderRadius.circular(10),
                  border: Border.all(color: AppColors.cardBorder, width: 1),
                ),
                child: Text(
                  l10n.transactionEntries(summary.transactionCount),
                  style: AppTypography.labelSmall.copyWith(
                    color: AppColors.textMuted,
                    fontSize: 10,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ],
          ),

          const SizedBox(height: 12),

          // Net Cash Flow / Balance
          Text(
            l10n.netCashFlow,
            style: AppTypography.bodyMedium.copyWith(
              color: AppColors.textMuted,
              fontSize: 12,
              fontWeight: FontWeight.w500,
            ),
          ),
          const SizedBox(height: 4),
          Row(
            crossAxisAlignment: CrossAxisAlignment.baseline,
            textBaseline: TextBaseline.alphabetic,
            children: [
              Text(
                '${summary.netCashFlow >= 0 ? "+" : ""}${l10n.formatCurrency(summary.netCashFlow, currencySymbol)}',
                style: AppTypography.displayLarge.copyWith(
                  color: isPositive ? AppColors.moduleBudgeter : AppColors.error,
                  fontSize: 30,
                  fontWeight: FontWeight.w900,
                  letterSpacing: -0.5,
                ),
              ),
              const SizedBox(width: 8),
              if (summary.totalIncome > 0)
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                  decoration: BoxDecoration(
                    color: (isPositive ? AppColors.moduleBudgeter : AppColors.error).withAlpha(25),
                    borderRadius: BorderRadius.circular(6),
                  ),
                  child: Text(
                    l10n.savedPct(summary.savingsRate.toStringAsFixed(0)),
                    style: AppTypography.badgeText.copyWith(
                      color: isPositive ? AppColors.moduleBudgeter : AppColors.error,
                      fontSize: 10,
                      fontWeight: FontWeight.w800,
                    ),
                  ),
                ),
            ],
          ),

          const SizedBox(height: 16),

          // Income vs Expense Split Cards
          Row(
            children: [
              // Income Card
              Expanded(
                child: Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: const Color(0xFFECFDF5), // Emerald light
                    borderRadius: BorderRadius.circular(14),
                    border: Border.all(color: const Color(0xFFA7F3D0), width: 1),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Container(
                            padding: const EdgeInsets.all(4),
                            decoration: const BoxDecoration(
                              color: Color(0xFF10B981),
                              shape: BoxShape.circle,
                            ),
                            child: const Icon(Icons.arrow_downward_rounded, size: 10, color: Colors.white),
                          ),
                          const SizedBox(width: 6),
                          Text(
                            l10n.incomeUpper,
                            style: AppTypography.badgeText.copyWith(
                              color: const Color(0xFF065F46),
                              fontSize: 9.5,
                              fontWeight: FontWeight.w800,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 6),
                      Text(
                        l10n.formatCurrency(summary.totalIncome, currencySymbol),
                        style: AppTypography.titleMedium.copyWith(
                          color: const Color(0xFF065F46),
                          fontSize: 15.5,
                          fontWeight: FontWeight.w800,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ],
                  ),
                ),
              ),

              const SizedBox(width: 10),

              // Expense Card
              Expanded(
                child: Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: const Color(0xFFFEF2F2), // Rose red light
                    borderRadius: BorderRadius.circular(14),
                    border: Border.all(color: const Color(0xFFFECACA), width: 1),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Container(
                            padding: const EdgeInsets.all(4),
                            decoration: const BoxDecoration(
                              color: Color(0xFFEF4444),
                              shape: BoxShape.circle,
                            ),
                            child: const Icon(Icons.arrow_upward_rounded, size: 10, color: Colors.white),
                          ),
                          const SizedBox(width: 6),
                          Text(
                            l10n.expenseUpper,
                            style: AppTypography.badgeText.copyWith(
                              color: const Color(0xFF991B1B),
                              fontSize: 9.5,
                              fontWeight: FontWeight.w800,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 6),
                      Text(
                        l10n.formatCurrency(summary.totalExpense, currencySymbol),
                        style: AppTypography.titleMedium.copyWith(
                          color: const Color(0xFF991B1B),
                          fontSize: 15.5,
                          fontWeight: FontWeight.w800,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),

          if (summary.totalIncome > 0) ...[
            const SizedBox(height: 14),
            // Savings Rate Progress Bar
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      l10n.savingsProgress,
                      style: AppTypography.labelSmall.copyWith(
                        color: AppColors.textSecondary,
                        fontSize: 11,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    Text(
                      '${summary.savingsRate.toStringAsFixed(1)}%',
                      style: AppTypography.labelSmall.copyWith(
                        color: isPositive ? AppColors.moduleBudgeter : AppColors.error,
                        fontSize: 11,
                        fontWeight: FontWeight.w800,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 6),
                ClipRRect(
                  borderRadius: BorderRadius.circular(6),
                  child: LinearProgressIndicator(
                    value: (summary.savingsRate / 100.0).clamp(0.0, 1.0),
                    minHeight: 7,
                    backgroundColor: AppColors.cardBorder,
                    valueColor: AlwaysStoppedAnimation<Color>(
                      isPositive ? AppColors.moduleBudgeter : AppColors.error,
                    ),
                  ),
                ),
              ],
            ),
          ],
        ],
      ),
    );
  }

  String _getPeriodLabel(AppLocalizations l10n, TimePeriodFilter period) {
    switch (period) {
      case TimePeriodFilter.today:
        return l10n.periodToday;
      case TimePeriodFilter.thisWeek:
        return l10n.periodThisWeek;
      case TimePeriodFilter.thisMonth:
        return l10n.periodThisMonth;
      case TimePeriodFilter.allTime:
        return l10n.periodAllTime;
    }
  }
}
