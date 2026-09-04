import 'package:fpdart/fpdart.dart';
import '../../../../core/error/failures.dart';
import '../../../../core/usecases/usecase.dart';
import '../entities/budget_envelope_entity.dart';
import '../repositories/budget_repository.dart';

class GetTransactionsUseCase implements UseCase<List<ExpenseTransactionEntity>, String> {
  final BudgetRepository repository;

  GetTransactionsUseCase(this.repository);

  @override
  Future<Either<Failure, List<ExpenseTransactionEntity>>> call(String envelopeId) async {
    return await repository.getTransactions(envelopeId);
  }
}
