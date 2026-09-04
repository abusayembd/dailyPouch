import 'package:flutter/material.dart';
import '../../../../core/localization/app_localizations.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_typography.dart';
import '../../../../core/widgets/glass_card.dart';
import '../../domain/entities/pantry_item_entity.dart';
import 'expiry_status_badge.dart';

class PantryItemTile extends StatelessWidget {
  final PantryItemEntity item;
  final VoidCallback onToggleConsumed;
  final VoidCallback onEdit;
  final VoidCallback onDelete;

  const PantryItemTile({
    super.key,
    required this.item,
    required this.onToggleConsumed,
    required this.onEdit,
    required this.onDelete,
  });

  IconData _getZoneIcon(StorageZone zone) {
    switch (zone) {
      case StorageZone.fridge:
        return Icons.kitchen_rounded;
      case StorageZone.freezer:
        return Icons.ac_unit_rounded;
      case StorageZone.pantry:
        return Icons.inventory_2_rounded;
      case StorageZone.medicine:
        return Icons.medication_rounded;
      case StorageZone.all:
        return Icons.all_inbox_rounded;
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final expiryFormatted = l10n.formatDate(item.expiryDate);
    final zoneName = l10n.getStorageZoneName(item.zone).toUpperCase();
    final qtyFormatted = l10n.formatNumber(item.quantity.toStringAsFixed(0));
    final unitFormatted = l10n.getLocalizedPantryUnit(item.unit);
    final localizedItemName = l10n.getLocalizedPantryItemName(item.name);

    return Dismissible(
      key: Key('pantry_${item.id}'),
      direction: DismissDirection.endToStart,
      background: Container(
        alignment: Alignment.centerRight,
        padding: const EdgeInsets.only(right: 20),
        decoration: BoxDecoration(
          color: AppColors.error,
          borderRadius: BorderRadius.circular(16),
        ),
        child: const Icon(Icons.delete_forever_rounded, color: Colors.white, size: 28),
      ),
      onDismissed: (_) => onDelete(),
      child: GlassCard(
        margin: const EdgeInsets.only(bottom: 12),
        borderRadius: 16,
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
        borderColor: item.isConsumed
            ? AppColors.cardBorder.withAlpha(40)
            : item.freshnessStatus == FreshnessStatus.warning
                ? AppColors.warning.withAlpha(80)
                : item.freshnessStatus == FreshnessStatus.expired
                    ? AppColors.error.withAlpha(80)
                    : AppColors.cardBorder,
        backgroundColor: item.isConsumed
            ? AppColors.surface.withAlpha(100)
            : AppColors.surfaceCard,
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            // Zone Icon
            Container(
              width: 44,
              height: 44,
              decoration: BoxDecoration(
                color: item.isConsumed
                    ? AppColors.surfaceElevated
                    : AppColors.modulePantry.withAlpha(30),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Icon(
                _getZoneIcon(item.zone),
                color: item.isConsumed ? AppColors.textMuted : AppColors.modulePantry,
                size: 22,
              ),
            ),
            const SizedBox(width: 12),

            // Item Information (Middle Column)
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    localizedItemName,
                    style: AppTypography.titleMedium.copyWith(
                      color: item.isConsumed ? AppColors.textMuted : AppColors.textPrimary,
                      decoration: item.isConsumed ? TextDecoration.lineThrough : null,
                      fontWeight: FontWeight.w600,
                    ),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 5),
                  Wrap(
                    crossAxisAlignment: WrapCrossAlignment.center,
                    spacing: 8,
                    runSpacing: 4,
                    children: [
                      Text(
                        '$zoneName • ${l10n.qtyLabel}: $qtyFormatted $unitFormatted',
                        style: AppTypography.labelSmall.copyWith(
                          color: AppColors.textMuted,
                          fontSize: 11.5,
                        ),
                      ),
                      Text(
                        '• ${l10n.expiryLabel} $expiryFormatted',
                        style: AppTypography.labelSmall.copyWith(
                          color: AppColors.textSecondary,
                          fontSize: 11.5,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),

            const SizedBox(width: 10),

            // Trailing Column: Expiry badge on top + Actions below
            Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              mainAxisSize: MainAxisSize.min,
              children: [
                ExpiryStatusBadge(item: item),
                const SizedBox(height: 4),
                Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    IconButton(
                      visualDensity: VisualDensity.compact,
                      constraints: const BoxConstraints(minWidth: 28, minHeight: 28),
                      padding: EdgeInsets.zero,
                      icon: Icon(
                        item.isConsumed ? Icons.check_circle_rounded : Icons.check_circle_outline_rounded,
                        color: item.isConsumed ? AppColors.success : AppColors.textMuted,
                        size: 20,
                      ),
                      tooltip: item.isConsumed ? l10n.markAvailable : l10n.markConsumed,
                      onPressed: onToggleConsumed,
                    ),
                    const SizedBox(width: 4),
                    IconButton(
                      visualDensity: VisualDensity.compact,
                      constraints: const BoxConstraints(minWidth: 28, minHeight: 28),
                      padding: EdgeInsets.zero,
                      icon: const Icon(Icons.more_vert_rounded, color: AppColors.textMuted, size: 19),
                      onPressed: onEdit,
                    ),
                  ],
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
