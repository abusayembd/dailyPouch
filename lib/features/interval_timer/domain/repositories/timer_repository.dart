import 'package:fpdart/fpdart.dart';
import '../../../../core/error/failures.dart';
import '../entities/interval_preset_entity.dart';

abstract class TimerRepository {
  Future<Either<Failure, List<IntervalPresetEntity>>> getPresets();
  Future<Either<Failure, Unit>> savePreset(IntervalPresetEntity preset);
  Future<Either<Failure, Unit>> deletePreset(String id);
}
