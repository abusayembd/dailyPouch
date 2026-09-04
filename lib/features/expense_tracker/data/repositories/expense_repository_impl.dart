import 'package:fpdart/fpdart.dart';
import '../../../../core/error/exceptions.dart';
import '../../../../core/error/failures.dart';
import '../../domain/entities/expense_transaction.dart';
import '../../domain/repositories/expense_repository.dart';
import '../datasources/expense_local_datasource.dart';
import '../models/expense_transaction_model.dart';

class ExpenseRepositoryImpl implements ExpenseRepository {
  final ExpenseLocalDataSource localDataSource;

  ExpenseRepositoryImpl({required this.localDataSource});

  @override
  Future<Either<Failure, List<ExpenseTransaction>>> getTransactions() async {
    try {
      final models = await localDataSource.getTransactions();
      return Right(models);
    } on DatabaseException catch (e) {
      return Left(DatabaseFailure(e.message));
    } catch (e) {
      return Left(DatabaseFailure('Unexpected error loading expenses: $e'));
    }
  }

  @override
  Future<Either<Failure, void>> saveTransaction(ExpenseTransaction transaction) async {
    try {
      final model = ExpenseTransactionModel.fromEntity(transaction);
      await localDataSource.saveTransaction(model);
      return const Right(null);
    } on DatabaseException catch (e) {
      return Left(DatabaseFailure(e.message));
    } catch (e) {
      return Left(DatabaseFailure('Unexpected error saving expense: $e'));
    }
  }

  @override
  Future<Either<Failure, void>> deleteTransaction(String id) async {
    try {
      await localDataSource.deleteTransaction(id);
      return const Right(null);
    } on DatabaseException catch (e) {
      return Left(DatabaseFailure(e.message));
    } catch (e) {
      return Left(DatabaseFailure('Unexpected error deleting expense: $e'));
    }
  }

  @override
  Future<Either<Failure, FinancialSummary>> getSummary({
    DateTime? startDate,
    DateTime? endDate,
  }) async {
    try {
      final transactions = await localDataSource.getTransactions();
      final filtered = transactions.where((t) {
        if (startDate != null && t.date.isBefore(startDate)) return false;
        if (endDate != null && t.date.isAfter(endDate)) return false;
        return true;
      }).toList();

      final summary = FinancialSummary.fromTransactions(filtered);
      return Right(summary);
    } on DatabaseException catch (e) {
      return Left(DatabaseFailure(e.message));
    } catch (e) {
      return Left(DatabaseFailure('Unexpected error calculating summary: $e'));
    }
  }
}
