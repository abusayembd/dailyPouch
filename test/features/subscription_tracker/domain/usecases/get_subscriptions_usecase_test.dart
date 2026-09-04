import 'package:flutter_test/flutter_test.dart';
import 'package:fpdart/fpdart.dart';
import 'package:mocktail/mocktail.dart';
import 'package:dailypouch/core/usecases/usecase.dart';
import 'package:dailypouch/features/subscription_tracker/domain/entities/subscription_entity.dart';
import 'package:dailypouch/features/subscription_tracker/domain/repositories/subscription_repository.dart';
import 'package:dailypouch/features/subscription_tracker/domain/usecases/get_subscriptions_usecase.dart';

class MockSubscriptionRepository extends Mock implements SubscriptionRepository {}

void main() {
  late GetSubscriptionsUseCase useCase;
  late MockSubscriptionRepository mockRepository;

  setUp(() {
    mockRepository = MockSubscriptionRepository();
    useCase = GetSubscriptionsUseCase(mockRepository);
  });

  final testSubscription = SubscriptionEntity(
    id: 'sub_1',
    name: 'Netflix',
    amount: 15.99,
    billingCycle: BillingCycle.monthly,
    nextBillingDate: DateTime(2026, 10, 1),
    category: SubscriptionCategory.entertainment,
  );

  test('should get subscriptions from the repository', () async {
    when(() => mockRepository.getSubscriptions())
        .thenAnswer((_) async => Right([testSubscription]));

    final result = await useCase(const NoParams());

    expect(result.isRight(), true);
    result.fold(
      (failure) => fail('Should succeed'),
      (list) {
        expect(list, equals([testSubscription]));
      },
    );
    verify(() => mockRepository.getSubscriptions()).called(1);
    verifyNoMoreInteractions(mockRepository);
  });
}
