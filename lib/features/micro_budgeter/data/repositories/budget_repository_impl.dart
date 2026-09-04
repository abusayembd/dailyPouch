import 'package:fpdart/fpdart.dart';
import '../../../../core/error/exceptions.dart';
import '../../../../core/error/failures.dart';
import '../../domain/entities/budget_envelope_entity.dart';
import '../../domain/repositories/budget_repository.dart';
import '../datasources/budget_local_datasource.dart';
import '../models/budget_envelope_model.dart';
import '../models/expense_transaction_model.dart';

class BudgetRepositoryImpl implements BudgetRepository {
  final BudgetLocalDataSource localDataSource;

  BudgetRepositoryImpl({required this.localDataSource});

  @override
  Future<Either<Failure, List<BudgetEnvelopeEntity>>> getEnvelopes() async {
    try {
      final models = await localDataSource.getEnvelopes();
      final entities = models.map((m) => m.toEntity()).toList();
      return Right(entities);
    } on DatabaseException catch (e) {
      return Left(DatabaseFailure(e.message));
    } catch (e) {
      return Left(UnexpectedFailure('Failed to get budget envelopes: $e'));
    }
  }

  @override
  Future<Either<Failure, Unit>> saveEnvelope(BudgetEnvelopeEntity envelope) async {
    try {
      final model = BudgetEnvelopeModel.fromEntity(envelope);
      await localDataSource.saveEnvelope(model);
      return const Right(unit);
    } on DatabaseException catch (e) {
      return Left(DatabaseFailure(e.message));
    } catch (e) {
      return Left(UnexpectedFailure('Failed to save envelope: $e'));
    }
  }

  @override
  Future<Either<Failure, Unit>> deleteEnvelope(String id) async {
    try {
      await localDataSource.deleteEnvelope(id);
      return const Right(unit);
    } on DatabaseException catch (e) {
      return Left(DatabaseFailure(e.message));
    } catch (e) {
      return Left(UnexpectedFailure('Failed to delete envelope: $e'));
    }
  }

  @override
  Future<Either<Failure, List<ExpenseTransactionEntity>>> getTransactions(String envelopeId) async {
    try {
      final models = await localDataSource.getTransactions(envelopeId);
      final entities = models.map((m) => m.toEntity()).toList();
      return Right(entities);
    } on DatabaseException catch (e) {
      return Left(DatabaseFailure(e.message));
    } catch (e) {
      return Left(UnexpectedFailure('Failed to get transactions: $e'));
    }
  }

  @override
  Future<Either<Failure, Unit>> addTransaction(ExpenseTransactionEntity transaction) async {
    try {
      final model = ExpenseTransactionModel.fromEntity(transaction);
      await localDataSource.addTransaction(model);
      return const Right(unit);
    } on DatabaseException catch (e) {
      return Left(DatabaseFailure(e.message));
    } catch (e) {
      return Left(UnexpectedFailure('Failed to add transaction: $e'));
    }
  }

  @override
  Future<Either<Failure, Unit>> deleteTransaction(String id, String envelopeId) async {
    try {
      await localDataSource.deleteTransaction(id, envelopeId);
      return const Right(unit);
    } on DatabaseException catch (e) {
      return Left(DatabaseFailure(e.message));
    } catch (e) {
      return Left(UnexpectedFailure('Failed to delete transaction: $e'));
    }
  }

  @override
  Future<Either<Failure, String>> exportCsv(String envelopeId) async {
    try {
      final transactions = await localDataSource.getTransactions(envelopeId);
      final buffer = StringBuffer();
      buffer.writeln('ID,Date,Title,Category,Amount');
      for (final t in transactions) {
        buffer.writeln('${t.id},${t.timestamp},"${t.title}","${t.categoryTag}",${t.amount}');
      }
      return Right(buffer.toString());
    } catch (e) {
      return Left(UnexpectedFailure('CSV export failed: $e'));
    }
  }
}
