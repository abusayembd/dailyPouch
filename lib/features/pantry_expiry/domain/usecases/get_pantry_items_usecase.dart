import 'package:fpdart/fpdart.dart';
import '../../../../core/error/failures.dart';
import '../../../../core/usecases/usecase.dart';
import '../entities/pantry_item_entity.dart';
import '../repositories/pantry_repository.dart';

class GetPantryItemsUseCase implements UseCase<List<PantryItemEntity>, NoParams> {
  final PantryRepository repository;

  GetPantryItemsUseCase(this.repository);

  @override
  Future<Either<Failure, List<PantryItemEntity>>> call(NoParams params) async {
    return await repository.getPantryItems();
  }
}
