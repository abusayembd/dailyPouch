import 'package:fpdart/fpdart.dart';
import '../../../../core/error/exceptions.dart';
import '../../../../core/error/failures.dart';
import '../../domain/entities/subscription_entity.dart';
import '../../domain/repositories/subscription_repository.dart';
import '../datasources/subscription_local_datasource.dart';
import '../models/subscription_model.dart';

class SubscriptionRepositoryImpl implements SubscriptionRepository {
  final SubscriptionLocalDataSource localDataSource;

  SubscriptionRepositoryImpl({required this.localDataSource});

  @override
  Future<Either<Failure, List<SubscriptionEntity>>> getSubscriptions() async {
    try {
      final models = await localDataSource.getSubscriptions();
      final entities = models.map((m) => m.toEntity()).toList();
      return Right(entities);
    } on DatabaseException catch (e) {
      return Left(DatabaseFailure(e.message));
    } catch (e) {
      return Left(UnexpectedFailure('Unexpected error getting subscriptions: $e'));
    }
  }

  @override
  Future<Either<Failure, Unit>> saveSubscription(SubscriptionEntity subscription) async {
    try {
      final model = SubscriptionModel.fromEntity(subscription);
      await localDataSource.saveSubscription(model);
      return const Right(unit);
    } on DatabaseException catch (e) {
      return Left(DatabaseFailure(e.message));
    } catch (e) {
      return Left(UnexpectedFailure('Unexpected error saving subscription: $e'));
    }
  }

  @override
  Future<Either<Failure, Unit>> deleteSubscription(String id) async {
    try {
      await localDataSource.deleteSubscription(id);
      return const Right(unit);
    } on DatabaseException catch (e) {
      return Left(DatabaseFailure(e.message));
    } catch (e) {
      return Left(UnexpectedFailure('Unexpected error deleting subscription: $e'));
    }
  }

  @override
  Future<Either<Failure, Unit>> toggleSubscriptionStatus(String id) async {
    try {
      await localDataSource.toggleSubscriptionStatus(id);
      return const Right(unit);
    } on DatabaseException catch (e) {
      return Left(DatabaseFailure(e.message));
    } catch (e) {
      return Left(UnexpectedFailure('Unexpected error toggling subscription: $e'));
    }
  }
}
