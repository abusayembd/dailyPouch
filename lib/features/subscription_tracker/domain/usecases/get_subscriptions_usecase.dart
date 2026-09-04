import 'package:fpdart/fpdart.dart';
import '../../../../core/error/failures.dart';
import '../../../../core/usecases/usecase.dart';
import '../entities/subscription_entity.dart';
import '../repositories/subscription_repository.dart';

class GetSubscriptionsUseCase implements UseCase<List<SubscriptionEntity>, NoParams> {
  final SubscriptionRepository repository;

  GetSubscriptionsUseCase(this.repository);

  @override
  Future<Either<Failure, List<SubscriptionEntity>>> call(NoParams params) async {
    return await repository.getSubscriptions();
  }
}
