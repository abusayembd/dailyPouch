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

  testWidgets('Renders DailyPouch launcher, navigates to module, settings, and about app page', (WidgetTester tester) async {
    await tester.pumpWidget(const DailyPouchApp());
    await tester.pumpAndSettle();

    // Verify Title & AppBar on Home tab
    expect(find.text('DailyPouch'), findsWidgets);
    expect(find.text('Offline Life Tools'), findsWidgets);

    // Verify Bottom Navigation Bar contains Home (house icon) and Settings icons
    expect(find.byIcon(Icons.home_rounded), findsOneWidget);
    expect(find.byIcon(Icons.settings_outlined), findsOneWidget);

    // Verify 6 ArcadeModuleCard widgets
    expect(find.byType(ArcadeModuleCard), findsNWidgets(6));

    // Tap the Subscription Tracker card
    await tester.tap(find.text('Subscription Tracker'));
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

    expect(find.text('Subscription Tracker'), findsOneWidget);

    // Switch to Settings tab in bottom navigation bar via settings icon
    await tester.tap(find.byIcon(Icons.settings_outlined));
    await tester.pumpAndSettle();

    // Verify Settings page content
    expect(find.text('CENTRAL CURRENCY'), findsOneWidget);
    expect(find.text('ABOUT THE APP'), findsOneWidget);

    // Scroll if needed and tap the 'ABOUT THE APP' navigation tile to open AboutAppPage
    await tester.ensureVisible(find.text('ABOUT THE APP'));
    await tester.pumpAndSettle();
    await tester.tap(find.text('ABOUT THE APP'));
    await tester.pumpAndSettle();

    // Verify About App page content
    expect(find.text('6 OFFLINE LIFE TOOLS'), findsOneWidget);
    expect(find.text('Interval & Rest Timer'), findsOneWidget);

    // Navigate back from AboutAppPage to Settings
    await tester.tap(find.byIcon(Icons.arrow_back_ios_new_rounded));
    await tester.pumpAndSettle();

    expect(find.text('CENTRAL CURRENCY'), findsOneWidget);

    // Switch back to Home tab via home icon
    await tester.tap(find.byIcon(Icons.home_outlined));
    await tester.pumpAndSettle();

    // Verify we are back on the Home dashboard
    expect(find.byType(ArcadeModuleCard), findsNWidgets(6));
  });
}
