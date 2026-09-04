import 'package:fpdart/fpdart.dart';
import '../../../../core/error/failures.dart';
import '../../../../core/usecases/usecase.dart';
import '../repositories/subscription_repository.dart';

class DeleteSubscriptionUseCase implements UseCase<Unit, String> {
  final SubscriptionRepository repository;

  DeleteSubscriptionUseCase(this.repository);

  @override
  Future<Either<Failure, Unit>> call(String id) async {
    if (id.trim().isEmpty) {
      return const Left(ValidationFailure('Invalid subscription ID.'));
    }
    return await repository.deleteSubscription(id);
  }
}
