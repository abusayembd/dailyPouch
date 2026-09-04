import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:fpdart/fpdart.dart';
import 'package:mocktail/mocktail.dart';
import 'package:dailypouch/core/di/injection_container.dart' as di;
import 'package:dailypouch/features/launcher/presentation/widgets/arcade_module_card.dart';
import 'package:dailypouch/features/subscription_tracker/domain/entities/subscription_entity.dart';
import 'package:dailypouch/features/subscription_tracker/domain/repositories/subscription_repository.dart';
import 'package:dailypouch/features/subscription_tracker/domain/usecases/get_subscriptions_usecase.dart';
import 'package:dailypouch/features/subscription_tracker/presentation/bloc/subscription_bloc.dart';
import 'package:dailypouch/main.dart';

class MockSubscriptionRepository extends Mock implements SubscriptionRepository {}

void main() {
  late MockSubscriptionRepository mockSubRepo;

  setUp(() async {
    await di.sl.reset();
    await di.initInjection();

    mockSubRepo = MockSubscriptionRepository();
    di.sl.unregister<SubscriptionRepository>();
    di.sl.registerLazySingleton<SubscriptionRepository>(() => mockSubRepo);

    // Re-register UseCase and Bloc with the mock repo
    di.sl.unregister<GetSubscriptionsUseCase>();
    di.sl.registerLazySingleton<GetSubscriptionsUseCase>(() => GetSubscriptionsUseCase(mockSubRepo));

    di.sl.unregister<SubscriptionBloc>();
    di.sl.registerFactory<SubscriptionBloc>(
      () => SubscriptionBloc(
        getSubscriptions: di.sl(),
        saveSubscription: di.sl(),
        deleteSubscription: di.sl(),
        repository: di.sl(),
      ),
    );

    when(() => mockSubRepo.getSubscriptions()).thenAnswer(
      (_) async => Right([
        SubscriptionEntity(
          id: 'sub_test',
          name: 'Netflix Test',
          amount: 19.99,
          billingCycle: BillingCycle.monthly,
          nextBillingDate: DateTime(2026, 12, 1),
          category: SubscriptionCategory.entertainment,
        ),
      ]),
    );
  });

  testWidgets('Renders DailyPouch launcher dashboard and navigates to subscription page', (WidgetTester tester) async {
    await tester.pumpWidget(const DailyPouchApp());
    await tester.pumpAndSettle();

    // Verify Title & AppBar
    expect(find.text('DailyPouch'), findsOneWidget);
    expect(find.text('Offline Life Tools'), findsOneWidget);

    // Verify 6 ArcadeModuleCard widgets
    expect(find.byType(ArcadeModuleCard), findsNWidgets(6));

    // Tap the Subscription Tracker card
    await tester.tap(find.text('Subscription & Bill Tracker'));
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 100));
    await tester.pumpAndSettle();

    // Verify Subscription Page elements
    expect(find.text('MONTHLY CASH BURN'), findsOneWidget);
    expect(find.text('Subscriptions'), findsOneWidget);
    expect(find.text('Netflix Test'), findsOneWidget);

    // Navigate back to launcher
    await tester.tap(find.byIcon(Icons.arrow_back_ios_new_rounded));
    await tester.pumpAndSettle();

    expect(find.text('DailyPouch'), findsOneWidget);

    // Verify Settings button is present on the top right
    expect(find.byIcon(Icons.settings_outlined), findsOneWidget);

    // Tap the Settings button
    await tester.tap(find.byIcon(Icons.settings_outlined));
    await tester.pumpAndSettle();

    // Verify Settings & About modal content
    expect(find.text('Settings & About'), findsOneWidget);
    expect(find.text('CENTRAL CURRENCY'), findsOneWidget);
    expect(find.text('ABOUT THE APP'), findsOneWidget);

    // Tap Done to dismiss
    await tester.tap(find.text('Done'));
    await tester.pumpAndSettle();

    expect(find.text('Settings & About'), findsNothing);
  });
}
