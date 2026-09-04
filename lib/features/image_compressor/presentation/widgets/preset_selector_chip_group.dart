import 'package:flutter/material.dart';
import '../../../../core/localization/app_localizations.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_typography.dart';
import '../../domain/entities/compression_preset.dart';

class PresetSelectorChipGroup extends StatelessWidget {
  final CompressionPreset selectedPreset;
  final ValueChanged<CompressionPreset> onPresetSelected;

  const PresetSelectorChipGroup({
    super.key,
    required this.selectedPreset,
    required this.onPresetSelected,
  });

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          l10n.compressionPresets,
          style: AppTypography.titleMedium,
        ),
        const SizedBox(height: 10),
        SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: Row(
            children: CompressionPreset.allPresets.map((preset) {
              final isSelected = selectedPreset.type == preset.type;
              final localizedTitle = l10n.getLocalizedCompressionPresetTitle(preset.type);

              return Padding(
                padding: const EdgeInsets.only(right: 8),
                child: ChoiceChip(
                  selected: isSelected,
                  label: Text(localizedTitle),
                  labelStyle: AppTypography.labelSmall.copyWith(
                    color: isSelected ? Colors.white : AppColors.textSecondary,
                    fontWeight: isSelected ? FontWeight.w700 : FontWeight.w500,
                  ),
                  backgroundColor: AppColors.surfaceElevated,
                  selectedColor: AppColors.moduleCompressor,
                  side: BorderSide(
                    color: isSelected ? AppColors.moduleCompressor : AppColors.cardBorder,
                  ),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
                  onSelected: (_) => onPresetSelected(preset),
                ),
              );
            }).toList(),
          ),
        ),
      ],
    );
  }
}
