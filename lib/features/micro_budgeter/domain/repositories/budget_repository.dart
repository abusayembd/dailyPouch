import 'package:fpdart/fpdart.dart';
import '../../../../core/error/failures.dart';
import '../entities/budget_envelope_entity.dart';

abstract class BudgetRepository {
  Future<Either<Failure, List<BudgetEnvelopeEntity>>> getEnvelopes();
  Future<Either<Failure, Unit>> saveEnvelope(BudgetEnvelopeEntity envelope);
  Future<Either<Failure, Unit>> deleteEnvelope(String id);

  Future<Either<Failure, List<ExpenseTransactionEntity>>> getTransactions(String envelopeId);
  Future<Either<Failure, Unit>> addTransaction(ExpenseTransactionEntity transaction);
  Future<Either<Failure, Unit>> deleteTransaction(String id, String envelopeId);
  Future<Either<Failure, String>> exportCsv(String envelopeId);
}
