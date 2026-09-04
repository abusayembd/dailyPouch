import 'package:fpdart/fpdart.dart';
import '../../../../core/error/failures.dart';
import '../../../../core/usecases/usecase.dart';
import '../entities/subscription_entity.dart';
import '../repositories/subscription_repository.dart';

class SaveSubscriptionUseCase implements UseCase<Unit, SubscriptionEntity> {
  final SubscriptionRepository repository;

  SaveSubscriptionUseCase(this.repository);

  @override
  Future<Either<Failure, Unit>> call(SubscriptionEntity subscription) async {
    if (subscription.name.trim().isEmpty) {
      return const Left(ValidationFailure('Subscription name cannot be empty.'));
    }
    if (subscription.amount <= 0) {
      return const Left(ValidationFailure('Amount must be greater than zero.'));
    }
    return await repository.saveSubscription(subscription);
  }
}
