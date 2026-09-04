import 'package:get_it/get_it.dart';
import '../../features/expense_tracker/data/datasources/expense_local_datasource.dart';
import '../../features/expense_tracker/data/repositories/expense_repository_impl.dart';
import '../../features/expense_tracker/domain/repositories/expense_repository.dart';
import '../../features/expense_tracker/domain/usecases/expense_usecases.dart';
import '../../features/expense_tracker/presentation/bloc/expense_bloc.dart';
import '../../features/interval_timer/data/datasources/timer_local_datasource.dart';
import '../../features/interval_timer/data/repositories/timer_repository_impl.dart';
import '../../features/interval_timer/domain/repositories/timer_repository.dart';
import '../../features/interval_timer/domain/usecases/timer_usecases.dart';
import '../../features/interval_timer/presentation/bloc/interval_timer_bloc.dart';
import '../../features/launcher/presentation/cubit/launcher_cubit.dart';
import '../../features/micro_budgeter/data/datasources/budget_local_datasource.dart';
import '../../features/micro_budgeter/data/repositories/budget_repository_impl.dart';
import '../../features/micro_budgeter/domain/repositories/budget_repository.dart';
import '../../features/micro_budgeter/domain/usecases/add_transaction_usecase.dart';
import '../../features/micro_budgeter/domain/usecases/delete_envelope_usecase.dart';
import '../../features/micro_budgeter/domain/usecases/get_envelopes_usecase.dart';
import '../../features/micro_budgeter/domain/usecases/get_transactions_usecase.dart';
import '../../features/micro_budgeter/domain/usecases/save_envelope_usecase.dart';
import '../../features/micro_budgeter/presentation/bloc/budget_bloc.dart';
import '../../features/pantry_expiry/data/datasources/pantry_local_datasource.dart';
import '../../features/pantry_expiry/data/repositories/pantry_repository_impl.dart';
import '../../features/pantry_expiry/domain/repositories/pantry_repository.dart';
import '../../features/pantry_expiry/domain/usecases/delete_pantry_item_usecase.dart';
import '../../features/pantry_expiry/domain/usecases/get_pantry_items_usecase.dart';
import '../../features/pantry_expiry/domain/usecases/save_pantry_item_usecase.dart';
import '../../features/pantry_expiry/domain/usecases/toggle_consumed_usecase.dart';
import '../../features/pantry_expiry/presentation/bloc/pantry_bloc.dart';
import '../../features/price_calculator/data/datasources/price_calculator_local_datasource.dart';
import '../../features/price_calculator/data/repositories/price_calculator_repository_impl.dart';
import '../../features/price_calculator/domain/repositories/price_calculator_repository.dart';
import '../../features/price_calculator/domain/usecases/get_saved_benchmarks_usecase.dart';
import '../../features/price_calculator/domain/usecases/save_benchmark_usecase.dart';
import '../../features/price_calculator/presentation/cubit/price_calculator_cubit.dart';
import '../../features/subscription_tracker/data/datasources/subscription_local_datasource.dart';
import '../../features/subscription_tracker/data/repositories/subscription_repository_impl.dart';
import '../../features/subscription_tracker/domain/repositories/subscription_repository.dart';
import '../../features/subscription_tracker/domain/usecases/delete_subscription_usecase.dart';
import '../../features/subscription_tracker/domain/usecases/get_subscriptions_usecase.dart';
import '../../features/subscription_tracker/domain/usecases/save_subscription_usecase.dart';
import '../../features/subscription_tracker/presentation/bloc/subscription_bloc.dart';
import '../currency/currency_cubit.dart';
import '../database/local_storage_service.dart';
import '../localization/locale_cubit.dart';
import '../notifications/notification_service.dart';

final sl = GetIt.instance;

/// Initializes service locator and dependency injection graph.
Future<void> initInjection() async {
  // -------------------------------------------------------------
  // 1. Core Services (Database, Notifications, Storage, Currency, Locale)
  // -------------------------------------------------------------
  sl.registerLazySingleton<LocalStorageService>(() => LocalStorageService());
  sl.registerLazySingleton<NotificationService>(() => NotificationService());
  sl.registerLazySingleton<CurrencyCubit>(() => CurrencyCubit());
  sl.registerLazySingleton<LocaleCubit>(() => LocaleCubit());

  // -------------------------------------------------------------
  // 2. Features - Launcher
  // -------------------------------------------------------------
  sl.registerFactory<LauncherCubit>(() => LauncherCubit());

  // -------------------------------------------------------------
  // 3. Features - Phase 1: Subscription Tracker
  // -------------------------------------------------------------
  sl.registerLazySingleton<SubscriptionLocalDataSource>(
    () => SubscriptionLocalDataSourceImpl(),
  );
  sl.registerLazySingleton<SubscriptionRepository>(
    () => SubscriptionRepositoryImpl(localDataSource: sl()),
  );
  sl.registerLazySingleton<GetSubscriptionsUseCase>(
    () => GetSubscriptionsUseCase(sl()),
  );
  sl.registerLazySingleton<SaveSubscriptionUseCase>(
    () => SaveSubscriptionUseCase(sl()),
  );
  sl.registerLazySingleton<DeleteSubscriptionUseCase>(
    () => DeleteSubscriptionUseCase(sl()),
  );
  sl.registerFactory<SubscriptionBloc>(
    () => SubscriptionBloc(
      getSubscriptions: sl(),
      saveSubscription: sl(),
      deleteSubscription: sl(),
      repository: sl(),
    ),
  );

  // -------------------------------------------------------------
  // 4. Features - Phase 2: Price Calculator
  // -------------------------------------------------------------
  sl.registerLazySingleton<PriceCalculatorLocalDataSource>(
    () => PriceCalculatorLocalDataSourceImpl(),
  );
  sl.registerLazySingleton<PriceCalculatorRepository>(
    () => PriceCalculatorRepositoryImpl(localDataSource: sl()),
  );
  sl.registerLazySingleton<GetSavedBenchmarksUseCase>(
    () => GetSavedBenchmarksUseCase(sl()),
  );
  sl.registerLazySingleton<SaveBenchmarkUseCase>(
    () => SaveBenchmarkUseCase(sl()),
  );
  sl.registerFactory<PriceCalculatorCubit>(
    () => PriceCalculatorCubit(getSavedBenchmarks: sl(), saveBenchmark: sl()),
  );

  // -------------------------------------------------------------
  // 5. Features - Phase 3: Pantry Expiry
  // -------------------------------------------------------------
  sl.registerLazySingleton<PantryLocalDataSource>(
    () => PantryLocalDataSourceImpl(),
  );
  sl.registerLazySingleton<PantryRepository>(
    () => PantryRepositoryImpl(localDataSource: sl()),
  );
  sl.registerLazySingleton<GetPantryItemsUseCase>(
    () => GetPantryItemsUseCase(sl()),
  );
  sl.registerLazySingleton<SavePantryItemUseCase>(
    () => SavePantryItemUseCase(sl()),
  );
  sl.registerLazySingleton<DeletePantryItemUseCase>(
    () => DeletePantryItemUseCase(sl()),
  );
  sl.registerLazySingleton<ToggleConsumedUseCase>(
    () => ToggleConsumedUseCase(sl()),
  );
  sl.registerFactory<PantryBloc>(
    () => PantryBloc(
      getPantryItems: sl(),
      savePantryItem: sl(),
      deletePantryItem: sl(),
      toggleConsumed: sl(),
    ),
  );

  // -------------------------------------------------------------
  // 6. Features - Phase 4: Expense Tracker & Money Manager
  // -------------------------------------------------------------
  sl.registerLazySingleton<ExpenseLocalDataSource>(
    () => ExpenseLocalDataSourceImpl(),
  );
  sl.registerLazySingleton<ExpenseRepository>(
    () => ExpenseRepositoryImpl(localDataSource: sl()),
  );
  sl.registerLazySingleton<GetExpenseTransactionsUseCase>(
    () => GetExpenseTransactionsUseCase(sl()),
  );
  sl.registerLazySingleton<SaveExpenseTransactionUseCase>(
    () => SaveExpenseTransactionUseCase(sl()),
  );
  sl.registerLazySingleton<DeleteExpenseTransactionUseCase>(
    () => DeleteExpenseTransactionUseCase(sl()),
  );
  sl.registerLazySingleton<GetExpenseSummaryUseCase>(
    () => GetExpenseSummaryUseCase(sl()),
  );
  sl.registerFactory<ExpenseBloc>(
    () => ExpenseBloc(
      getTransactions: sl(),
      saveTransaction: sl(),
      deleteTransaction: sl(),
    ),
  );

  // -------------------------------------------------------------
  // 7. Features - Phase 5: Micro Budgeter
  // -------------------------------------------------------------
  sl.registerLazySingleton<BudgetLocalDataSource>(
    () => BudgetLocalDataSourceImpl(),
  );
  sl.registerLazySingleton<BudgetRepository>(
    () => BudgetRepositoryImpl(localDataSource: sl()),
  );
  sl.registerLazySingleton<GetEnvelopesUseCase>(
    () => GetEnvelopesUseCase(sl()),
  );
  sl.registerLazySingleton<SaveEnvelopeUseCase>(
    () => SaveEnvelopeUseCase(sl()),
  );
  sl.registerLazySingleton<DeleteEnvelopeUseCase>(
    () => DeleteEnvelopeUseCase(sl()),
  );
  sl.registerLazySingleton<AddTransactionUseCase>(
    () => AddTransactionUseCase(sl()),
  );
  sl.registerLazySingleton<GetTransactionsUseCase>(
    () => GetTransactionsUseCase(sl()),
  );
  sl.registerFactory<BudgetBloc>(
    () => BudgetBloc(
      getEnvelopes: sl(),
      saveEnvelope: sl(),
      deleteEnvelope: sl(),
      addTransaction: sl(),
      getTransactions: sl(),
      repository: sl(),
    ),
  );

  // -------------------------------------------------------------
  // 8. Features - Phase 6: Interval Timer
  // -------------------------------------------------------------
  sl.registerLazySingleton<TimerLocalDataSource>(
    () => TimerLocalDataSourceImpl(),
  );
  sl.registerLazySingleton<TimerRepository>(
    () => TimerRepositoryImpl(localDataSource: sl()),
  );
  sl.registerLazySingleton<GetTimerPresetsUseCase>(
    () => GetTimerPresetsUseCase(sl()),
  );
  sl.registerLazySingleton<SaveTimerPresetUseCase>(
    () => SaveTimerPresetUseCase(sl()),
  );
  sl.registerFactory<IntervalTimerBloc>(
    () => IntervalTimerBloc(getPresets: sl(), savePreset: sl()),
  );
}
