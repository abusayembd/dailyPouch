import 'package:flutter/material.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_typography.dart';
import '../../../../core/widgets/glass_card.dart';

class QuickStatsBanner extends StatelessWidget {
  final int totalModules;

  const QuickStatsBanner({
    super.key,
    required this.totalModules,
  });

  @override
  Widget build(BuildContext context) {
    return GlassCard(
      gradient: AppColors.heroCardGradient,
      borderColor: AppColors.primary.withAlpha(40),
      borderRadius: 18,
      padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 16),
      child: Row(
        children: [
          Container(
            width: 46,
            height: 46,
            decoration: BoxDecoration(
              color: AppColors.primary.withAlpha(30),
              borderRadius: BorderRadius.circular(14),
              border: Border.all(
                color: AppColors.primary.withAlpha(80),
              ),
            ),
            child: const Icon(
              Icons.offline_bolt_rounded,
              color: AppColors.primary,
              size: 26,
            ),
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Text(
                      'STAGE 1 OFFLINE HUB',
                      style: AppTypography.badgeText.copyWith(
                        color: AppColors.primary,
                      ),
                    ),
                    const SizedBox(width: 8),
                    Container(
                      width: 6,
                      height: 6,
                      decoration: const BoxDecoration(
                        color: AppColors.success,
                        shape: BoxShape.circle,
                      ),
                    ),
                    const SizedBox(width: 4),
                    Text(
                      '100% On-Device',
                      style: AppTypography.labelSmall.copyWith(
                        color: AppColors.success,
                        fontSize: 10,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 4),
                Text(
                  '$totalModules Swiss-Army Utility Tools Ready',
                  style: AppTypography.headlineMedium.copyWith(fontSize: 16),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
