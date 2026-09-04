import 'package:flutter_bloc/flutter_bloc.dart';
import '../../domain/entities/expense_category.dart';
import '../../domain/entities/expense_transaction.dart';
import '../../domain/usecases/expense_usecases.dart';
import 'expense_event.dart';
import 'expense_state.dart';

class ExpenseBloc extends Bloc<ExpenseEvent, ExpenseState> {
  final GetExpenseTransactionsUseCase getTransactions;
  final SaveExpenseTransactionUseCase saveTransaction;
  final DeleteExpenseTransactionUseCase deleteTransaction;

  ExpenseBloc({
    required this.getTransactions,
    required this.saveTransaction,
    required this.deleteTransaction,
  }) : super(const ExpenseInitialState()) {
    on<LoadExpensesEvent>(_onLoadExpenses);
    on<SaveExpenseEvent>(_onSaveExpense);
    on<DeleteExpenseEvent>(_onDeleteExpense);
    on<ChangePeriodFilterEvent>(_onChangePeriodFilter);
    on<ChangeTypeFilterEvent>(_onChangeTypeFilter);
    on<ChangeCategoryFilterEvent>(_onChangeCategoryFilter);
    on<SearchExpensesEvent>(_onSearchExpenses);
  }

  Future<void> _onLoadExpenses(
    LoadExpensesEvent event,
    Emitter<ExpenseState> emit,
  ) async {
    emit(const ExpenseLoadingState());
    final result = await getTransactions();

    result.fold(
      (failure) => emit(ExpenseErrorState(failure.message)),
      (transactions) {
        final period = event.period ?? TimePeriodFilter.thisMonth;
        final type = event.type;
        final category = event.category;

        final filtered = _applyFilters(
          transactions: transactions,
          period: period,
          type: type,
          category: category,
          searchQuery: '',
        );

        final periodTransactions = _filterByPeriod(transactions, period);
        final summary = FinancialSummary.fromTransactions(periodTransactions);

        emit(ExpenseLoadedState(
          allTransactions: transactions,
          filteredTransactions: filtered,
          summary: summary,
          selectedPeriod: period,
          selectedType: type,
          selectedCategory: category,
          searchQuery: '',
        ));
      },
    );
  }

  Future<void> _onSaveExpense(
    SaveExpenseEvent event,
    Emitter<ExpenseState> emit,
  ) async {
    final saveResult = await saveTransaction(event.transaction);

    await saveResult.fold(
      (failure) async => emit(ExpenseErrorState(failure.message)),
      (_) async {
        final refreshResult = await getTransactions();
        refreshResult.fold(
          (failure) => emit(ExpenseErrorState(failure.message)),
          (transactions) {
            final currentState = state;
            final period = currentState is ExpenseLoadedState
                ? currentState.selectedPeriod
                : TimePeriodFilter.thisMonth;
            final type =
                currentState is ExpenseLoadedState ? currentState.selectedType : null;
            final category = currentState is ExpenseLoadedState
                ? currentState.selectedCategory
                : null;
            final search =
                currentState is ExpenseLoadedState ? currentState.searchQuery : '';

            final filtered = _applyFilters(
              transactions: transactions,
              period: period,
              type: type,
              category: category,
              searchQuery: search,
            );
            final periodTransactions = _filterByPeriod(transactions, period);
            final summary =
                FinancialSummary.fromTransactions(periodTransactions);

            emit(ExpenseLoadedState(
              allTransactions: transactions,
              filteredTransactions: filtered,
              summary: summary,
              selectedPeriod: period,
              selectedType: type,
              selectedCategory: category,
              searchQuery: search,
            ));
          },
        );
      },
    );
  }

  Future<void> _onDeleteExpense(
    DeleteExpenseEvent event,
    Emitter<ExpenseState> emit,
  ) async {
    final deleteResult = await deleteTransaction(event.id);

    await deleteResult.fold(
      (failure) async => emit(ExpenseErrorState(failure.message)),
      (_) async {
        final refreshResult = await getTransactions();
        refreshResult.fold(
          (failure) => emit(ExpenseErrorState(failure.message)),
          (transactions) {
            final currentState = state;
            final period = currentState is ExpenseLoadedState
                ? currentState.selectedPeriod
                : TimePeriodFilter.thisMonth;
            final type =
                currentState is ExpenseLoadedState ? currentState.selectedType : null;
            final category = currentState is ExpenseLoadedState
                ? currentState.selectedCategory
                : null;
            final search =
                currentState is ExpenseLoadedState ? currentState.searchQuery : '';

            final filtered = _applyFilters(
              transactions: transactions,
              period: period,
              type: type,
              category: category,
              searchQuery: search,
            );
            final periodTransactions = _filterByPeriod(transactions, period);
            final summary =
                FinancialSummary.fromTransactions(periodTransactions);

            emit(ExpenseLoadedState(
              allTransactions: transactions,
              filteredTransactions: filtered,
              summary: summary,
              selectedPeriod: period,
              selectedType: type,
              selectedCategory: category,
              searchQuery: search,
            ));
          },
        );
      },
    );
  }

  void _onChangePeriodFilter(
    ChangePeriodFilterEvent event,
    Emitter<ExpenseState> emit,
  ) {
    if (state is! ExpenseLoadedState) return;
    final s = state as ExpenseLoadedState;

    final filtered = _applyFilters(
      transactions: s.allTransactions,
      period: event.period,
      type: s.selectedType,
      category: s.selectedCategory,
      searchQuery: s.searchQuery,
    );
    final periodTransactions = _filterByPeriod(s.allTransactions, event.period);
    final summary = FinancialSummary.fromTransactions(periodTransactions);

    emit(s.copyWith(
      selectedPeriod: event.period,
      filteredTransactions: filtered,
      summary: summary,
    ));
  }

  void _onChangeTypeFilter(
    ChangeTypeFilterEvent event,
    Emitter<ExpenseState> emit,
  ) {
    if (state is! ExpenseLoadedState) return;
    final s = state as ExpenseLoadedState;

    final filtered = _applyFilters(
      transactions: s.allTransactions,
      period: s.selectedPeriod,
      type: event.type,
      category: s.selectedCategory,
      searchQuery: s.searchQuery,
    );

    emit(s.copyWith(
      selectedType: () => event.type,
      filteredTransactions: filtered,
    ));
  }

  void _onChangeCategoryFilter(
    ChangeCategoryFilterEvent event,
    Emitter<ExpenseState> emit,
  ) {
    if (state is! ExpenseLoadedState) return;
    final s = state as ExpenseLoadedState;

    final filtered = _applyFilters(
      transactions: s.allTransactions,
      period: s.selectedPeriod,
      type: s.selectedType,
      category: event.category,
      searchQuery: s.searchQuery,
    );

    emit(s.copyWith(
      selectedCategory: () => event.category,
      filteredTransactions: filtered,
    ));
  }

  void _onSearchExpenses(
    SearchExpensesEvent event,
    Emitter<ExpenseState> emit,
  ) {
    if (state is! ExpenseLoadedState) return;
    final s = state as ExpenseLoadedState;

    final filtered = _applyFilters(
      transactions: s.allTransactions,
      period: s.selectedPeriod,
      type: s.selectedType,
      category: s.selectedCategory,
      searchQuery: event.query,
    );

    emit(s.copyWith(
      searchQuery: event.query,
      filteredTransactions: filtered,
    ));
  }

  List<ExpenseTransaction> _applyFilters({
    required List<ExpenseTransaction> transactions,
    required TimePeriodFilter period,
    required TransactionType? type,
    required ExpenseCategory? category,
    required String searchQuery,
  }) {
    return transactions.where((t) {
      // Period filter
      if (!_isInPeriod(t.date, period)) return false;

      // Type filter
      if (type != null && t.type != type) return false;

      // Category filter
      if (category != null && t.category != category) return false;

      // Search filter
      if (searchQuery.trim().isNotEmpty) {
        final query = searchQuery.trim().toLowerCase();
        final matchTitle = t.title.toLowerCase().contains(query);
        final matchNotes = t.notes?.toLowerCase().contains(query) ?? false;
        final matchCategory = t.category.displayName.toLowerCase().contains(query);
        final matchAmount = t.amount.toString().contains(query);
        if (!matchTitle && !matchNotes && !matchCategory && !matchAmount) {
          return false;
        }
      }

      return true;
    }).toList();
  }

  List<ExpenseTransaction> _filterByPeriod(
    List<ExpenseTransaction> transactions,
    TimePeriodFilter period,
  ) {
    return transactions.where((t) => _isInPeriod(t.date, period)).toList();
  }

  bool _isInPeriod(DateTime date, TimePeriodFilter period) {
    final now = DateTime.now();
    switch (period) {
      case TimePeriodFilter.today:
        return date.year == now.year &&
            date.month == now.month &&
            date.day == now.day;
      case TimePeriodFilter.thisWeek:
        final startOfWeek = now.subtract(Duration(days: now.weekday - 1));
        final zeroStart = DateTime(startOfWeek.year, startOfWeek.month, startOfWeek.day);
        return date.isAfter(zeroStart.subtract(const Duration(seconds: 1)));
      case TimePeriodFilter.thisMonth:
        return date.year == now.year && date.month == now.month;
      case TimePeriodFilter.allTime:
        return true;
    }
  }
}
