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
      borderRadius: BorderRadius.circular(22),
      child: InkWell(
        onTap: onTap,
        onLongPress: onInfoTap,
        borderRadius: BorderRadius.circular(22),
        child: Container(
          decoration: BoxDecoration(
            gradient: gradient,
            borderRadius: BorderRadius.circular(22),
            border: Border.all(
              color: Colors.white.withAlpha(180),
              width: 1.2,
            ),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withAlpha(15),
                blurRadius: 14,
                spreadRadius: 0,
                offset: const Offset(0, 4),
              ),
              BoxShadow(
                color: module.accentColor.withAlpha(35),
                blurRadius: 18,
                spreadRadius: 1,
                offset: const Offset(0, 6),
              ),
            ],
          ),
          padding: const EdgeInsets.all(16),
          child: Stack(
            clipBehavior: Clip.none,
            children: [
              // 3D Isometric Artwork Layered in the Background
              Positioned(
                right: -6,
                bottom: -6,
                child: Opacity(
                  opacity: 0.85,
                  child: Module3DIllustration(
                    moduleId: module.id,
                    size: 80,
                  ),
                ),
              ),

              // Main Foreground Content
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.max,
                children: [
                  // Top Row: Icon Badge (Left) + Category Pill (Right)
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      // Square/Rounded Glowing Icon Badge
                      Container(
                        width: 42,
                        height: 42,
                        decoration: BoxDecoration(
                          gradient: module.gradient,
                          borderRadius: BorderRadius.circular(13),
                          boxShadow: [
                            BoxShadow(
                              color: module.accentColor.withAlpha(90),
                              blurRadius: 10,
                              offset: const Offset(0, 3),
                            ),
                          ],
                        ),
                        child: Icon(
                          module.icon,
                          color: Colors.white,
                          size: 22,
                        ),
                      ),

                      // Category/Phase Pill Badge
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 9, vertical: 4),
                        decoration: BoxDecoration(
                          color: module.accentColor.withAlpha(25),
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(
                            color: module.accentColor.withAlpha(90),
                            width: 1,
                          ),
                        ),
                        child: Text(
                          module.badgeText,
                          style: AppTypography.badgeText.copyWith(
                            color: module.accentColor,
                            fontSize: 9.5,
                            fontWeight: FontWeight.w800,
                            letterSpacing: 0.5,
                          ),
                        ),
                      ),
                    ],
                  ),

                  const SizedBox(height: 14),

                  // Middle: Bold Title Text
                  Text(
                    localizedTitle.isNotEmpty ? localizedTitle : module.title,
                    style: AppTypography.titleMedium.copyWith(
                      color: AppColors.textPrimary,
                      fontWeight: FontWeight.w800,
                      fontSize: 15.5,
                      letterSpacing: -0.2,
                      height: 1.25,
                    ),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),

                  const SizedBox(height: 6),

                  // Subtitle: Full Action Description Text without truncation
                  Text(
                    localizedDescription.isNotEmpty
                        ? localizedDescription
                        : module.description,
                    style: AppTypography.bodyMedium.copyWith(
                      color: AppColors.textSecondary,
                      fontSize: 12,
                      fontWeight: FontWeight.w400,
                      height: 1.35,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
