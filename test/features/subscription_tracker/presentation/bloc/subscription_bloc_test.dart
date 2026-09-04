import 'package:bloc_test/bloc_test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:fpdart/fpdart.dart';
import 'package:mocktail/mocktail.dart';
import 'package:dailypouch/core/error/failures.dart';
import 'package:dailypouch/core/usecases/usecase.dart';
import 'package:dailypouch/features/subscription_tracker/domain/entities/subscription_entity.dart';
import 'package:dailypouch/features/subscription_tracker/domain/repositories/subscription_repository.dart';
import 'package:dailypouch/features/subscription_tracker/domain/usecases/delete_subscription_usecase.dart';
import 'package:dailypouch/features/subscription_tracker/domain/usecases/get_subscriptions_usecase.dart';
import 'package:dailypouch/features/subscription_tracker/domain/usecases/save_subscription_usecase.dart';
import 'package:dailypouch/features/subscription_tracker/presentation/bloc/subscription_bloc.dart';
import 'package:dailypouch/features/subscription_tracker/presentation/bloc/subscription_event.dart';
import 'package:dailypouch/features/subscription_tracker/presentation/bloc/subscription_state.dart';

class MockGetSubscriptionsUseCase extends Mock implements GetSubscriptionsUseCase {}
class MockSaveSubscriptionUseCase extends Mock implements SaveSubscriptionUseCase {}
class MockDeleteSubscriptionUseCase extends Mock implements DeleteSubscriptionUseCase {}
class MockSubscriptionRepository extends Mock implements SubscriptionRepository {}
class FakeSubscriptionEntity extends Fake implements SubscriptionEntity {}

void main() {
  setUpAll(() {
    registerFallbackValue(FakeSubscriptionEntity());
  });

  late SubscriptionBloc bloc;
  late MockGetSubscriptionsUseCase mockGetSubscriptions;
  late MockSaveSubscriptionUseCase mockSaveSubscription;
  late MockDeleteSubscriptionUseCase mockDeleteSubscription;
  late MockSubscriptionRepository mockRepository;

  final testSubscription = SubscriptionEntity(
    id: 'sub_1',
    name: 'Netflix',
    amount: 15.00,
    billingCycle: BillingCycle.monthly,
    nextBillingDate: DateTime(2026, 10, 1),
    category: SubscriptionCategory.entertainment,
    isActive: true,
  );

  setUp(() {
    mockGetSubscriptions = MockGetSubscriptionsUseCase();
    mockSaveSubscription = MockSaveSubscriptionUseCase();
    mockDeleteSubscription = MockDeleteSubscriptionUseCase();
    mockRepository = MockSubscriptionRepository();

    bloc = SubscriptionBloc(
      getSubscriptions: mockGetSubscriptions,
      saveSubscription: mockSaveSubscription,
      deleteSubscription: mockDeleteSubscription,
      repository: mockRepository,
    );
  });

  tearDown(() {
    bloc.close();
  });

  test('initial state is SubscriptionInitial', () {
    expect(bloc.state, equals(const SubscriptionInitial()));
  });

  blocTest<SubscriptionBloc, SubscriptionState>(
    'emits [SubscriptionLoading, SubscriptionLoaded] when LoadSubscriptionsEvent is added and succeeds',
    build: () {
      when(() => mockGetSubscriptions(const NoParams()))
          .thenAnswer((_) async => Right([testSubscription]));
      return bloc;
    },
    act: (bloc) => bloc.add(const LoadSubscriptionsEvent()),
    expect: () => [
      const SubscriptionLoading(),
      SubscriptionLoaded.fromList([testSubscription]),
    ],
  );

  blocTest<SubscriptionBloc, SubscriptionState>(
    'emits [SubscriptionLoading, SubscriptionError] when LoadSubscriptionsEvent fails',
    build: () {
      when(() => mockGetSubscriptions(const NoParams()))
          .thenAnswer((_) async => const Left(DatabaseFailure('Read error')));
      return bloc;
    },
    act: (bloc) => bloc.add(const LoadSubscriptionsEvent()),
    expect: () => [
      const SubscriptionLoading(),
      const SubscriptionError('Read error'),
    ],
  );

  blocTest<SubscriptionBloc, SubscriptionState>(
    'emits [SubscriptionLoaded] with updated paid status when ToggleSubscriptionPaidEvent is added',
    seed: () => SubscriptionLoaded.fromList([testSubscription]),
    build: () {
      when(() => mockSaveSubscription(any()))
          .thenAnswer((_) async => const Right(unit));
      when(() => mockGetSubscriptions(const NoParams()))
          .thenAnswer((_) async => Right([testSubscription.copyWith(isPaid: true)]));
      return bloc;
    },
    act: (bloc) => bloc.add(const ToggleSubscriptionPaidEvent('sub_1')),
    expect: () => [
      SubscriptionLoaded.fromList([testSubscription.copyWith(isPaid: true)]),
    ],
  );
}
