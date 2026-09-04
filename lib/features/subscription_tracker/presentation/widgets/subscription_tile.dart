import 'package:flutter/material.dart';
import '../../../../core/localization/app_localizations.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_typography.dart';
import '../../../../core/widgets/glass_card.dart';
import '../../domain/entities/subscription_entity.dart';

class SubscriptionTile extends StatelessWidget {
  final SubscriptionEntity subscription;
  final String? currencySymbol;
  final VoidCallback onToggle;
  final VoidCallback onTogglePaid;
  final VoidCallback onEdit;
  final VoidCallback onDelete;

  const SubscriptionTile({
    super.key,
    required this.subscription,
    this.currencySymbol,
    required this.onToggle,
    required this.onTogglePaid,
    required this.onEdit,
    required this.onDelete,
  });

  IconData _getCategoryIcon(SubscriptionCategory category) {
    switch (category) {
      case SubscriptionCategory.entertainment:
        return Icons.movie_outlined;
      case SubscriptionCategory.utilities:
        return Icons.bolt_outlined;
      case SubscriptionCategory.software:
        return Icons.code_rounded;
      case SubscriptionCategory.health:
        return Icons.fitness_center_outlined;
      case SubscriptionCategory.work:
        return Icons.business_center_outlined;
      case SubscriptionCategory.other:
        return Icons.receipt_long_outlined;
    }
  }

  Color _getCountdownColor(int days) {
    if (days < 0) {
      return const Color(0xFFDC2626); // Strong Red (Overdue)
    } else if (days == 0) {
      return const Color(0xFFF43F5E); // Warning Crimson / Rose (Due Today)
    } else if (days == 1) {
      return const Color(0xFFFF7A00); // Amber Orange (1 day left)
    } else if (days <= 3) {
      return const Color(0xFFF59E0B); // Warm Gold (2-3 days)
    } else if (days <= 7) {
      return const Color(0xFFFBBF24); // Soft Yellow-Amber (4-7 days)
    } else {
      return const Color(0xFF6366F1); // Calm Indigo (> 7 days)
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final days = subscription.daysUntilNextBilling;
    final displayCurrency = currencySymbol ?? subscription.currency;
    final dateStr = l10n.formatDate(subscription.nextBillingDate);
    final localizedName = l10n.getLocalizedSubscriptionName(subscription.name);

    final countdownColor = _getCountdownColor(days);
    final String countdownText;
    if (days < 0) {
      countdownText = l10n.overdueByDays(-days);
    } else if (days == 0) {
      countdownText = l10n.dueToday;
    } else {
      countdownText = l10n.inXDays(days);
    }

    return GlassCard(
      margin: const EdgeInsets.only(bottom: 12),
      borderRadius: 16,
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
      borderColor: subscription.isActive
          ? AppColors.cardBorder
          : AppColors.cardBorder.withAlpha(50),
      child: Opacity(
        opacity: subscription.isActive ? 1.0 : 0.55,
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            // Category Icon with Status Dot
            Stack(
              clipBehavior: Clip.none,
              children: [
                Container(
                  width: 44,
                  height: 44,
                  decoration: BoxDecoration(
                    color: AppColors.surfaceElevated,
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(
                      color: subscription.isActive
                          ? AppColors.moduleSubscription.withAlpha(60)
                          : AppColors.cardBorder,
                    ),
                  ),
                  child: Icon(
                    _getCategoryIcon(subscription.category),
                    color: subscription.isActive
                        ? AppColors.moduleSubscription
                        : AppColors.textMuted,
                    size: 22,
                  ),
                ),
                if (subscription.isActive && days <= subscription.remindDaysBefore)
                  Positioned(
                    top: -2,
                    right: -2,
                    child: Container(
                      width: 10,
                      height: 10,
                      decoration: BoxDecoration(
                        color: countdownColor,
                        shape: BoxShape.circle,
                        border: Border.all(
                          color: AppColors.surfaceElevated,
                          width: 1.5,
                        ),
                      ),
                    ),
                  ),
              ],
            ),

            const SizedBox(width: 12),

            // Middle Column: Title & Due/Cycle Info
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    localizedName,
                    style: AppTypography.titleMedium.copyWith(
                      color: subscription.isActive
                          ? AppColors.textPrimary
                          : AppColors.textMuted,
                      decoration: subscription.isActive
                          ? null
                          : TextDecoration.lineThrough,
                      fontSize: 15,
                      fontWeight: FontWeight.w600,
                    ),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 5),
                  Wrap(
                    crossAxisAlignment: WrapCrossAlignment.center,
                    spacing: 6,
                    runSpacing: 4,
                    children: [
                      Text(
                        '${l10n.dueOnDate(dateStr)} • ${l10n.getBillingCycleName(subscription.billingCycle)}',
                        style: AppTypography.labelSmall.copyWith(
                          color: AppColors.textMuted,
                          fontSize: 11.5,
                        ),
                      ),
                      // Countdown Badge (Dynamic Color + In X Days)
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 7, vertical: 2.5),
                        decoration: BoxDecoration(
                          color: countdownColor.withAlpha(25),
                          borderRadius: BorderRadius.circular(6),
                          border: Border.all(color: countdownColor.withAlpha(70), width: 1),
                        ),
                        child: Text(
                          countdownText,
                          style: AppTypography.badgeText.copyWith(
                            color: countdownColor,
                            fontWeight: FontWeight.w700,
                            fontSize: 10,
                            letterSpacing: 0.2,
                          ),
                        ),
                      ),
                      // Paid / Unpaid Status Indicator Chip
                      InkWell(
                        onTap: onTogglePaid,
                        borderRadius: BorderRadius.circular(6),
                        child: Container(
                          padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2.5),
                          decoration: BoxDecoration(
                            color: subscription.isPaid
                                ? AppColors.success.withAlpha(25)
                                : AppColors.surfaceElevated,
                            borderRadius: BorderRadius.circular(6),
                            border: Border.all(
                              color: subscription.isPaid
                                  ? AppColors.success.withAlpha(80)
                                  : AppColors.cardBorder,
                              width: 1,
                            ),
                          ),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Icon(
                                subscription.isPaid
                                    ? Icons.check_circle_rounded
                                    : Icons.circle_outlined,
                                size: 10,
                                color: subscription.isPaid
                                    ? AppColors.success
                                    : AppColors.textMuted,
                              ),
                              const SizedBox(width: 3.5),
                              Text(
                                subscription.isPaid ? l10n.paid : l10n.unpaid,
                                style: AppTypography.badgeText.copyWith(
                                  color: subscription.isPaid
                                      ? AppColors.success
                                      : AppColors.textMuted,
                                  fontWeight: FontWeight.w600,
                                  fontSize: 9.5,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),

            const SizedBox(width: 10),

            // Right Column: Price & Actions
            Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  l10n.formatCurrency(subscription.amount, displayCurrency),
                  style: AppTypography.titleMedium.copyWith(
                    color: subscription.isActive
                        ? AppColors.textPrimary
                        : AppColors.textMuted,
                    fontSize: 17,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                const SizedBox(height: 4),
                Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    // Pause / Active Toggle
                    IconButton(
                      icon: Icon(
                        subscription.isActive
                            ? Icons.pause_circle_outline_rounded
                            : Icons.play_circle_outline_rounded,
                        color: subscription.isActive
                            ? AppColors.warning
                            : AppColors.success,
                        size: 20,
                      ),
                      tooltip: subscription.isActive ? l10n.pause : l10n.activate,
                      padding: EdgeInsets.zero,
                      constraints: const BoxConstraints(
                        minWidth: 28,
                        minHeight: 28,
                      ),
                      onPressed: onToggle,
                    ),
                    // Edit / More Menu
                    PopupMenuButton<String>(
                      icon: const Icon(
                        Icons.more_vert_rounded,
                        color: AppColors.textMuted,
                        size: 20,
                      ),
                      padding: EdgeInsets.zero,
                      constraints: const BoxConstraints(
                        minWidth: 28,
                        minHeight: 28,
                      ),
                      color: AppColors.surfaceElevated,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                        side: const BorderSide(color: AppColors.cardBorder),
                      ),
                      itemBuilder: (context) => [
                        PopupMenuItem(
                          value: 'edit',
                          child: Row(
                            children: [
                              const Icon(
                                Icons.edit_rounded,
                                size: 18,
                                color: AppColors.moduleSubscription,
                              ),
                              const SizedBox(width: 10),
                              Text(l10n.editSubscription, style: AppTypography.bodyMedium),
                            ],
                          ),
                        ),
                        PopupMenuItem(
                          value: 'toggle_paid',
                          child: Row(
                            children: [
                              Icon(
                                subscription.isPaid
                                    ? Icons.radio_button_unchecked_rounded
                                    : Icons.check_circle_rounded,
                                size: 18,
                                color: subscription.isPaid
                                    ? AppColors.warning
                                    : AppColors.success,
                              ),
                              const SizedBox(width: 10),
                              Text(
                                subscription.isPaid
                                    ? l10n.markAsUnpaid
                                    : l10n.markAsPaid,
                                style: AppTypography.bodyMedium,
                              ),
                            ],
                          ),
                        ),
                        PopupMenuItem(
                          value: 'delete',
                          child: Row(
                            children: [
                              const Icon(
                                Icons.delete_outline_rounded,
                                size: 18,
                                color: AppColors.error,
                              ),
                              const SizedBox(width: 10),
                              Text(
                                l10n.delete,
                                style: const TextStyle(color: AppColors.error),
                              ),
                            ],
                          ),
                        ),
                      ],
                      onSelected: (val) {
                        if (val == 'edit') {
                          onEdit();
                        } else if (val == 'toggle_paid') {
                          onTogglePaid();
                        } else if (val == 'delete') {
                          onDelete();
                        }
                      },
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
