import 'package:flutter/material.dart';
import '../../../../core/localization/app_localizations.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_typography.dart';
import '../../domain/entities/pantry_item_entity.dart';

class ExpiryStatusBadge extends StatelessWidget {
  final PantryItemEntity item;

  const ExpiryStatusBadge({super.key, required this.item});

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;

    if (item.isConsumed) {
      return Container(
        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
        decoration: BoxDecoration(
          color: AppColors.surfaceElevated,
          borderRadius: BorderRadius.circular(10),
        ),
        child: Text(
          l10n.consumed,
          style: AppTypography.badgeText.copyWith(color: AppColors.textMuted),
        ),
      );
    }

    final days = item.daysUntilExpiry;
    final formattedDays = l10n.formatNumber(days.toString());

    Color badgeColor;
    String text;

    switch (item.freshnessStatus) {
      case FreshnessStatus.fresh:
        badgeColor = AppColors.success;
        text = '$formattedDays ${l10n.daysLeft.toUpperCase()}';
        break;
      case FreshnessStatus.warning:
        badgeColor = AppColors.warning;
        text = days == 0 ? l10n.expiresToday : '$formattedDays ${l10n.daysExpiringSoon}';
        break;
      case FreshnessStatus.expired:
        badgeColor = AppColors.error;
        text = l10n.expiredDaysAgo(-days);
        break;
    }

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: badgeColor.withAlpha(30),
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: badgeColor.withAlpha(90)),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 6,
            height: 6,
            decoration: BoxDecoration(
              color: badgeColor,
              shape: BoxShape.circle,
            ),
          ),
          const SizedBox(width: 5),
          Text(
            text,
            style: AppTypography.badgeText.copyWith(color: badgeColor),
          ),
        ],
      ),
    );
  }
}
