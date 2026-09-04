import 'package:fpdart/fpdart.dart';
import '../../../../core/error/failures.dart';
import '../../../../core/usecases/usecase.dart';
import '../repositories/budget_repository.dart';

class DeleteEnvelopeUseCase implements UseCase<Unit, String> {
  final BudgetRepository repository;

  DeleteEnvelopeUseCase(this.repository);

  @override
  Future<Either<Failure, Unit>> call(String id) async {
    if (id.trim().isEmpty) {
      return const Left(ValidationFailure('Invalid envelope ID.'));
    }
    return await repository.deleteEnvelope(id);
  }
}
