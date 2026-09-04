import 'package:fpdart/fpdart.dart';
import '../../../../core/error/exceptions.dart';
import '../../../../core/error/failures.dart';
import '../../domain/entities/interval_preset_entity.dart';
import '../../domain/repositories/timer_repository.dart';
import '../datasources/timer_local_datasource.dart';
import '../models/interval_preset_model.dart';

class TimerRepositoryImpl implements TimerRepository {
  final TimerLocalDataSource localDataSource;

  TimerRepositoryImpl({required this.localDataSource});

  @override
  Future<Either<Failure, List<IntervalPresetEntity>>> getPresets() async {
    try {
      final models = await localDataSource.getPresets();
      final entities = models.map((m) => m.toEntity()).toList();
      return Right(entities);
    } on DatabaseException catch (e) {
      return Left(DatabaseFailure(e.message));
    } catch (e) {
      return Left(UnexpectedFailure('Failed to get timer presets: $e'));
    }
  }

  @override
  Future<Either<Failure, Unit>> savePreset(IntervalPresetEntity preset) async {
    try {
      final model = IntervalPresetModel.fromEntity(preset);
      await localDataSource.savePreset(model);
      return const Right(unit);
    } on DatabaseException catch (e) {
      return Left(DatabaseFailure(e.message));
    } catch (e) {
      return Left(UnexpectedFailure('Failed to save timer preset: $e'));
    }
  }

  @override
  Future<Either<Failure, Unit>> deletePreset(String id) async {
    try {
      await localDataSource.deletePreset(id);
      return const Right(unit);
    } on DatabaseException catch (e) {
      return Left(DatabaseFailure(e.message));
    } catch (e) {
      return Left(UnexpectedFailure('Failed to delete timer preset: $e'));
    }
  }
}
