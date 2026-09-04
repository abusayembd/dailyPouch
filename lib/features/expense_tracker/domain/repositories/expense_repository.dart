import 'package:fpdart/fpdart.dart';
import '../../../../core/error/failures.dart';
import '../entities/expense_transaction.dart';

/// Abstract contract for the Expense Tracker repository.
abstract class ExpenseRepository {
  /// Fetches all transactions from local persistent storage.
  Future<Either<Failure, List<ExpenseTransaction>>> getTransactions();

  /// Adds a new transaction or updates an existing one.
  Future<Either<Failure, void>> saveTransaction(ExpenseTransaction transaction);

  /// Deletes a transaction by its unique ID.
  Future<Either<Failure, void>> deleteTransaction(String id);

  /// Calculates the financial summary for a given time period.
  Future<Either<Failure, FinancialSummary>> getSummary({
    DateTime? startDate,
    DateTime? endDate,
  });
}
