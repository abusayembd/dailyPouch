import 'package:fpdart/fpdart.dart';
import '../../../../core/error/failures.dart';
import '../../../../core/usecases/usecase.dart';
import '../entities/saved_benchmark_entity.dart';
import '../repositories/price_calculator_repository.dart';

class GetSavedBenchmarksUseCase implements UseCase<List<SavedBenchmarkEntity>, NoParams> {
  final PriceCalculatorRepository repository;

  GetSavedBenchmarksUseCase(this.repository);

  @override
  Future<Either<Failure, List<SavedBenchmarkEntity>>> call(NoParams params) async {
    return await repository.getSavedBenchmarks();
  }
}
