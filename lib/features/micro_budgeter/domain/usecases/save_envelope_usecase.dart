import 'package:fpdart/fpdart.dart';
import '../../../../core/error/failures.dart';
import '../../../../core/usecases/usecase.dart';
import '../entities/budget_envelope_entity.dart';
import '../repositories/budget_repository.dart';

class SaveEnvelopeUseCase implements UseCase<Unit, BudgetEnvelopeEntity> {
  final BudgetRepository repository;

  SaveEnvelopeUseCase(this.repository);

  @override
  Future<Either<Failure, Unit>> call(BudgetEnvelopeEntity envelope) async {
    if (envelope.name.trim().isEmpty) {
      return const Left(ValidationFailure('Envelope name cannot be empty.'));
    }
    if (envelope.targetAmount <= 0) {
      return const Left(ValidationFailure('Budget amount must be greater than zero.'));
    }
    return await repository.saveEnvelope(envelope);
  }
}
