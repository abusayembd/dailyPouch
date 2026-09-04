import 'package:fpdart/fpdart.dart';
import '../../../../core/error/failures.dart';
import '../../../../core/usecases/usecase.dart';
import '../entities/pantry_item_entity.dart';
import '../repositories/pantry_repository.dart';

class SavePantryItemUseCase implements UseCase<Unit, PantryItemEntity> {
  final PantryRepository repository;

  SavePantryItemUseCase(this.repository);

  @override
  Future<Either<Failure, Unit>> call(PantryItemEntity item) async {
    if (item.name.trim().isEmpty) {
      return const Left(ValidationFailure('Item name cannot be empty.'));
    }
    return await repository.savePantryItem(item);
  }
}
