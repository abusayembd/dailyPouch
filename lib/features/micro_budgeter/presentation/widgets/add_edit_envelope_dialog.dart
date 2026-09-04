import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:uuid/uuid.dart';
import '../../../../core/currency/currency_cubit.dart';
import '../../../../core/currency/currency_entity.dart';
import '../../../../core/localization/app_localizations.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_typography.dart';
import '../../domain/entities/budget_envelope_entity.dart';

class AddEditEnvelopeDialog extends StatefulWidget {
  final BudgetEnvelopeEntity? initial;

  const AddEditEnvelopeDialog({super.key, this.initial});

  @override
  State<AddEditEnvelopeDialog> createState() => _AddEditEnvelopeDialogState();
}

class _AddEditEnvelopeDialogState extends State<AddEditEnvelopeDialog> {
  final _formKey = GlobalKey<FormState>();
  late final TextEditingController _nameController;
  late final TextEditingController _amountController;
  late final TextEditingController _categoryController;

  late AppCurrency _currency;
  late DateTime _startDate;
  late DateTime _endDate;

  @override
  void initState() {
    super.initState();
    final item = widget.initial;
    _nameController = TextEditingController(text: item?.name ?? '');
    _amountController = TextEditingController(
      text: item != null ? item.targetAmount.toStringAsFixed(0) : '',
    );
    _categoryController = TextEditingController(
      text: item?.category ?? 'General',
    );

    _currency = item != null
        ? findCurrency(item.currency)
        : kSupportedCurrencies.first;
    _startDate = item?.startDate ?? DateTime.now();
    _endDate = item?.endDate ?? DateTime.now().add(const Duration(days: 7));
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    final globalCurrency = context.read<CurrencyCubit>().state;
    setState(() {
      _currency = globalCurrency;
    });
  }

  @override
  void dispose() {
    _nameController.dispose();
    _amountController.dispose();
    _categoryController.dispose();
    super.dispose();
  }

  Future<void> _pickDateRange() async {
    final picked = await showDateRangePicker(
      context: context,
      initialDateRange: DateTimeRange(start: _startDate, end: _endDate),
      firstDate: DateTime.now().subtract(const Duration(days: 365)),
      lastDate: DateTime.now().add(const Duration(days: 365 * 5)),
      builder: (context, child) {
        return Theme(
          data: ThemeData.dark().copyWith(
            colorScheme: const ColorScheme.dark(
              primary: AppColors.moduleBudgeter,
              surface: AppColors.surfaceCard,
            ),
          ),
          child: child!,
        );
      },
    );

    if (picked != null) {
      setState(() {
        _startDate = picked.start;
        _endDate = picked.end;
      });
    }
  }

  void _submit() {
    if (!_formKey.currentState!.validate()) return;

    final normalizedAmount = AppLocalizations.normalizeNumber(_amountController.text.trim());
    final targetAmount = double.tryParse(normalizedAmount) ?? 0.0;
    final entity = BudgetEnvelopeEntity(
      id: widget.initial?.id ?? const Uuid().v4(),
      name: _nameController.text.trim(),
      targetAmount: targetAmount,
      spentAmount: widget.initial?.spentAmount ?? 0.0,
      startDate: _startDate,
      endDate: _endDate,
      currency: _currency.symbol,
      category: _categoryController.text.trim().isEmpty
          ? 'General'
          : _categoryController.text.trim(),
      isArchived: widget.initial?.isArchived ?? false,
    );

    Navigator.of(context).pop(entity);
  }

  @override
  Widget build(BuildContext context) {
    final isEditing = widget.initial != null;
    final l10n = context.l10n;
    final dateRangeStr = l10n.formatDateRange(_startDate, _endDate);

    return Dialog(
      backgroundColor: AppColors.surfaceCard,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20),
        side: const BorderSide(color: AppColors.cardBorder),
      ),
      child: ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: 480),
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(20),
          child: Form(
            key: _formKey,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      isEditing ? l10n.editGoalEnvelope : l10n.newGoalEnvelope,
                      style: AppTypography.headlineMedium,
                    ),
                    IconButton(
                      icon: const Icon(
                        Icons.close_rounded,
                        color: AppColors.textMuted,
                      ),
                      onPressed: () => Navigator.of(context).pop(),
                    ),
                  ],
                ),
                const SizedBox(height: 16),

                // Envelope Name
                TextFormField(
                  controller: _nameController,
                  style: AppTypography.bodyLarge.copyWith(
                    color: AppColors.textPrimary,
                  ),
                  decoration: InputDecoration(
                    labelText: l10n.goalNameLabel,
                    floatingLabelBehavior: FloatingLabelBehavior.always,
                    hintText: l10n.goalNameHint,
                    prefixIcon: const Icon(
                      Icons.flight_takeoff_rounded,
                      color: AppColors.moduleBudgeter,
                    ),
                  ),
                  validator: (val) {
                    if (val == null || val.trim().isEmpty) {
                      return l10n.enterGoalName;
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 14),

                // Target Amount with Central Currency Prefix
                TextFormField(
                  controller: _amountController,
                  keyboardType: const TextInputType.numberWithOptions(
                    decimal: true,
                  ),
                  style: AppTypography.bodyLarge.copyWith(
                    color: AppColors.textPrimary,
                  ),
                  decoration: InputDecoration(
                    labelText: l10n.totalTargetBudget,
                    floatingLabelBehavior: FloatingLabelBehavior.always,
                    hintText: l10n.formatNumber('1000'),
                    prefixText: '${_currency.symbol} ',
                    prefixStyle: AppTypography.titleMedium.copyWith(color: AppColors.primaryLight),
                    prefixIcon: const Icon(
                      Icons.savings_outlined,
                      color: AppColors.moduleBudgeter,
                    ),
                  ),
                  validator: (val) {
                    if (val == null || val.trim().isEmpty) {
                      return l10n.enterBudgetAmount;
                    }
                    final normalized = AppLocalizations.normalizeNumber(val);
                    final num = double.tryParse(normalized);
                    if (num == null || num <= 0) {
                      return l10n.mustBeGreaterThanZero;
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 14),

                // Date Range Picker
                InkWell(
                  onTap: _pickDateRange,
                  borderRadius: BorderRadius.circular(14),
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 14,
                    ),
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
                            const Icon(
                              Icons.date_range_rounded,
                              color: AppColors.moduleBudgeter,
                              size: 20,
                            ),
                            const SizedBox(width: 12),
                            Text(
                              l10n.runwayDuration,
                              style: AppTypography.bodyMedium,
                            ),
                          ],
                        ),
                        Text(
                          dateRangeStr,
                          style: AppTypography.titleMedium.copyWith(
                            color: AppColors.moduleBudgeter,
                            fontSize: 13,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 20),

                // Submit Button
                SizedBox(
                  width: double.infinity,
                  height: 48,
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.moduleBudgeter,
                      foregroundColor: Colors.white,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(14),
                      ),
                    ),
                    onPressed: _submit,
                    child: Text(
                      isEditing ? l10n.saveEnvelope : l10n.createBudgetEnvelope,
                      style: AppTypography.titleMedium.copyWith(
                        color: Colors.white,
                      ),
                    ),
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
