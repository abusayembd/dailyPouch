import 'package:fpdart/fpdart.dart';
import '../../../../core/error/failures.dart';
import '../../../../core/usecases/usecase.dart';
import '../entities/budget_envelope_entity.dart';
import '../repositories/budget_repository.dart';

class GetEnvelopesUseCase implements UseCase<List<BudgetEnvelopeEntity>, NoParams> {
  final BudgetRepository repository;

  GetEnvelopesUseCase(this.repository);

  @override
  Future<Either<Failure, List<BudgetEnvelopeEntity>>> call(NoParams params) async {
    return await repository.getEnvelopes();
  }
}
