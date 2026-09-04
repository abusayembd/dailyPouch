import 'package:flutter/material.dart';
import '../../../../core/localization/app_localizations.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_typography.dart';
import '../../domain/entities/expense_category.dart';

class CategoryBreakdownView extends StatelessWidget {
  final Map<ExpenseCategory, double> categorySpending;
  final double totalExpense;
  final String currencySymbol;
  final ValueChanged<ExpenseCategory?>? onCategorySelected;
  final ExpenseCategory? selectedCategory;

  const CategoryBreakdownView({
    super.key,
    required this.categorySpending,
    required this.totalExpense,
    required this.currencySymbol,
    this.onCategorySelected,
    this.selectedCategory,
  });

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;

    if (categorySpending.isEmpty || totalExpense <= 0) {
      return Container(
        width: double.infinity,
        padding: const EdgeInsets.symmetric(vertical: 24, horizontal: 16),
        decoration: BoxDecoration(
          color: AppColors.surfaceCard,
          borderRadius: BorderRadius.circular(18),
          border: Border.all(color: AppColors.cardBorder, width: 1),
        ),
        child: Column(
          children: [
            Icon(Icons.donut_large_rounded, size: 32, color: AppColors.textMuted.withAlpha(120)),
            const SizedBox(height: 8),
            Text(
              l10n.noTransactions,
              style: AppTypography.bodyMedium.copyWith(
                color: AppColors.textMuted,
                fontSize: 13,
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        ),
      );
    }

    // Sort categories by amount descending
    final sortedEntries = categorySpending.entries.toList()
      ..sort((a, b) => b.value.compareTo(a.value));

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.surfaceCard,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: AppColors.cardBorder, width: 1),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withAlpha(8),
            blurRadius: 10,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  const Icon(Icons.pie_chart_outline_rounded, size: 16, color: AppColors.moduleBudgeter),
                  const SizedBox(width: 6),
                  Text(
                    l10n.spendingBreakdown.toUpperCase(),
                    style: AppTypography.badgeText.copyWith(
                      color: AppColors.moduleBudgeter,
                      fontSize: 10.5,
                      fontWeight: FontWeight.w800,
                      letterSpacing: 0.8,
                    ),
                  ),
                ],
              ),
              if (selectedCategory != null)
                GestureDetector(
                  onTap: () => onCategorySelected?.call(null),
                  child: Text(
                    l10n.resetFilters,
                    style: AppTypography.labelSmall.copyWith(
                      color: AppColors.primary,
                      fontWeight: FontWeight.w700,
                      fontSize: 11,
                    ),
                  ),
                ),
            ],
          ),
          const SizedBox(height: 14),

          ...sortedEntries.map((entry) {
            final category = entry.key;
            final amount = entry.value;
            final percentage = (amount / totalExpense * 100.0).clamp(0.0, 100.0);
            final isSelected = selectedCategory == category;

            return Padding(
              padding: const EdgeInsets.only(bottom: 12),
              child: InkWell(
                onTap: () {
                  if (isSelected) {
                    onCategorySelected?.call(null);
                  } else {
                    onCategorySelected?.call(category);
                  }
                },
                borderRadius: BorderRadius.circular(10),
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 4),
                  decoration: BoxDecoration(
                    color: isSelected ? category.color.withAlpha(20) : Colors.transparent,
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Column(
                    children: [
                      Row(
                        children: [
                          Container(
                            width: 26,
                            height: 26,
                            decoration: BoxDecoration(
                              color: category.color.withAlpha(30),
                              borderRadius: BorderRadius.circular(7),
                            ),
                            child: Icon(category.icon, size: 14, color: category.color),
                          ),
                          const SizedBox(width: 10),
                          Expanded(
                            child: Text(
                              l10n.getLocalizedExpenseCategoryName(category.displayName),
                              style: AppTypography.bodyMedium.copyWith(
                                color: AppColors.textPrimary,
                                fontSize: 13,
                                fontWeight: isSelected ? FontWeight.w800 : FontWeight.w600,
                              ),
                            ),
                          ),
                          Text(
                            '${percentage.toStringAsFixed(0)}%',
                            style: AppTypography.labelSmall.copyWith(
                              color: AppColors.textMuted,
                              fontSize: 11,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                          const SizedBox(width: 8),
                          Text(
                            l10n.formatCurrency(amount, currencySymbol),
                            style: AppTypography.titleMedium.copyWith(
                              color: AppColors.textPrimary,
                              fontSize: 13.5,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 6),
                      ClipRRect(
                        borderRadius: BorderRadius.circular(4),
                        child: LinearProgressIndicator(
                          value: percentage / 100.0,
                          minHeight: 5,
                          backgroundColor: AppColors.cardBorder.withAlpha(120),
                          valueColor: AlwaysStoppedAnimation<Color>(category.color),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            );
          }),
        ],
      ),
    );
  }
}
