import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:uuid/uuid.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_typography.dart';
import '../../../../core/localization/app_localizations.dart';
import '../../domain/entities/expense_category.dart';
import '../../domain/entities/expense_transaction.dart';

class AddEditTransactionSheet extends StatefulWidget {
  final ExpenseTransaction? initialTransaction;
  final TransactionType defaultType;
  final String currencySymbol;
  final Function(ExpenseTransaction) onSave;
  final Function(String)? onDelete;

  const AddEditTransactionSheet({
    super.key,
    this.initialTransaction,
    this.defaultType = TransactionType.expense,
    required this.currencySymbol,
    required this.onSave,
    this.onDelete,
  });

  @override
  State<AddEditTransactionSheet> createState() => _AddEditTransactionSheetState();
}

class _AddEditTransactionSheetState extends State<AddEditTransactionSheet> {
  final _formKey = GlobalKey<FormState>();
  late TextEditingController _titleController;
  late TextEditingController _amountController;
  late TextEditingController _notesController;

  late TransactionType _type;
  late ExpenseCategory _category;
  late PaymentMethod _paymentMethod;
  late DateTime _selectedDate;

  @override
  void initState() {
    super.initState();
    final init = widget.initialTransaction;
    _type = init?.type ?? widget.defaultType;
    _category = init?.category ??
        (_type == TransactionType.income
            ? ExpenseCategory.salary
            : ExpenseCategory.food);
    _paymentMethod = init?.paymentMethod ?? PaymentMethod.cash;
    _selectedDate = init?.date ?? DateTime.now();

    _titleController = TextEditingController(text: init?.title ?? '');
    _amountController = TextEditingController(
      text: init != null ? init.amount.toStringAsFixed(2) : '',
    );
    _notesController = TextEditingController(text: init?.notes ?? '');
  }

  @override
  void dispose() {
    _titleController.dispose();
    _amountController.dispose();
    _notesController.dispose();
    super.dispose();
  }

  void _onTypeChanged(TransactionType newType) {
    if (_type == newType) return;
    setState(() {
      _type = newType;
      if (_type == TransactionType.income) {
        if (!_category.isIncome) _category = ExpenseCategory.salary;
      } else {
        if (!_category.isExpense) _category = ExpenseCategory.food;
      }
    });
  }

  Future<void> _pickDate() async {
    final picked = await showDatePicker(
      context: context,
      initialDate: _selectedDate,
      firstDate: DateTime(2020),
      lastDate: DateTime.now().add(const Duration(days: 365)),
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: ColorScheme.light(
              primary: _type == TransactionType.income
                  ? AppColors.moduleBudgeter
                  : AppColors.primary,
            ),
          ),
          child: child!,
        );
      },
    );

    if (picked != null) {
      final time = TimeOfDay.fromDateTime(_selectedDate);
      setState(() {
        _selectedDate = DateTime(
          picked.year,
          picked.month,
          picked.day,
          time.hour,
          time.minute,
        );
      });
    }
  }

  void _submit() {
    if (!_formKey.currentState!.validate()) return;

    final amount = double.tryParse(_amountController.text.trim().replaceAll(',', '.')) ?? 0.0;
    if (amount <= 0) return;

    final transaction = ExpenseTransaction(
      id: widget.initialTransaction?.id ?? const Uuid().v4(),
      title: _titleController.text.trim().isNotEmpty
          ? _titleController.text.trim()
          : _category.displayName,
      amount: amount,
      type: _type,
      category: _category,
      date: _selectedDate,
      paymentMethod: _paymentMethod,
      notes: _notesController.text.trim().isNotEmpty ? _notesController.text.trim() : null,
    );

    widget.onSave(transaction);
    Navigator.of(context).pop();
  }

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final isEditing = widget.initialTransaction != null;
    final isIncome = _type == TransactionType.income;
    final availableCategories =
        isIncome ? ExpenseCategory.incomeCategories : ExpenseCategory.expenseCategories;

    return Container(
      decoration: const BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      padding: EdgeInsets.only(
        bottom: MediaQuery.of(context).viewInsets.bottom + 20,
        top: 16,
        left: 20,
        right: 20,
      ),
      child: Form(
        key: _formKey,
        child: SingleChildScrollView(
          physics: const BouncingScrollPhysics(),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Drag Handle
              Center(
                child: Container(
                  width: 40,
                  height: 4,
                  decoration: BoxDecoration(
                    color: AppColors.cardBorder,
                    borderRadius: BorderRadius.circular(2),
                  ),
                ),
              ),
              const SizedBox(height: 16),

              // Title & Type Selector Header
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    isEditing ? l10n.editTransaction : l10n.addTransaction,
                    style: AppTypography.headlineMedium.copyWith(
                      fontSize: 18,
                      fontWeight: FontWeight.w800,
                      color: AppColors.textPrimary,
                    ),
                  ),
                  if (isEditing && widget.onDelete != null)
                    IconButton(
                      icon: const Icon(Icons.delete_outline_rounded, color: AppColors.error),
                      onPressed: () {
                        widget.onDelete!(widget.initialTransaction!.id);
                        Navigator.of(context).pop();
                      },
                    ),
                ],
              ),
              const SizedBox(height: 16),

              // Income vs Expense Segmented Control
              Container(
                height: 44,
                padding: const EdgeInsets.all(3),
                decoration: BoxDecoration(
                  color: AppColors.background,
                  borderRadius: BorderRadius.circular(14),
                  border: Border.all(color: AppColors.cardBorder, width: 1),
                ),
                child: Row(
                  children: [
                    // Expense Tab
                    Expanded(
                      child: GestureDetector(
                        onTap: () => _onTypeChanged(TransactionType.expense),
                        child: Container(
                          decoration: BoxDecoration(
                            color: !isIncome ? AppColors.surfaceCard : Colors.transparent,
                            borderRadius: BorderRadius.circular(11),
                            boxShadow: !isIncome
                                ? [
                                    BoxShadow(
                                      color: Colors.black.withAlpha(10),
                                      blurRadius: 4,
                                      offset: const Offset(0, 2),
                                    ),
                                  ]
                                : null,
                          ),
                          alignment: Alignment.center,
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(
                                Icons.arrow_upward_rounded,
                                size: 15,
                                color: !isIncome ? AppColors.error : AppColors.textMuted,
                              ),
                              const SizedBox(width: 6),
                              Text(
                                l10n.expenseLabel,
                                style: AppTypography.titleMedium.copyWith(
                                  fontSize: 13.5,
                                  fontWeight: !isIncome ? FontWeight.w800 : FontWeight.w600,
                                  color: !isIncome ? AppColors.error : AppColors.textSecondary,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),

                    // Income Tab
                    Expanded(
                      child: GestureDetector(
                        onTap: () => _onTypeChanged(TransactionType.income),
                        child: Container(
                          decoration: BoxDecoration(
                            color: isIncome ? AppColors.surfaceCard : Colors.transparent,
                            borderRadius: BorderRadius.circular(11),
                            boxShadow: isIncome
                                ? [
                                    BoxShadow(
                                      color: Colors.black.withAlpha(10),
                                      blurRadius: 4,
                                      offset: const Offset(0, 2),
                                    ),
                                  ]
                                : null,
                          ),
                          alignment: Alignment.center,
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(
                                Icons.arrow_downward_rounded,
                                size: 15,
                                color: isIncome ? AppColors.moduleBudgeter : AppColors.textMuted,
                              ),
                              const SizedBox(width: 6),
                              Text(
                                l10n.incomeLabel,
                                style: AppTypography.titleMedium.copyWith(
                                  fontSize: 13.5,
                                  fontWeight: isIncome ? FontWeight.w800 : FontWeight.w600,
                                  color:
                                      isIncome ? AppColors.moduleBudgeter : AppColors.textSecondary,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 18),

              // Amount Input Field
              Text(
                l10n.amountLabel.toUpperCase(),
                style: AppTypography.badgeText.copyWith(
                  color: AppColors.textSecondary,
                  fontSize: 10.5,
                  fontWeight: FontWeight.w800,
                  letterSpacing: 0.5,
                ),
              ),
              const SizedBox(height: 6),
              TextFormField(
                controller: _amountController,
                keyboardType: const TextInputType.numberWithOptions(decimal: true),
                autofocus: !isEditing,
                style: AppTypography.displayLarge.copyWith(
                  fontSize: 26,
                  fontWeight: FontWeight.w800,
                  color: isIncome ? AppColors.moduleBudgeter : AppColors.textPrimary,
                ),
                decoration: InputDecoration(
                  prefixText: '${widget.currencySymbol} ',
                  prefixStyle: AppTypography.displayLarge.copyWith(
                    fontSize: 26,
                    fontWeight: FontWeight.w800,
                    color: AppColors.textSecondary,
                  ),
                  hintText: '0.00',
                  hintStyle: AppTypography.displayLarge.copyWith(
                    fontSize: 26,
                    color: AppColors.textMuted.withAlpha(120),
                  ),
                  filled: true,
                  fillColor: AppColors.background,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(14),
                    borderSide: BorderSide.none,
                  ),
                  contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
                ),
                validator: (val) {
                  if (val == null || val.trim().isEmpty) return 'Enter amount';
                  final num = double.tryParse(val.trim().replaceAll(',', '.'));
                  if (num == null || num <= 0) return 'Enter a valid amount';
                  return null;
                },
              ),

              const SizedBox(height: 16),

              // Title / Description Field
              Text(
                l10n.titleDescriptionLabel,
                style: AppTypography.badgeText.copyWith(
                  color: AppColors.textSecondary,
                  fontSize: 10.5,
                  fontWeight: FontWeight.w800,
                  letterSpacing: 0.5,
                ),
              ),
              const SizedBox(height: 6),
              TextFormField(
                controller: _titleController,
                style: AppTypography.bodyLarge.copyWith(
                  fontWeight: FontWeight.w600,
                  color: AppColors.textPrimary,
                ),
                decoration: InputDecoration(
                  hintText: 'e.g. Grocery restock, Dinner with friends',
                  hintStyle: AppTypography.bodyMedium.copyWith(color: AppColors.textMuted),
                  filled: true,
                  fillColor: AppColors.background,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(14),
                    borderSide: BorderSide.none,
                  ),
                  contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                ),
              ),

              const SizedBox(height: 18),

              // Category Selector (Horizontal Chip Wrap)
              Text(
                l10n.categoryLabel.toUpperCase(),
                style: AppTypography.badgeText.copyWith(
                  color: AppColors.textSecondary,
                  fontSize: 10.5,
                  fontWeight: FontWeight.w800,
                  letterSpacing: 0.5,
                ),
              ),
              const SizedBox(height: 8),
              Wrap(
                spacing: 8,
                runSpacing: 8,
                children: availableCategories.map((cat) {
                  final isSelected = _category == cat;
                  return ChoiceChip(
                    label: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(
                          cat.icon,
                          size: 14,
                          color: isSelected ? Colors.white : cat.color,
                        ),
                        const SizedBox(width: 6),
                        Text(l10n.getLocalizedExpenseCategoryName(cat.displayName)),
                      ],
                    ),
                    selected: isSelected,
                    selectedColor: cat.color,
                    backgroundColor: AppColors.background,
                    labelStyle: AppTypography.labelSmall.copyWith(
                      color: isSelected ? Colors.white : AppColors.textPrimary,
                      fontWeight: isSelected ? FontWeight.w700 : FontWeight.w500,
                      fontSize: 12,
                    ),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                      side: BorderSide(
                        color: isSelected ? cat.color : AppColors.cardBorder,
                        width: 1,
                      ),
                    ),
                    onSelected: (_) => setState(() => _category = cat),
                  );
                }).toList(),
              ),

              const SizedBox(height: 18),

              // Payment Method & Date Picker Row
              Row(
                children: [
                  // Payment Method Dropdown/Selector
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          l10n.paymentMethodLabel,
                          style: AppTypography.badgeText.copyWith(
                            color: AppColors.textSecondary,
                            fontSize: 10.5,
                            fontWeight: FontWeight.w800,
                            letterSpacing: 0.5,
                          ),
                        ),
                        const SizedBox(height: 6),
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                          decoration: BoxDecoration(
                            color: AppColors.background,
                            borderRadius: BorderRadius.circular(14),
                            border: Border.all(color: AppColors.cardBorder, width: 1),
                          ),
                          child: DropdownButtonHideUnderline(
                            child: DropdownButton<PaymentMethod>(
                              value: _paymentMethod,
                              isExpanded: true,
                              icon: const Icon(Icons.keyboard_arrow_down_rounded, size: 20),
                              items: PaymentMethod.values.map((pm) {
                                return DropdownMenuItem<PaymentMethod>(
                                  value: pm,
                                  child: Row(
                                    children: [
                                      Icon(pm.icon, size: 16, color: AppColors.textSecondary),
                                      const SizedBox(width: 8),
                                      Text(
                                        l10n.getLocalizedPaymentMethodName(pm.displayName),
                                        style: AppTypography.bodyMedium.copyWith(
                                          fontSize: 13,
                                          fontWeight: FontWeight.w600,
                                        ),
                                      ),
                                    ],
                                  ),
                                );
                              }).toList(),
                              onChanged: (val) {
                                if (val != null) setState(() => _paymentMethod = val);
                              },
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(width: 12),

                  // Date Picker Button
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          l10n.dateLabel,
                          style: AppTypography.badgeText.copyWith(
                            color: AppColors.textSecondary,
                            fontSize: 10.5,
                            fontWeight: FontWeight.w800,
                            letterSpacing: 0.5,
                          ),
                        ),
                        const SizedBox(height: 6),
                        InkWell(
                          onTap: _pickDate,
                          borderRadius: BorderRadius.circular(14),
                          child: Container(
                            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
                            decoration: BoxDecoration(
                              color: AppColors.background,
                              borderRadius: BorderRadius.circular(14),
                              border: Border.all(color: AppColors.cardBorder, width: 1),
                            ),
                            child: Row(
                              children: [
                                const Icon(
                                  Icons.calendar_today_rounded,
                                  size: 16,
                                  color: AppColors.textSecondary,
                                ),
                                const SizedBox(width: 8),
                                Expanded(
                                  child: Text(
                                    DateFormat('MMM d, yyyy').format(_selectedDate),
                                    style: AppTypography.bodyMedium.copyWith(
                                      fontSize: 13,
                                      fontWeight: FontWeight.w600,
                                    ),
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 16),

              // Notes Input Field
              Text(
                l10n.notesOptionalLabel,
                style: AppTypography.badgeText.copyWith(
                  color: AppColors.textSecondary,
                  fontSize: 10.5,
                  fontWeight: FontWeight.w800,
                  letterSpacing: 0.5,
                ),
              ),
              const SizedBox(height: 6),
              TextFormField(
                controller: _notesController,
                maxLines: 2,
                style: AppTypography.bodyMedium.copyWith(
                  color: AppColors.textPrimary,
                ),
                decoration: InputDecoration(
                  hintText: 'Additional remarks or reference details...',
                  hintStyle: AppTypography.bodySmall.copyWith(color: AppColors.textMuted),
                  filled: true,
                  fillColor: AppColors.background,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(14),
                    borderSide: BorderSide.none,
                  ),
                  contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                ),
              ),

              const SizedBox(height: 24),

              // Save Action Button
              SizedBox(
                width: double.infinity,
                height: 52,
                child: ElevatedButton(
                  onPressed: _submit,
                  style: ElevatedButton.styleFrom(
                    backgroundColor:
                        isIncome ? AppColors.moduleBudgeter : AppColors.primary,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16),
                    ),
                    elevation: 0,
                  ),
                  child: Text(
                    isEditing ? l10n.updateTransaction : l10n.saveTransaction,
                    style: AppTypography.titleMedium.copyWith(
                      color: Colors.white,
                      fontWeight: FontWeight.w800,
                      fontSize: 15.5,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
