import 'package:fpdart/fpdart.dart';
import '../../../../core/error/failures.dart';
import '../../../../core/usecases/usecase.dart';
import '../repositories/pantry_repository.dart';

class ToggleConsumedUseCase implements UseCase<Unit, String> {
  final PantryRepository repository;

  ToggleConsumedUseCase(this.repository);

  @override
  Future<Either<Failure, Unit>> call(String id) async {
    if (id.trim().isEmpty) {
      return const Left(ValidationFailure('Invalid pantry item ID.'));
    }
    return await repository.toggleConsumedStatus(id);
  }
}
