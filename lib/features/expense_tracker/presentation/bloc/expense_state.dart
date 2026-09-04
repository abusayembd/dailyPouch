import 'package:equatable/equatable.dart';
import '../../domain/entities/expense_category.dart';
import '../../domain/entities/expense_transaction.dart';

abstract class ExpenseState extends Equatable {
  const ExpenseState();

  @override
  List<Object?> get props => [];
}

class ExpenseInitialState extends ExpenseState {
  const ExpenseInitialState();
}

class ExpenseLoadingState extends ExpenseState {
  const ExpenseLoadingState();
}

class ExpenseLoadedState extends ExpenseState {
  final List<ExpenseTransaction> allTransactions;
  final List<ExpenseTransaction> filteredTransactions;
  final FinancialSummary summary;
  final TimePeriodFilter selectedPeriod;
  final TransactionType? selectedType;
  final ExpenseCategory? selectedCategory;
  final String searchQuery;

  const ExpenseLoadedState({
    required this.allTransactions,
    required this.filteredTransactions,
    required this.summary,
    this.selectedPeriod = TimePeriodFilter.thisMonth,
    this.selectedType,
    this.selectedCategory,
    this.searchQuery = '',
  });

  ExpenseLoadedState copyWith({
    List<ExpenseTransaction>? allTransactions,
    List<ExpenseTransaction>? filteredTransactions,
    FinancialSummary? summary,
    TimePeriodFilter? selectedPeriod,
    TransactionType? Function()? selectedType,
    ExpenseCategory? Function()? selectedCategory,
    String? searchQuery,
  }) {
    return ExpenseLoadedState(
      allTransactions: allTransactions ?? this.allTransactions,
      filteredTransactions: filteredTransactions ?? this.filteredTransactions,
      summary: summary ?? this.summary,
      selectedPeriod: selectedPeriod ?? this.selectedPeriod,
      selectedType: selectedType != null ? selectedType() : this.selectedType,
      selectedCategory:
          selectedCategory != null ? selectedCategory() : this.selectedCategory,
      searchQuery: searchQuery ?? this.searchQuery,
    );
  }

  @override
  List<Object?> get props => [
        allTransactions,
        filteredTransactions,
        summary,
        selectedPeriod,
        selectedType,
        selectedCategory,
        searchQuery,
      ];
}

class ExpenseErrorState extends ExpenseState {
  final String message;

  const ExpenseErrorState(this.message);

  @override
  List<Object?> get props => [message];
}
