import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../core/currency/currency_cubit.dart';
import '../../../../core/localization/app_localizations.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_typography.dart';
import '../../../../core/widgets/custom_app_bar.dart';
import '../../domain/entities/expense_transaction.dart';
import '../bloc/expense_bloc.dart';
import '../bloc/expense_event.dart';
import '../bloc/expense_state.dart';
import '../widgets/add_edit_transaction_sheet.dart';
import '../widgets/category_breakdown_view.dart';
import '../widgets/spending_summary_card.dart';
import '../widgets/transaction_list_tile.dart';

class ExpenseTrackerPage extends StatefulWidget {
  const ExpenseTrackerPage({super.key});

  @override
  State<ExpenseTrackerPage> createState() => _ExpenseTrackerPageState();
}

class _ExpenseTrackerPageState extends State<ExpenseTrackerPage> {
  final TextEditingController _searchController = TextEditingController();
  bool _showCategoryBreakdown = true;

  @override
  void initState() {
    super.initState();
    context.read<ExpenseBloc>().add(const LoadExpensesEvent());
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  void _openAddTransactionSheet(BuildContext context, {TransactionType type = TransactionType.expense}) {
    final currencySymbol = context.read<CurrencyCubit>().currentSymbol;
    final bloc = context.read<ExpenseBloc>();

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (ctx) => AddEditTransactionSheet(
        defaultType: type,
        currencySymbol: currencySymbol,
        onSave: (transaction) {
          bloc.add(SaveExpenseEvent(transaction));
        },
      ),
    );
  }

  void _openEditTransactionSheet(BuildContext context, ExpenseTransaction transaction) {
    final currencySymbol = context.read<CurrencyCubit>().currentSymbol;
    final bloc = context.read<ExpenseBloc>();

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (ctx) => AddEditTransactionSheet(
        initialTransaction: transaction,
        currencySymbol: currencySymbol,
        onSave: (updated) {
          bloc.add(SaveExpenseEvent(updated));
        },
        onDelete: (id) {
          bloc.add(DeleteExpenseEvent(id));
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final currencySymbol = context.watch<CurrencyCubit>().currentSymbol;

    return Scaffold(
      appBar: CustomAppBar(
        title: l10n.getModuleTitle('expense_tracker'),
        subtitle: l10n.getModuleDescription('expense_tracker'),
        accentColor: AppColors.moduleBudgeter,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new_rounded),
          onPressed: () => Navigator.of(context).pop(),
        ),
        actions: [
          IconButton(
            icon: Icon(
              _showCategoryBreakdown ? Icons.pie_chart_rounded : Icons.pie_chart_outline_rounded,
              color: AppColors.moduleBudgeter,
            ),
            tooltip: 'Toggle Category Breakdown',
            onPressed: () {
              setState(() {
                _showCategoryBreakdown = !_showCategoryBreakdown;
              });
            },
          ),
        ],
      ),
      body: BlocBuilder<ExpenseBloc, ExpenseState>(
        builder: (context, state) {
          if (state is ExpenseLoadingState) {
            return const Center(
              child: CircularProgressIndicator(color: AppColors.moduleBudgeter),
            );
          }

          if (state is ExpenseErrorState) {
            return Center(
              child: Padding(
                padding: const EdgeInsets.all(24),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Icon(Icons.error_outline_rounded, size: 48, color: AppColors.error),
                    const SizedBox(height: 12),
                    Text(state.message, style: AppTypography.bodyMedium),
                    const SizedBox(height: 16),
                    ElevatedButton(
                      onPressed: () => context.read<ExpenseBloc>().add(const LoadExpensesEvent()),
                      child: Text(l10n.retry),
                    ),
                  ],
                ),
              ),
            );
          }

          if (state is! ExpenseLoadedState) {
            return const SizedBox.shrink();
          }

          final summary = state.summary;
          final transactions = state.filteredTransactions;
          final selectedPeriod = state.selectedPeriod;

          return Column(
            children: [
              // Scrollable Content
              Expanded(
                child: SingleChildScrollView(
                  physics: const BouncingScrollPhysics(),
                  padding: const EdgeInsets.fromLTRB(16, 12, 16, 100),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // 1. Period Selector Chips Row
                      SingleChildScrollView(
                        scrollDirection: Axis.horizontal,
                        physics: const BouncingScrollPhysics(),
                        child: Row(
                          children: TimePeriodFilter.values.map((period) {
                            final isSelected = selectedPeriod == period;
                            return Padding(
                              padding: const EdgeInsets.only(right: 8),
                              child: ChoiceChip(
                                label: Text(period.displayName),
                                selected: isSelected,
                                selectedColor: AppColors.moduleBudgeter,
                                backgroundColor: AppColors.surfaceCard,
                                labelStyle: AppTypography.labelSmall.copyWith(
                                  color: isSelected ? Colors.white : AppColors.textSecondary,
                                  fontWeight: isSelected ? FontWeight.w800 : FontWeight.w600,
                                ),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(12),
                                  side: BorderSide(
                                    color: isSelected
                                        ? AppColors.moduleBudgeter
                                        : AppColors.cardBorder,
                                    width: 1,
                                  ),
                                ),
                                onSelected: (_) {
                                  context
                                      .read<ExpenseBloc>()
                                      .add(ChangePeriodFilterEvent(period));
                                },
                              ),
                            );
                          }).toList(),
                        ),
                      ),
                      const SizedBox(height: 12),

                      // 2. Financial Summary Card
                      SpendingSummaryCard(
                        summary: summary,
                        period: selectedPeriod,
                        currencySymbol: currencySymbol,
                      ),
                      const SizedBox(height: 16),

                      // 3. Category Breakdown (Collapsible)
                      if (_showCategoryBreakdown) ...[
                        CategoryBreakdownView(
                          categorySpending: summary.categorySpending,
                          totalExpense: summary.totalExpense,
                          currencySymbol: currencySymbol,
                          selectedCategory: state.selectedCategory,
                          onCategorySelected: (cat) {
                            context
                                .read<ExpenseBloc>()
                                .add(ChangeCategoryFilterEvent(cat));
                          },
                        ),
                        const SizedBox(height: 16),
                      ],

                      // 4. Search & Filter Bar
                      Row(
                        children: [
                          Expanded(
                            child: Container(
                              height: 42,
                              decoration: BoxDecoration(
                                color: AppColors.surfaceCard,
                                borderRadius: BorderRadius.circular(12),
                                border: Border.all(color: AppColors.cardBorder, width: 1),
                              ),
                              child: TextField(
                                controller: _searchController,
                                onChanged: (val) {
                                  context
                                      .read<ExpenseBloc>()
                                      .add(SearchExpensesEvent(val));
                                },
                                style: AppTypography.bodyMedium.copyWith(fontSize: 13),
                                decoration: InputDecoration(
                                  hintText: l10n.searchHint,
                                  hintStyle: AppTypography.bodySmall.copyWith(
                                    color: AppColors.textMuted,
                                    fontSize: 12.5,
                                  ),
                                  prefixIcon: const Icon(
                                    Icons.search_rounded,
                                    size: 18,
                                    color: AppColors.textMuted,
                                  ),
                                  suffixIcon: _searchController.text.isNotEmpty
                                      ? IconButton(
                                          icon: const Icon(Icons.clear_rounded, size: 16),
                                          onPressed: () {
                                            _searchController.clear();
                                            context
                                                .read<ExpenseBloc>()
                                                .add(const SearchExpensesEvent(''));
                                          },
                                        )
                                      : null,
                                  border: InputBorder.none,
                                  contentPadding: const EdgeInsets.symmetric(vertical: 10),
                                ),
                              ),
                            ),
                          ),
                          const SizedBox(width: 8),

                          // Type Filter Segmented Popover / Filter Buttons
                          Container(
                            height: 42,
                            padding: const EdgeInsets.symmetric(horizontal: 4),
                            decoration: BoxDecoration(
                              color: AppColors.surfaceCard,
                              borderRadius: BorderRadius.circular(12),
                              border: Border.all(color: AppColors.cardBorder, width: 1),
                            ),
                            child: Row(
                              children: [
                                _buildTypeFilterChip(
                                  context: context,
                                  label: l10n.allTools,
                                  isSelected: state.selectedType == null,
                                  onTap: () => context
                                      .read<ExpenseBloc>()
                                      .add(const ChangeTypeFilterEvent(null)),
                                ),
                                _buildTypeFilterChip(
                                  context: context,
                                  label: l10n.expenseLabel,
                                  isSelected: state.selectedType == TransactionType.expense,
                                  onTap: () => context
                                      .read<ExpenseBloc>()
                                      .add(const ChangeTypeFilterEvent(TransactionType.expense)),
                                ),
                                _buildTypeFilterChip(
                                  context: context,
                                  label: l10n.incomeLabel,
                                  isSelected: state.selectedType == TransactionType.income,
                                  onTap: () => context
                                      .read<ExpenseBloc>()
                                      .add(const ChangeTypeFilterEvent(TransactionType.income)),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 16),

                      // 5. Section Header: Transactions
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            l10n.recentTransactions.toUpperCase(),
                            style: AppTypography.badgeText.copyWith(
                              color: AppColors.textSecondary,
                              fontSize: 11,
                              fontWeight: FontWeight.w800,
                              letterSpacing: 0.8,
                            ),
                          ),
                          Text(
                            l10n.transactionEntries(transactions.length),
                            style: AppTypography.labelSmall.copyWith(
                              color: AppColors.textMuted,
                              fontSize: 11,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 10),

                      // 6. Transactions List or Empty State
                      if (transactions.isEmpty)
                        _buildEmptyState(context, l10n)
                      else
                        ...transactions.map(
                          (t) => TransactionListTile(
                            transaction: t,
                            currencySymbol: currencySymbol,
                            onTap: () => _openEditTransactionSheet(context, t),
                            onDelete: () {
                              context.read<ExpenseBloc>().add(DeleteExpenseEvent(t.id));
                            },
                          ),
                        ),
                    ],
                  ),
                ),
              ),
            ],
          );
        },
      ),

      // Bottom Action Dock with Dual Action Buttons (+ Income, - Expense)
      bottomNavigationBar: SafeArea(
        child: Container(
          padding: const EdgeInsets.fromLTRB(16, 10, 16, 12),
          decoration: BoxDecoration(
            color: AppColors.surface,
            border: const Border(top: BorderSide(color: AppColors.cardBorder, width: 1)),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withAlpha(8),
                blurRadius: 10,
                offset: const Offset(0, -3),
              ),
            ],
          ),
          child: Row(
            children: [
              // + Add Income Button
              Expanded(
                child: SizedBox(
                  height: 48,
                  child: ElevatedButton.icon(
                    onPressed: () => _openAddTransactionSheet(
                      context,
                      type: TransactionType.income,
                    ),
                    icon: const Icon(Icons.add_rounded, size: 18, color: Colors.white),
                    label: Text(
                      l10n.incomeLabel,
                      style: AppTypography.titleMedium.copyWith(
                        color: Colors.white,
                        fontWeight: FontWeight.w800,
                        fontSize: 14.5,
                      ),
                    ),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF10B981),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(14),
                      ),
                      elevation: 0,
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 12),

              // - Add Expense Button
              Expanded(
                child: SizedBox(
                  height: 48,
                  child: ElevatedButton.icon(
                    onPressed: () => _openAddTransactionSheet(
                      context,
                      type: TransactionType.expense,
                    ),
                    icon: const Icon(Icons.remove_rounded, size: 18, color: Colors.white),
                    label: Text(
                      l10n.expenseLabel,
                      style: AppTypography.titleMedium.copyWith(
                        color: Colors.white,
                        fontWeight: FontWeight.w800,
                        fontSize: 14.5,
                      ),
                    ),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFFEF4444),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(14),
                      ),
                      elevation: 0,
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

  Widget _buildTypeFilterChip({
    required BuildContext context,
    required String label,
    required bool isSelected,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
        decoration: BoxDecoration(
          color: isSelected ? AppColors.textPrimary : Colors.transparent,
          borderRadius: BorderRadius.circular(8),
        ),
        child: Text(
          label,
          style: AppTypography.labelSmall.copyWith(
            color: isSelected ? Colors.white : AppColors.textSecondary,
            fontWeight: isSelected ? FontWeight.w800 : FontWeight.w600,
            fontSize: 11,
          ),
        ),
      ),
    );
  }

  Widget _buildEmptyState(BuildContext context, AppLocalizations l10n) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(vertical: 36, horizontal: 20),
      decoration: BoxDecoration(
        color: AppColors.surfaceCard,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: AppColors.cardBorder, width: 1),
      ),
      child: Column(
        children: [
          Container(
            width: 56,
            height: 56,
            decoration: BoxDecoration(
              color: AppColors.moduleBudgeter.withAlpha(25),
              shape: BoxShape.circle,
            ),
            child: const Icon(
              Icons.receipt_long_rounded,
              size: 28,
              color: AppColors.moduleBudgeter,
            ),
          ),
          const SizedBox(height: 14),
          Text(
            l10n.noTransactions,
            style: AppTypography.headlineMedium.copyWith(
              fontSize: 16,
              fontWeight: FontWeight.w700,
              color: AppColors.textPrimary,
            ),
          ),
          const SizedBox(height: 6),
          Text(
            l10n.noTransactionsDesc,
            textAlign: TextAlign.center,
            style: AppTypography.bodyMedium.copyWith(
              color: AppColors.textSecondary,
              fontSize: 12.5,
              height: 1.4,
            ),
          ),
        ],
      ),
    );
  }
}
