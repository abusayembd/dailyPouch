import 'package:fpdart/fpdart.dart';
import '../../../../core/error/failures.dart';
import '../entities/expense_transaction.dart';
import '../repositories/expense_repository.dart';

/// Fetches all transactions from local storage for the Expense Tracker.
class GetExpenseTransactionsUseCase {
  final ExpenseRepository repository;

  GetExpenseTransactionsUseCase(this.repository);

  Future<Either<Failure, List<ExpenseTransaction>>> call() {
    return repository.getTransactions();
  }
}

/// Saves or updates a transaction in local storage.
class SaveExpenseTransactionUseCase {
  final ExpenseRepository repository;

  SaveExpenseTransactionUseCase(this.repository);

  Future<Either<Failure, void>> call(ExpenseTransaction transaction) {
    return repository.saveTransaction(transaction);
  }
}

/// Deletes a transaction by ID.
class DeleteExpenseTransactionUseCase {
  final ExpenseRepository repository;

  DeleteExpenseTransactionUseCase(this.repository);

  Future<Either<Failure, void>> call(String id) {
    return repository.deleteTransaction(id);
  }
}

/// Calculates financial summary metrics.
class GetExpenseSummaryUseCase {
  final ExpenseRepository repository;

  GetExpenseSummaryUseCase(this.repository);

  Future<Either<Failure, FinancialSummary>> call({
    DateTime? startDate,
    DateTime? endDate,
  }) {
    return repository.getSummary(
      startDate: startDate,
      endDate: endDate,
    );
  }
}
