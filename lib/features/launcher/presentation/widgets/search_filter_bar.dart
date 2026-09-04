import 'package:flutter/material.dart';
import '../../../../core/localization/app_localizations.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_typography.dart';
import '../../domain/entities/utility_module.dart';

class SearchFilterBar extends StatelessWidget {
  final String searchQuery;
  final ModuleCategory selectedCategory;
  final ValueChanged<String> onSearchChanged;
  final ValueChanged<ModuleCategory> onCategorySelected;
  final TextEditingController? controller;

  const SearchFilterBar({
    super.key,
    required this.searchQuery,
    required this.selectedCategory,
    required this.onSearchChanged,
    required this.onCategorySelected,
    this.controller,
  });

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Search Input (Clean White Floating Box with Soft Shadow)
        Container(
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(18),
            border: Border.all(color: AppColors.cardBorder, width: 1.2),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withAlpha(8),
                blurRadius: 10,
                offset: const Offset(0, 2),
              ),
            ],
          ),
          child: TextField(
            controller: controller,
            onChanged: onSearchChanged,
            style: AppTypography.bodyLarge.copyWith(color: AppColors.textPrimary),
            decoration: InputDecoration(
              hintText: l10n.searchHint,
              hintStyle: AppTypography.bodyMedium.copyWith(color: AppColors.textMuted),
              prefixIcon: const Icon(
                Icons.search_rounded,
                color: AppColors.textMuted,
                size: 22,
              ),
              suffixIcon: searchQuery.isNotEmpty
                  ? IconButton(
                      icon: const Icon(
                        Icons.close_rounded,
                        color: AppColors.textMuted,
                        size: 18,
                      ),
                      onPressed: () {
                        controller?.clear();
                        onSearchChanged('');
                      },
                    )
                  : null,
              border: InputBorder.none,
              enabledBorder: InputBorder.none,
              focusedBorder: InputBorder.none,
              contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
            ),
          ),
        ),

        const SizedBox(height: 12),

        // Category Filter Chips
        SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          physics: const BouncingScrollPhysics(),
          child: Row(
            children: [
              _buildCategoryChip(ModuleCategory.all, '${l10n.allTools} (6)'),
              _buildCategoryChip(ModuleCategory.finance, l10n.categoryFinance),
              _buildCategoryChip(ModuleCategory.kitchen, l10n.categoryKitchen),
              _buildCategoryChip(ModuleCategory.media, l10n.categoryTools),
              _buildCategoryChip(ModuleCategory.fitness, l10n.categoryFitness),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildCategoryChip(ModuleCategory category, String label) {
    final isSelected = selectedCategory == category;
    return Padding(
      padding: const EdgeInsets.only(right: 8),
      child: FilterChip(
        selected: isSelected,
        label: Text(label),
        labelStyle: AppTypography.labelSmall.copyWith(
          color: isSelected ? Colors.white : AppColors.textSecondary,
          fontWeight: isSelected ? FontWeight.w700 : FontWeight.w600,
        ),
        backgroundColor: Colors.white,
        selectedColor: AppColors.primary,
        side: BorderSide(
          color: isSelected ? AppColors.primary : AppColors.cardBorder,
          width: 1.2,
        ),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(14),
        ),
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
        onSelected: (_) => onCategorySelected(category),
      ),
    );
  }
}
