import 'package:flutter/material.dart';
import 'package:uuid/uuid.dart';
import '../../../../core/localization/app_localizations.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_typography.dart';
import '../../domain/entities/budget_envelope_entity.dart';

class QuickLogModal extends StatefulWidget {
  final String envelopeId;
  final String currency;

  const QuickLogModal({
    super.key,
    required this.envelopeId,
    required this.currency,
  });

  @override
  State<QuickLogModal> createState() => _QuickLogModalState();
}

class _QuickLogModalState extends State<QuickLogModal> {
  final _amountController = TextEditingController();
  final _titleController = TextEditingController();
  String _selectedTag = 'General';

  final List<String> _tags = [
    'Food & Drinks',
    'Shopping',
    'Transport',
    'Entertainment',
    'Activities',
    'General',
  ];

  @override
  void dispose() {
    _amountController.dispose();
    _titleController.dispose();
    super.dispose();
  }

  void _submit(AppLocalizations l10n) {
    final normalized = AppLocalizations.normalizeNumber(_amountController.text.trim());
    final amount = double.tryParse(normalized) ?? 0.0;
    if (amount <= 0) return;

    final tx = ExpenseTransactionEntity(
      id: const Uuid().v4(),
      envelopeId: widget.envelopeId,
      amount: amount,
      title: _titleController.text.trim().isEmpty ? l10n.quickSpendDefaultTitle : _titleController.text.trim(),
      timestamp: DateTime.now(),
      categoryTag: _selectedTag,
    );

    Navigator.of(context).pop(tx);
  }

  void _quickAddAmount(double add) {
    final normalized = AppLocalizations.normalizeNumber(_amountController.text.trim());
    final current = double.tryParse(normalized) ?? 0.0;
    _amountController.text = (current + add).toStringAsFixed(0);
  }

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;

    return Padding(
      padding: EdgeInsets.only(
        left: 20,
        right: 20,
        top: 20,
        bottom: MediaQuery.of(context).viewInsets.bottom + 20,
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(l10n.quickLogExpense, style: AppTypography.headlineMedium),
              IconButton(
                icon: const Icon(Icons.close_rounded),
                onPressed: () => Navigator.of(context).pop(),
              ),
            ],
          ),
          const SizedBox(height: 12),

          // Amount Input
          TextFormField(
            controller: _amountController,
            autofocus: true,
            keyboardType: const TextInputType.numberWithOptions(decimal: true),
            style: AppTypography.displayMedium.copyWith(color: AppColors.moduleBudgeter),
            decoration: InputDecoration(
              prefixText: '${widget.currency} ',
              hintText: l10n.formatNumber('0.00'),
            ),
          ),
          const SizedBox(height: 10),

          // Quick Preset + Buttons
          Row(
            children: [
              _buildQuickButton('+${l10n.formatNumber('5')}', 5),
              const SizedBox(width: 8),
              _buildQuickButton('+${l10n.formatNumber('10')}', 10),
              const SizedBox(width: 8),
              _buildQuickButton('+${l10n.formatNumber('25')}', 25),
              const SizedBox(width: 8),
              _buildQuickButton('+${l10n.formatNumber('50')}', 50),
            ],
          ),
          const SizedBox(height: 14),

          // Title Input
          TextFormField(
            controller: _titleController,
            style: AppTypography.bodyLarge.copyWith(color: AppColors.textPrimary),
            decoration: InputDecoration(
              labelText: l10n.expenseNote,
              floatingLabelBehavior: FloatingLabelBehavior.always,
              hintText: l10n.expenseNoteHint,
            ),
          ),
          const SizedBox(height: 14),

          // Category Tag Chips
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Row(
              children: _tags.map((tag) {
                final isSelected = _selectedTag == tag;
                final localizedTag = l10n.getLocalizedCategoryTag(tag);

                return Padding(
                  padding: const EdgeInsets.only(right: 6),
                  child: FilterChip(
                    selected: isSelected,
                    label: Text(localizedTag),
                    labelStyle: AppTypography.labelSmall.copyWith(
                      color: isSelected ? Colors.white : AppColors.textSecondary,
                    ),
                    selectedColor: AppColors.moduleBudgeter,
                    backgroundColor: AppColors.surfaceElevated,
                    side: const BorderSide(color: AppColors.cardBorder),
                    onSelected: (_) => setState(() => _selectedTag = tag),
                  ),
                );
              }).toList(),
            ),
          ),
          const SizedBox(height: 18),

          // Log Button
          SizedBox(
            width: double.infinity,
            height: 48,
            child: ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.moduleBudgeter,
                foregroundColor: Colors.white,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
              ),
              onPressed: () => _submit(l10n),
              child: Text(
                l10n.logTransaction,
                style: AppTypography.titleMedium.copyWith(color: Colors.white),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildQuickButton(String label, double val) {
    return Expanded(
      child: OutlinedButton(
        style: OutlinedButton.styleFrom(
          foregroundColor: AppColors.moduleBudgeter,
          side: const BorderSide(color: AppColors.cardBorder),
          padding: const EdgeInsets.symmetric(vertical: 8),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
        ),
        onPressed: () => _quickAddAmount(val),
        child: Text(label, style: AppTypography.labelSmall),
      ),
    );
  }
}
