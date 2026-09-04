import 'package:equatable/equatable.dart';
import '../../domain/entities/expense_category.dart';
import '../../domain/entities/expense_transaction.dart';

abstract class ExpenseEvent extends Equatable {
  const ExpenseEvent();

  @override
  List<Object?> get props => [];
}

class LoadExpensesEvent extends ExpenseEvent {
  final TimePeriodFilter? period;
  final ExpenseCategory? category;
  final TransactionType? type;

  const LoadExpensesEvent({
    this.period,
    this.category,
    this.type,
  });

  @override
  List<Object?> get props => [period, category, type];
}

class SaveExpenseEvent extends ExpenseEvent {
  final ExpenseTransaction transaction;

  const SaveExpenseEvent(this.transaction);

  @override
  List<Object?> get props => [transaction];
}

class DeleteExpenseEvent extends ExpenseEvent {
  final String id;

  const DeleteExpenseEvent(this.id);

  @override
  List<Object?> get props => [id];
}

class ChangePeriodFilterEvent extends ExpenseEvent {
  final TimePeriodFilter period;

  const ChangePeriodFilterEvent(this.period);

  @override
  List<Object?> get props => [period];
}

class ChangeTypeFilterEvent extends ExpenseEvent {
  final TransactionType? type;

  const ChangeTypeFilterEvent(this.type);

  @override
  List<Object?> get props => [type];
}

class ChangeCategoryFilterEvent extends ExpenseEvent {
  final ExpenseCategory? category;

  const ChangeCategoryFilterEvent(this.category);

  @override
  List<Object?> get props => [category];
}

class SearchExpensesEvent extends ExpenseEvent {
  final String query;

  const SearchExpensesEvent(this.query);

  @override
  List<Object?> get props => [query];
}
