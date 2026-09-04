import 'package:fpdart/fpdart.dart';
import '../../../../core/error/exceptions.dart';
import '../../../../core/error/failures.dart';
import '../../domain/entities/saved_benchmark_entity.dart';
import '../../domain/repositories/price_calculator_repository.dart';
import '../datasources/price_calculator_local_datasource.dart';
import '../models/saved_benchmark_model.dart';

class PriceCalculatorRepositoryImpl implements PriceCalculatorRepository {
  final PriceCalculatorLocalDataSource localDataSource;

  PriceCalculatorRepositoryImpl({required this.localDataSource});

  @override
  Future<Either<Failure, List<SavedBenchmarkEntity>>> getSavedBenchmarks() async {
    try {
      final models = await localDataSource.getSavedBenchmarks();
      final entities = models.map((m) => m.toEntity()).toList();
      return Right(entities);
    } on DatabaseException catch (e) {
      return Left(DatabaseFailure(e.message));
    } catch (e) {
      return Left(UnexpectedFailure('Unexpected error getting benchmarks: $e'));
    }
  }

  @override
  Future<Either<Failure, Unit>> saveBenchmark(SavedBenchmarkEntity benchmark) async {
    try {
      final model = SavedBenchmarkModel.fromEntity(benchmark);
      await localDataSource.saveBenchmark(model);
      return const Right(unit);
    } on DatabaseException catch (e) {
      return Left(DatabaseFailure(e.message));
    } catch (e) {
      return Left(UnexpectedFailure('Unexpected error saving benchmark: $e'));
    }
  }

  @override
  Future<Either<Failure, Unit>> deleteBenchmark(String id) async {
    try {
      await localDataSource.deleteBenchmark(id);
      return const Right(unit);
    } on DatabaseException catch (e) {
      return Left(DatabaseFailure(e.message));
    } catch (e) {
      return Left(UnexpectedFailure('Unexpected error deleting benchmark: $e'));
    }
  }
}
