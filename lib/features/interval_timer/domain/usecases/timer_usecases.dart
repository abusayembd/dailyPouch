import 'package:fpdart/fpdart.dart';
import '../../../../core/error/failures.dart';
import '../../../../core/usecases/usecase.dart';
import '../entities/interval_preset_entity.dart';
import '../repositories/timer_repository.dart';

class GetTimerPresetsUseCase implements UseCase<List<IntervalPresetEntity>, NoParams> {
  final TimerRepository repository;

  GetTimerPresetsUseCase(this.repository);

  @override
  Future<Either<Failure, List<IntervalPresetEntity>>> call(NoParams params) async {
    return await repository.getPresets();
  }
}

class SaveTimerPresetUseCase implements UseCase<Unit, IntervalPresetEntity> {
  final TimerRepository repository;

  SaveTimerPresetUseCase(this.repository);

  @override
  Future<Either<Failure, Unit>> call(IntervalPresetEntity preset) async {
    if (preset.name.trim().isEmpty) {
      return const Left(ValidationFailure('Preset name cannot be empty.'));
    }
    if (preset.workSeconds <= 0 || preset.totalSets <= 0) {
      return const Left(ValidationFailure('Work duration and sets must be > 0.'));
    }
    return await repository.savePreset(preset);
  }
}
