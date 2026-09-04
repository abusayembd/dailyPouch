import 'package:flutter/material.dart';
import '../../../../core/localization/app_localizations.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_typography.dart';
import '../../domain/entities/utility_module.dart';
import 'module_3d_illustrations.dart';

class ArcadeModuleCard extends StatelessWidget {
  final UtilityModule module;
  final VoidCallback onTap;
  final VoidCallback? onInfoTap;

  const ArcadeModuleCard({
    super.key,
    required this.module,
    required this.onTap,
    this.onInfoTap,
  });

  LinearGradient _getPastelGradient(String id) {
    switch (id) {
      case 'subscription_tracker':
        return AppColors.pastelSubscriptionCard;
      case 'price_calculator':
        return AppColors.pastelPriceCalcCard;
      case 'pantry_expiry':
        return AppColors.pastelPantryCard;
      case 'image_compressor':
        return AppColors.pastelCompressorCard;
      case 'micro_budgeter':
        return AppColors.pastelBudgeterCard;
      case 'interval_timer':
        return AppColors.pastelTimerCard;
      default:
        return AppColors.pastelSubscriptionCard;
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final localizedTitle = l10n.getModuleTitle(module.id);
    final localizedDescription = l10n.getModuleDescription(module.id);
    final gradient = _getPastelGradient(module.id);

    return Material(
      color: Colors.transparent,
      borderRadius: BorderRadius.circular(20),
      child: InkWell(
        onTap: onTap,
        onLongPress: onInfoTap,
        borderRadius: BorderRadius.circular(20),
        child: Container(
          clipBehavior: Clip.antiAlias,
          decoration: BoxDecoration(
            gradient: gradient,
            borderRadius: BorderRadius.circular(20),
            border: Border.all(
              color: Colors.white.withAlpha(190),
              width: 1.2,
            ),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withAlpha(12),
                blurRadius: 10,
                spreadRadius: 0,
                offset: const Offset(0, 3),
              ),
              BoxShadow(
                color: module.accentColor.withAlpha(28),
                blurRadius: 14,
                spreadRadius: 1,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          child: Padding(
            padding: const EdgeInsets.fromLTRB(11, 8, 5, 8),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Top Row: Icon Badge (Left) + Category Pill (Right)
                Padding(
                  padding: const EdgeInsets.only(right: 5),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      // Square/Rounded Glowing Icon Badge
                      Container(
                        width: 28,
                        height: 28,
                        decoration: BoxDecoration(
                          gradient: module.gradient,
                          borderRadius: BorderRadius.circular(8),
                          boxShadow: [
                            BoxShadow(
                              color: module.accentColor.withAlpha(80),
                              blurRadius: 5,
                              offset: const Offset(0, 1.5),
                            ),
                          ],
                        ),
                        child: Icon(
                          module.icon,
                          color: Colors.white,
                          size: 15,
                        ),
                      ),

                      // Category/Phase Pill Badge
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                        decoration: BoxDecoration(
                          color: module.accentColor.withAlpha(25),
                          borderRadius: BorderRadius.circular(6),
                          border: Border.all(
                            color: module.accentColor.withAlpha(90),
                            width: 1,
                          ),
                        ),
                        child: Text(
                          module.badgeText,
                          style: AppTypography.badgeText.copyWith(
                            color: module.accentColor,
                            fontSize: 7.5,
                            fontWeight: FontWeight.w800,
                            letterSpacing: 0.3,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 5),

                // Middle: Bold Title Text (+2px larger)
                Padding(
                  padding: const EdgeInsets.only(right: 5),
                  child: Text(
                    localizedTitle.isNotEmpty ? localizedTitle : module.title,
                    style: AppTypography.titleMedium.copyWith(
                      color: AppColors.textPrimary,
                      fontWeight: FontWeight.w800,
                      fontSize: 14.5,
                      letterSpacing: -0.2,
                      height: 1.15,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),

                const SizedBox(height: 3),

                // Bottom Row: True Level Side-by-Side (+2px larger subtitle font)
                Expanded(
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      // Left Half (64%): Subtitle text (+2px larger)
                      Expanded(
                        flex: 16,
                        child: Text(
                          localizedDescription.isNotEmpty
                              ? localizedDescription
                              : module.description,
                          style: AppTypography.bodyMedium.copyWith(
                            color: AppColors.textSecondary,
                            fontSize: 11.5,
                            fontWeight: FontWeight.w500,
                            height: 1.25,
                          ),
                          maxLines: 4,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),

                      const SizedBox(width: 2),

                      // Right Half (36%): 3D Illustration centered side-by-side
                      Expanded(
                        flex: 9,
                        child: Align(
                          alignment: Alignment.centerRight,
                          child: Module3DIllustration(
                            moduleId: module.id,
                            size: 52,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
