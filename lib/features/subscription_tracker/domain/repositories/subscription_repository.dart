import 'package:fpdart/fpdart.dart';
import '../../../../core/error/failures.dart';
import '../entities/subscription_entity.dart';

abstract class SubscriptionRepository {
  Future<Either<Failure, List<SubscriptionEntity>>> getSubscriptions();
  Future<Either<Failure, Unit>> saveSubscription(SubscriptionEntity subscription);
  Future<Either<Failure, Unit>> deleteSubscription(String id);
  Future<Either<Failure, Unit>> toggleSubscriptionStatus(String id);
}
