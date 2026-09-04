import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:uuid/uuid.dart';
import '../../../../core/currency/currency_cubit.dart';
import '../../../../core/currency/currency_entity.dart';
import '../../../../core/localization/app_localizations.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_typography.dart';
import '../../domain/entities/subscription_entity.dart';

class AddEditSubscriptionDialog extends StatefulWidget {
  final SubscriptionEntity? initial;

  const AddEditSubscriptionDialog({super.key, this.initial});

  @override
  State<AddEditSubscriptionDialog> createState() =>
      _AddEditSubscriptionDialogState();
}

class _AddEditSubscriptionDialogState extends State<AddEditSubscriptionDialog> {
  final _formKey = GlobalKey<FormState>();
  late final TextEditingController _nameController;
  late final TextEditingController _amountController;
  late final TextEditingController _notesController;

  late AppCurrency _currency;
  late BillingCycle _billingCycle;
  late SubscriptionCategory _category;
  late DateTime _nextBillingDate;
  late int _remindDays;
  late bool _isActive;
  late bool _isPaid;

  @override
  void initState() {
    super.initState();
    final item = widget.initial;
    _nameController = TextEditingController(text: item?.name ?? '');
    _amountController = TextEditingController(
      text: item != null ? item.amount.toStringAsFixed(2) : '',
    );
    _notesController = TextEditingController(text: item?.notes ?? '');

    _currency = item != null
        ? findCurrency(item.currency)
        : kSupportedCurrencies.first;
    _billingCycle = item?.billingCycle ?? BillingCycle.monthly;
    _category = item?.category ?? SubscriptionCategory.entertainment;
    _nextBillingDate =
        item?.nextBillingDate ?? DateTime.now().add(const Duration(days: 30));
    _remindDays = item?.remindDaysBefore ?? 3;
    _isActive = item?.isActive ?? true;
    _isPaid = item?.isPaid ?? false;
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
    _notesController.dispose();
    super.dispose();
  }

  Future<void> _pickDate() async {
    final picked = await showDatePicker(
      context: context,
      initialDate: _nextBillingDate,
      firstDate: DateTime.now().subtract(const Duration(days: 365)),
      lastDate: DateTime.now().add(const Duration(days: 365 * 5)),
      builder: (context, child) {
        return Theme(
          data: ThemeData.dark().copyWith(
            colorScheme: const ColorScheme.dark(
              primary: AppColors.moduleSubscription,
              surface: AppColors.surfaceCard,
            ),
          ),
          child: child!,
        );
      },
    );

    if (picked != null) {
      setState(() {
        _nextBillingDate = picked;
      });
    }
  }

  void _submit() {
    if (!_formKey.currentState!.validate()) return;

    final parsedAmount = double.tryParse(_amountController.text.trim()) ?? 0.0;
    final entity = SubscriptionEntity(
      id: widget.initial?.id ?? const Uuid().v4(),
      name: _nameController.text.trim(),
      amount: parsedAmount,
      currency: _currency.symbol,
      billingCycle: _billingCycle,
      nextBillingDate: _nextBillingDate,
      category: _category,
      remindDaysBefore: _remindDays,
      isActive: _isActive,
      isPaid: _isPaid,
      notes: _notesController.text.trim().isEmpty
          ? null
          : _notesController.text.trim(),
    );

    Navigator.of(context).pop(entity);
  }

  @override
  Widget build(BuildContext context) {
    final isEditing = widget.initial != null;
    final l10n = context.l10n;

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
                // Header
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      isEditing ? l10n.editSubscription : l10n.addSubscription,
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

                // Name input
                TextFormField(
                  controller: _nameController,
                  style: AppTypography.bodyLarge.copyWith(
                    color: AppColors.textPrimary,
                  ),
                  decoration: InputDecoration(
                    labelText: l10n.serviceNameLabel,
                    hintText: l10n.serviceNameHint,
                    prefixIcon: const Icon(
                      Icons.label_outline_rounded,
                      color: AppColors.moduleSubscription,
                    ),
                  ),
                  validator: (val) {
                    if (val == null || val.trim().isEmpty) {
                      return l10n.enterNameValidation;
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 14),

                // Amount input with central currency symbol prefix
                TextFormField(
                  controller: _amountController,
                  keyboardType: const TextInputType.numberWithOptions(
                    decimal: true,
                  ),
                  style: AppTypography.bodyLarge.copyWith(
                    color: AppColors.textPrimary,
                  ),
                  decoration: InputDecoration(
                    labelText: l10n.amountLabel,
                    hintText: '14.99',
                    prefixText: '${_currency.symbol} ',
                    prefixStyle: AppTypography.titleMedium.copyWith(color: AppColors.primaryLight),
                    prefixIcon: const Icon(
                      Icons.payments_outlined,
                      color: AppColors.moduleSubscription,
                    ),
                  ),
                  validator: (val) {
                    if (val == null || val.trim().isEmpty) {
                      return l10n.enterAmountValidation;
                    }
                    final parsed = double.tryParse(val.trim());
                    if (parsed == null || parsed <= 0) {
                      return l10n.enterValidAmountValidation;
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 14),

                // Billing Cycle Dropdown
                DropdownButtonFormField<BillingCycle>(
                  initialValue: _billingCycle,
                  dropdownColor: AppColors.surfaceElevated,
                  decoration: InputDecoration(
                    labelText: l10n.billingCycleLabel,
                    prefixIcon: const Icon(
                      Icons.repeat_rounded,
                      color: AppColors.moduleSubscription,
                    ),
                  ),
                  items: BillingCycle.values.map((cycle) {
                    return DropdownMenuItem(
                      value: cycle,
                      child: Text(
                        l10n.getBillingCycleName(cycle),
                        style: AppTypography.bodyMedium.copyWith(
                          color: AppColors.textPrimary,
                        ),
                      ),
                    );
                  }).toList(),
                  onChanged: (val) {
                    if (val != null) setState(() => _billingCycle = val);
                  },
                ),
                const SizedBox(height: 14),

                // Category Dropdown
                DropdownButtonFormField<SubscriptionCategory>(
                  initialValue: _category,
                  dropdownColor: AppColors.surfaceElevated,
                  decoration: InputDecoration(
                    labelText: l10n.categoryLabel,
                    prefixIcon: const Icon(
                      Icons.category_outlined,
                      color: AppColors.moduleSubscription,
                    ),
                  ),
                  items: SubscriptionCategory.values.map((cat) {
                    return DropdownMenuItem(
                      value: cat,
                      child: Text(
                        l10n.getSubscriptionCategoryName(cat),
                        style: AppTypography.bodyMedium.copyWith(
                          color: AppColors.textPrimary,
                        ),
                      ),
                    );
                  }).toList(),
                  onChanged: (val) {
                    if (val != null) setState(() => _category = val);
                  },
                ),
                const SizedBox(height: 14),

                // Next Billing Date Picker
                InkWell(
                  onTap: _pickDate,
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
                              Icons.calendar_month_rounded,
                              color: AppColors.moduleSubscription,
                              size: 20,
                            ),
                            const SizedBox(width: 12),
                            Text(
                              l10n.nextBillingDateLabel,
                              style: AppTypography.bodyMedium,
                            ),
                          ],
                        ),
                        Text(
                          DateFormat('MMM d, yyyy').format(_nextBillingDate),
                          style: AppTypography.titleMedium.copyWith(
                            color: AppColors.primary,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 14),

                // Reminder Days Dropdown
                DropdownButtonFormField<int>(
                  initialValue: _remindDays,
                  dropdownColor: AppColors.surfaceElevated,
                  decoration: InputDecoration(
                    labelText: l10n.renewalReminderLabel,
                    prefixIcon: const Icon(
                      Icons.notifications_active_outlined,
                      color: AppColors.moduleSubscription,
                    ),
                  ),
                  items: [
                    DropdownMenuItem(value: 7, child: Text(l10n.daysBefore(7))),
                    DropdownMenuItem(value: 3, child: Text(l10n.daysBefore(3))),
                    DropdownMenuItem(
                      value: 1,
                      child: Text(l10n.oneDayBeforeUrgent),
                    ),
                  ],
                  onChanged: (val) {
                    if (val != null) setState(() => _remindDays = val);
                  },
                ),
                const SizedBox(height: 14),

                // Paid / Unpaid Status Toggle
                SwitchListTile(
                  contentPadding: EdgeInsets.zero,
                  activeTrackColor: AppColors.success.withAlpha(150),
                  activeThumbColor: AppColors.success,
                  title: Text(
                    l10n.markAsPaid,
                    style: AppTypography.titleMedium.copyWith(fontSize: 14),
                  ),
                  subtitle: Text(
                    _isPaid
                        ? l10n.paidCycleDesc
                        : l10n.unpaidCycleDesc,
                    style: AppTypography.labelSmall.copyWith(
                      color: AppColors.textMuted,
                    ),
                  ),
                  value: _isPaid,
                  onChanged: (val) => setState(() => _isPaid = val),
                ),
                const SizedBox(height: 20),

                // Submit Button
                SizedBox(
                  width: double.infinity,
                  height: 48,
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.moduleSubscription,
                      foregroundColor: Colors.white,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(14),
                      ),
                    ),
                    onPressed: _submit,
                    child: Text(
                      isEditing ? l10n.done : l10n.addSubscription,
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
