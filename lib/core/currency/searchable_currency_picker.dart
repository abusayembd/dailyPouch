import 'package:flutter/material.dart';
import '../theme/app_colors.dart';
import '../theme/app_typography.dart';
import '../widgets/glass_card.dart';
import 'currency_entity.dart';

/// Shows a searchable modal bottom sheet to select any world currency.
Future<AppCurrency?> showSearchableCurrencyPicker(
  BuildContext context, {
  AppCurrency? current,
}) async {
  return showModalBottomSheet<AppCurrency>(
    context: context,
    isScrollControlled: true,
    backgroundColor: Colors.transparent,
    builder: (context) => _SearchableCurrencyModal(selected: current),
  );
}

class _SearchableCurrencyModal extends StatefulWidget {
  final AppCurrency? selected;

  const _SearchableCurrencyModal({this.selected});

  @override
  State<_SearchableCurrencyModal> createState() => _SearchableCurrencyModalState();
}

class _SearchableCurrencyModalState extends State<_SearchableCurrencyModal> {
  final TextEditingController _searchController = TextEditingController();
  List<AppCurrency> _filtered = kSupportedCurrencies;

  @override
  void initState() {
    super.initState();
    _searchController.addListener(_onSearchChanged);
  }

  @override
  void dispose() {
    _searchController.removeListener(_onSearchChanged);
    _searchController.dispose();
    super.dispose();
  }

  void _onSearchChanged() {
    final query = _searchController.text.trim().toLowerCase();
    setState(() {
      if (query.isEmpty) {
        _filtered = kSupportedCurrencies;
      } else {
        _filtered = kSupportedCurrencies
            .where((c) => c.fullSearchText.contains(query))
            .toList();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final bottomInset = MediaQuery.of(context).viewInsets.bottom;

    return Container(
      constraints: BoxConstraints(
        maxHeight: MediaQuery.of(context).size.height * 0.82,
      ),
      margin: EdgeInsets.only(bottom: bottomInset),
      decoration: const BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
        border: Border(
          top: BorderSide(color: AppColors.cardBorder, width: 1.5),
          left: BorderSide(color: AppColors.cardBorder, width: 1),
          right: BorderSide(color: AppColors.cardBorder, width: 1),
        ),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // Drag Handle
          Center(
            child: Container(
              margin: const EdgeInsets.only(top: 12, bottom: 8),
              width: 44,
              height: 4,
              decoration: BoxDecoration(
                color: AppColors.textMuted.withAlpha(80),
                borderRadius: BorderRadius.circular(2),
              ),
            ),
          ),

          // Header
          Padding(
            padding: const EdgeInsets.fromLTRB(20, 8, 20, 14),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('Select Currency', style: AppTypography.headlineMedium),
                    const SizedBox(height: 2),
                    Text(
                      'Choose central currency for calculations & bills',
                      style: AppTypography.labelSmall.copyWith(color: AppColors.textMuted),
                    ),
                  ],
                ),
                IconButton(
                  icon: const Icon(Icons.close_rounded, color: AppColors.textMuted),
                  onPressed: () => Navigator.of(context).pop(),
                ),
              ],
            ),
          ),

          // Search Box
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 18),
            child: TextField(
              controller: _searchController,
              autofocus: false,
              style: AppTypography.bodyMedium,
              decoration: InputDecoration(
                hintText: 'Search by currency name, code (USD), symbol (\$)...',
                prefixIcon: const Icon(Icons.search_rounded, color: AppColors.primaryLight, size: 20),
                suffixIcon: _searchController.text.isNotEmpty
                    ? IconButton(
                        icon: const Icon(Icons.clear_rounded, size: 18),
                        onPressed: () {
                          _searchController.clear();
                        },
                      )
                    : null,
                filled: true,
                fillColor: AppColors.surfaceElevated,
                contentPadding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(14),
                  borderSide: const BorderSide(color: AppColors.cardBorder),
                ),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(14),
                  borderSide: const BorderSide(color: AppColors.cardBorder),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(14),
                  borderSide: const BorderSide(color: AppColors.primaryLight, width: 1.5),
                ),
              ),
            ),
          ),

          const SizedBox(height: 12),

          // Currency Results List
          Flexible(
            child: _filtered.isEmpty
                ? Padding(
                    padding: const EdgeInsets.all(32),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        const Icon(Icons.search_off_rounded, size: 40, color: AppColors.textMuted),
                        const SizedBox(height: 8),
                        Text(
                          'No matching currencies found',
                          style: AppTypography.bodyMedium.copyWith(color: AppColors.textMuted),
                        ),
                      ],
                    ),
                  )
                : ListView.builder(
                    padding: const EdgeInsets.fromLTRB(16, 0, 16, 24),
                    itemCount: _filtered.length,
                    itemBuilder: (context, index) {
                      final item = _filtered[index];
                      final isSelected = widget.selected?.code == item.code;

                      return GlassCard(
                        margin: const EdgeInsets.only(bottom: 8),
                        borderRadius: 14,
                        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
                        borderColor: isSelected
                            ? AppColors.primary
                            : AppColors.cardBorder.withAlpha(40),
                        backgroundColor: isSelected
                            ? AppColors.primary.withAlpha(20)
                            : AppColors.surfaceCard,
                        onTap: () {
                          Navigator.of(context).pop(item);
                        },
                        child: Row(
                          children: [
                            // Symbol & Code Badge
                            Container(
                              width: 44,
                              height: 44,
                              alignment: Alignment.center,
                              decoration: BoxDecoration(
                                color: isSelected
                                    ? AppColors.primary.withAlpha(35)
                                    : AppColors.surfaceElevated,
                                borderRadius: BorderRadius.circular(12),
                                border: Border.all(
                                  color: isSelected
                                      ? AppColors.primaryLight
                                      : AppColors.cardBorder,
                                ),
                              ),
                              child: Text(
                                item.symbol,
                                style: AppTypography.titleMedium.copyWith(
                                  color: isSelected ? AppColors.primaryLight : AppColors.textPrimary,
                                  fontWeight: FontWeight.w800,
                                  fontSize: 16,
                                ),
                              ),
                            ),
                            const SizedBox(width: 14),

                            // Code & Full Name
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Row(
                                    children: [
                                      Text(
                                        item.code,
                                        style: AppTypography.titleMedium.copyWith(
                                          fontWeight: FontWeight.w700,
                                          color: isSelected
                                              ? AppColors.primaryLight
                                              : AppColors.textPrimary,
                                        ),
                                      ),
                                      if (item.country.isNotEmpty) ...[
                                        const SizedBox(width: 8),
                                        Text(
                                          '• ${item.country}',
                                          style: AppTypography.labelSmall.copyWith(
                                            color: AppColors.textMuted,
                                          ),
                                        ),
                                      ],
                                    ],
                                  ),
                                  const SizedBox(height: 2),
                                  Text(
                                    item.name,
                                    style: AppTypography.bodyMedium.copyWith(
                                      color: isSelected ? AppColors.textPrimary : AppColors.textSecondary,
                                      fontSize: 12,
                                    ),
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                ],
                              ),
                            ),

                            // Selection Radio Indicator
                            Icon(
                              isSelected
                                  ? Icons.check_circle_rounded
                                  : Icons.circle_outlined,
                              color: isSelected ? AppColors.primaryLight : AppColors.textMuted,
                              size: 22,
                            ),
                          ],
                        ),
                      );
                    },
                  ),
          ),
        ],
      ),
    );
  }
}

/// Searchable Currency Selector Field widget suitable for forms & dialogs
class CurrencyPickerField extends StatelessWidget {
  final AppCurrency selected;
  final ValueChanged<AppCurrency> onSelected;

  const CurrencyPickerField({
    super.key,
    required this.selected,
    required this.onSelected,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () async {
        final result = await showSearchableCurrencyPicker(context, current: selected);
        if (result != null) {
          onSelected(result);
        }
      },
      borderRadius: BorderRadius.circular(14),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
        decoration: BoxDecoration(
          color: AppColors.surfaceElevated,
          borderRadius: BorderRadius.circular(14),
          border: Border.all(color: AppColors.cardBorder),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Row(
              children: [
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  decoration: BoxDecoration(
                    color: AppColors.primary.withAlpha(30),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Text(
                    selected.symbol,
                    style: AppTypography.titleMedium.copyWith(
                      color: AppColors.primaryLight,
                      fontWeight: FontWeight.w800,
                    ),
                  ),
                ),
                const SizedBox(width: 10),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      '${selected.code} (${selected.symbol})',
                      style: AppTypography.titleMedium.copyWith(fontSize: 14),
                    ),
                    Text(
                      selected.name,
                      style: AppTypography.labelSmall.copyWith(
                        color: AppColors.textMuted,
                        fontSize: 11,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ],
                ),
              ],
            ),
            const Icon(Icons.keyboard_arrow_down_rounded, color: AppColors.textMuted),
          ],
        ),
      ),
    );
  }
}
