import 'package:fpdart/fpdart.dart';
import '../../../../core/error/failures.dart';
import '../../../../core/usecases/usecase.dart';
import '../entities/budget_envelope_entity.dart';
import '../repositories/budget_repository.dart';

class AddTransactionUseCase implements UseCase<Unit, ExpenseTransactionEntity> {
  final BudgetRepository repository;

  AddTransactionUseCase(this.repository);

  @override
  Future<Either<Failure, Unit>> call(ExpenseTransactionEntity transaction) async {
    if (transaction.amount <= 0) {
      return const Left(ValidationFailure('Transaction amount must be positive.'));
    }
    return await repository.addTransaction(transaction);
  }
}
