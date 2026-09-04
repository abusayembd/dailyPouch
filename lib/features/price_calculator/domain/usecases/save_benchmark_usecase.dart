import 'package:fpdart/fpdart.dart';
import '../../../../core/error/failures.dart';
import '../../../../core/usecases/usecase.dart';
import '../entities/saved_benchmark_entity.dart';
import '../repositories/price_calculator_repository.dart';

class SaveBenchmarkUseCase implements UseCase<Unit, SavedBenchmarkEntity> {
  final PriceCalculatorRepository repository;

  SaveBenchmarkUseCase(this.repository);

  @override
  Future<Either<Failure, Unit>> call(SavedBenchmarkEntity benchmark) async {
    if (benchmark.title.trim().isEmpty) {
      return const Left(ValidationFailure('Benchmark title cannot be empty.'));
    }
    if (benchmark.items.isEmpty) {
      return const Left(ValidationFailure('Must have at least one item.'));
    }
    return await repository.saveBenchmark(benchmark);
  }
}
