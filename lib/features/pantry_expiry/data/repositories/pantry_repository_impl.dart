import 'package:fpdart/fpdart.dart';
import '../../../../core/error/exceptions.dart';
import '../../../../core/error/failures.dart';
import '../../domain/entities/pantry_item_entity.dart';
import '../../domain/repositories/pantry_repository.dart';
import '../datasources/pantry_local_datasource.dart';
import '../models/pantry_item_model.dart';

class PantryRepositoryImpl implements PantryRepository {
  final PantryLocalDataSource localDataSource;

  PantryRepositoryImpl({required this.localDataSource});

  @override
  Future<Either<Failure, List<PantryItemEntity>>> getPantryItems() async {
    try {
      final models = await localDataSource.getPantryItems();
      final entities = models.map((m) => m.toEntity()).toList();
      return Right(entities);
    } on DatabaseException catch (e) {
      return Left(DatabaseFailure(e.message));
    } catch (e) {
      return Left(UnexpectedFailure('Unexpected error getting pantry items: $e'));
    }
  }

  @override
  Future<Either<Failure, Unit>> savePantryItem(PantryItemEntity item) async {
    try {
      final model = PantryItemModel.fromEntity(item);
      await localDataSource.savePantryItem(model);
      return const Right(unit);
    } on DatabaseException catch (e) {
      return Left(DatabaseFailure(e.message));
    } catch (e) {
      return Left(UnexpectedFailure('Unexpected error saving pantry item: $e'));
    }
  }

  @override
  Future<Either<Failure, Unit>> deletePantryItem(String id) async {
    try {
      await localDataSource.deletePantryItem(id);
      return const Right(unit);
    } on DatabaseException catch (e) {
      return Left(DatabaseFailure(e.message));
    } catch (e) {
      return Left(UnexpectedFailure('Unexpected error deleting pantry item: $e'));
    }
  }

  @override
  Future<Either<Failure, Unit>> toggleConsumedStatus(String id) async {
    try {
      await localDataSource.toggleConsumedStatus(id);
      return const Right(unit);
    } on DatabaseException catch (e) {
      return Left(DatabaseFailure(e.message));
    } catch (e) {
      return Left(UnexpectedFailure('Unexpected error toggling consumed status: $e'));
    }
  }
}
