import 'package:fpdart/fpdart.dart';
import '../../../../core/error/failures.dart';
import '../entities/pantry_item_entity.dart';

abstract class PantryRepository {
  Future<Either<Failure, List<PantryItemEntity>>> getPantryItems();
  Future<Either<Failure, Unit>> savePantryItem(PantryItemEntity item);
  Future<Either<Failure, Unit>> deletePantryItem(String id);
  Future<Either<Failure, Unit>> toggleConsumedStatus(String id);
}
