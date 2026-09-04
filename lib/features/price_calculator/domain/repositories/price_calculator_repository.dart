import 'package:fpdart/fpdart.dart';
import '../../../../core/error/failures.dart';
import '../entities/saved_benchmark_entity.dart';

abstract class PriceCalculatorRepository {
  Future<Either<Failure, List<SavedBenchmarkEntity>>> getSavedBenchmarks();
  Future<Either<Failure, Unit>> saveBenchmark(SavedBenchmarkEntity benchmark);
  Future<Either<Failure, Unit>> deleteBenchmark(String id);
}
