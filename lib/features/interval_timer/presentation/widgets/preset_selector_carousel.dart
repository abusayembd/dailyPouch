import 'package:flutter/material.dart';
import '../../../../core/localization/app_localizations.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_typography.dart';
import '../../../../core/widgets/glass_card.dart';
import '../../domain/entities/interval_preset_entity.dart';

class PresetSelectorCarousel extends StatelessWidget {
  final List<IntervalPresetEntity> presets;
  final IntervalPresetEntity selectedPreset;
  final ValueChanged<IntervalPresetEntity> onPresetSelected;
  final VoidCallback onCustomPreset;

  const PresetSelectorCarousel({
    super.key,
    required this.presets,
    required this.selectedPreset,
    required this.onPresetSelected,
    required this.onCustomPreset,
  });

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(l10n.workoutRoutinePresets, style: AppTypography.titleMedium),
            TextButton.icon(
              onPressed: onCustomPreset,
              icon: const Icon(Icons.tune_rounded, size: 16, color: AppColors.moduleTimer),
              label: Text(
                l10n.customInterval,
                style: AppTypography.labelSmall.copyWith(color: AppColors.moduleTimer),
              ),
            ),
          ],
        ),
        const SizedBox(height: 8),
        SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: Row(
            children: presets.map((preset) {
              final isSelected = selectedPreset.id == preset.id;
              final localizedName = l10n.getLocalizedPresetName(preset.name);
              final workSec = l10n.formatNumber(preset.workSeconds.toString());
              final restSec = l10n.formatNumber(preset.restSeconds.toString());
              final setsNum = l10n.formatNumber(preset.totalSets.toString());
              final durationStr = l10n.formatDuration(preset.totalDurationSeconds);

              return Padding(
                padding: const EdgeInsets.only(right: 10),
                child: GlassCard(
                  onTap: () => onPresetSelected(preset),
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                  borderRadius: 16,
                  borderColor: isSelected ? AppColors.moduleTimer : AppColors.cardBorder,
                  backgroundColor: isSelected
                      ? AppColors.moduleTimer.withAlpha(20)
                      : AppColors.surfaceElevated,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Icon(
                            Icons.fitness_center_rounded,
                            size: 16,
                            color: isSelected ? AppColors.moduleTimer : AppColors.textMuted,
                          ),
                          const SizedBox(width: 6),
                          Text(
                            localizedName,
                            style: AppTypography.titleMedium.copyWith(
                              fontSize: 13,
                              color: isSelected ? Colors.white : AppColors.textPrimary,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 4),
                      Text(
                        '${workSec}s ${l10n.phaseWork} • ${restSec}s ${l10n.phaseRest} • $setsNum ${l10n.setsLabel}',
                        style: AppTypography.labelSmall.copyWith(color: AppColors.textMuted),
                      ),
                      const SizedBox(height: 2),
                      Text(
                        '${l10n.totalLabel}: $durationStr',
                        style: AppTypography.badgeText.copyWith(
                          color: isSelected ? AppColors.moduleTimer : AppColors.textMuted,
                          fontSize: 9,
                        ),
                      ),
                    ],
                  ),
                ),
              );
            }).toList(),
          ),
        ),
      ],
    );
  }
}
