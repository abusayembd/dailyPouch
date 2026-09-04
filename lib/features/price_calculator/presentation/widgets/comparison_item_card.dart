import 'package:flutter/material.dart';
import '../../../../core/localization/app_localizations.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_typography.dart';
import '../../../../core/widgets/glass_card.dart';
import '../../domain/entities/comparison_item_entity.dart';

class ComparisonItemCard extends StatelessWidget {
  final ComparisonItemEntity item;
  final bool isBestDeal;
  final double percentMoreExpensive;
  final bool canDelete;
  final String? currencySymbol;
  final ValueChanged<double> onPriceChanged;
  final ValueChanged<double> onQuantityChanged;
  final ValueChanged<MeasurementUnit> onUnitChanged;
  final ValueChanged<String> onLabelChanged;
  final VoidCallback onDelete;

  const ComparisonItemCard({
    super.key,
    required this.item,
    required this.isBestDeal,
    required this.percentMoreExpensive,
    required this.canDelete,
    this.currencySymbol,
    required this.onPriceChanged,
    required this.onQuantityChanged,
    required this.onUnitChanged,
    required this.onLabelChanged,
    required this.onDelete,
  });

  @override
  Widget build(BuildContext context) {
    final curr = currencySymbol ?? '\$';
    final l10n = context.l10n;

    return GlassCard(
      margin: const EdgeInsets.only(bottom: 14),
      borderRadius: 18,
      borderColor: isBestDeal
          ? AppColors.modulePriceCalc
          : AppColors.cardBorder,
      borderWidth: isBestDeal ? 1.5 : 1,
      backgroundColor: isBestDeal
          ? AppColors.modulePriceCalc.withAlpha(15)
          : AppColors.surfaceCard,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Top Row: Option Title with Top-Left Border Label + Status Badge + Delete
          Row(
            children: [
              Expanded(
                child: TextFormField(
                  initialValue: l10n.getLocalizedOptionLabel(item.label),
                  onChanged: onLabelChanged,
                  style: AppTypography.titleMedium.copyWith(
                    color: isBestDeal ? AppColors.modulePriceCalc : AppColors.textPrimary,
                    fontWeight: FontWeight.w600,
                  ),
                  decoration: InputDecoration(
                    labelText: l10n.optionName,
                    floatingLabelBehavior: FloatingLabelBehavior.always,
                    floatingLabelStyle: TextStyle(
                      color: isBestDeal ? AppColors.modulePriceCalc : AppColors.primaryLight,
                      fontWeight: FontWeight.w600,
                      fontSize: 12,
                    ),
                    isDense: true,
                    contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
                    hintText: l10n.optionName,
                  ),
                ),
              ),
              const SizedBox(width: 8),
              if (isBestDeal && item.price > 0 && item.quantity > 0)
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  decoration: BoxDecoration(
                    color: AppColors.modulePriceCalc,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Text(
                    l10n.bestDeal,
                    style: AppTypography.badgeText.copyWith(color: Colors.white),
                  ),
                )
              else if (percentMoreExpensive > 0)
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  decoration: BoxDecoration(
                    color: AppColors.error.withAlpha(30),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Text(
                    '+${l10n.formatNumber(percentMoreExpensive.toStringAsFixed(1))}% ${l10n.more}',
                    style: AppTypography.badgeText.copyWith(color: AppColors.error),
                  ),
                ),
              if (canDelete) ...[
                const SizedBox(width: 4),
                IconButton(
                  icon: const Icon(Icons.remove_circle_outline_rounded, color: AppColors.textMuted, size: 20),
                  onPressed: onDelete,
                ),
              ],
            ],
          ),

          const SizedBox(height: 14),

          // Price & Quantity & Unit Input Row with Top-Left Border Embedded Labels
          Row(
            children: [
              // 1. Price Input (Top-Left Border Label: Price, Value Inside: $ 0.00)
              Expanded(
                flex: 3,
                child: TextFormField(
                  initialValue: item.price > 0 ? l10n.formatNumber(item.price.toString()) : '',
                  keyboardType: const TextInputType.numberWithOptions(decimal: true),
                  onChanged: (val) {
                    final normalized = AppLocalizations.normalizeNumber(val);
                    onPriceChanged(double.tryParse(normalized) ?? 0.0);
                  },
                  style: AppTypography.bodyLarge.copyWith(
                    color: AppColors.textPrimary,
                    fontWeight: FontWeight.w600,
                  ),
                  decoration: InputDecoration(
                    labelText: l10n.price,
                    floatingLabelBehavior: FloatingLabelBehavior.always,
                    floatingLabelStyle: const TextStyle(
                      color: AppColors.primaryLight,
                      fontWeight: FontWeight.w600,
                      fontSize: 12,
                    ),
                    prefixText: '$curr ',
                    prefixStyle: AppTypography.titleMedium.copyWith(color: AppColors.primaryLight),
                    hintText: l10n.formatNumber('0.00'),
                    isDense: true,
                    contentPadding: const EdgeInsets.symmetric(horizontal: 10, vertical: 12),
                  ),
                ),
              ),
              const SizedBox(width: 8),

              // 2. Quantity Input (Top-Left Border Label: Qty / Size, Value Inside: 0)
              Expanded(
                flex: 3,
                child: TextFormField(
                  initialValue: item.quantity > 0 ? l10n.formatNumber(item.quantity.toString()) : '',
                  keyboardType: const TextInputType.numberWithOptions(decimal: true),
                  onChanged: (val) {
                    final normalized = AppLocalizations.normalizeNumber(val);
                    onQuantityChanged(double.tryParse(normalized) ?? 0.0);
                  },
                  style: AppTypography.bodyLarge.copyWith(
                    color: AppColors.textPrimary,
                    fontWeight: FontWeight.w600,
                  ),
                  decoration: InputDecoration(
                    labelText: l10n.sizeOrQty,
                    floatingLabelBehavior: FloatingLabelBehavior.always,
                    floatingLabelStyle: const TextStyle(
                      color: AppColors.primaryLight,
                      fontWeight: FontWeight.w600,
                      fontSize: 12,
                    ),
                    hintText: l10n.formatNumber('0'),
                    isDense: true,
                    contentPadding: const EdgeInsets.symmetric(horizontal: 10, vertical: 12),
                  ),
                ),
              ),
              const SizedBox(width: 8),

              // 3. Unit Dropdown (Top-Left Border Label: Unit, Value Inside: Grams / গ্রাম)
              Expanded(
                flex: 4,
                child: DropdownButtonFormField<MeasurementUnit>(
                  initialValue: item.unit,
                  isExpanded: true,
                  dropdownColor: AppColors.surfaceElevated,
                  decoration: InputDecoration(
                    labelText: l10n.unit,
                    floatingLabelBehavior: FloatingLabelBehavior.always,
                    floatingLabelStyle: const TextStyle(
                      color: AppColors.primaryLight,
                      fontWeight: FontWeight.w600,
                      fontSize: 12,
                    ),
                    isDense: true,
                    contentPadding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
                  ),
                  items: MeasurementUnit.values.map((u) {
                    return DropdownMenuItem(
                      value: u,
                      child: Text(
                        l10n.getLocalizedUnitName(u),
                        style: AppTypography.bodyMedium.copyWith(
                          color: AppColors.textPrimary,
                          fontSize: 12,
                        ),
                        overflow: TextOverflow.ellipsis,
                      ),
                    );
                  }).toList(),
                  onChanged: (u) {
                    if (u != null) onUnitChanged(u);
                  },
                ),
              ),
            ],
          ),

          if (item.price > 0 && item.quantity > 0) ...[
            const SizedBox(height: 12),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
              decoration: BoxDecoration(
                color: AppColors.surfaceElevated,
                borderRadius: BorderRadius.circular(10),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    '${l10n.unitCost}:',
                    style: AppTypography.labelSmall.copyWith(color: AppColors.textMuted),
                  ),
                  Flexible(
                    child: Text(
                      '$curr${l10n.formatNumber(item.pricePerStandardUnit.toStringAsFixed(3))} ${l10n.getStandardUnitLabel(item.unit.category)}  ($curr${l10n.formatNumber(item.pricePerBulkUnit.toStringAsFixed(2))} ${l10n.getBulkUnitLabel(item.unit.category)})',
                      style: AppTypography.titleMedium.copyWith(
                        color: isBestDeal ? AppColors.modulePriceCalc : AppColors.textPrimary,
                        fontSize: 13,
                      ),
                      textAlign: TextAlign.end,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ],
      ),
    );
  }
}
