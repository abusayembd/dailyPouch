import 'package:bloc_test/bloc_test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:dailypouch/features/launcher/domain/entities/utility_module.dart';
import 'package:dailypouch/features/launcher/presentation/cubit/launcher_cubit.dart';
import 'package:dailypouch/features/launcher/presentation/cubit/launcher_state.dart';

void main() {
  group('LauncherCubit', () {
    late LauncherCubit cubit;

    setUp(() {
      cubit = LauncherCubit();
    });

    tearDown(() {
      cubit.close();
    });

    test('initial state contains all 6 default utility modules', () {
      expect(cubit.state.allModules.length, equals(6));
      expect(cubit.state.filteredModules.length, equals(6));
      expect(cubit.state.searchQuery, isEmpty);
      expect(cubit.state.selectedCategory, equals(ModuleCategory.all));
    });

    blocTest<LauncherCubit, LauncherState>(
      'emits filtered list when searching by module name',
      build: () => cubit,
      act: (cubit) => cubit.updateSearchQuery('subscription'),
      expect: () => [
        isA<LauncherState>()
            .having((s) => s.searchQuery, 'searchQuery', 'subscription')
            .having((s) => s.filteredModules.length, 'filteredModules.length', 1)
            .having((s) => s.filteredModules.first.id, 'id', 'subscription_tracker'),
      ],
    );

    blocTest<LauncherCubit, LauncherState>(
      'emits filtered list when selecting finance category',
      build: () => cubit,
      act: (cubit) => cubit.selectCategory(ModuleCategory.finance),
      expect: () => [
        isA<LauncherState>()
            .having((s) => s.selectedCategory, 'category', ModuleCategory.finance)
            .having((s) => s.filteredModules.length, 'filteredModules.length', 4), // Subscriptions, Price Calc, Expense Tracker, Micro Budget
      ],
    );

    blocTest<LauncherCubit, LauncherState>(
      'emits filtered list when selecting kitchen category',
      build: () => cubit,
      act: (cubit) => cubit.selectCategory(ModuleCategory.kitchen),
      expect: () => [
        isA<LauncherState>()
            .having((s) => s.selectedCategory, 'category', ModuleCategory.kitchen)
            .having((s) => s.filteredModules.length, 'filteredModules.length', 1)
            .having((s) => s.filteredModules.first.id, 'id', 'pantry_expiry'),
      ],
    );

    blocTest<LauncherCubit, LauncherState>(
      'resets filters back to all 6 modules when resetFilters is called',
      build: () => cubit,
      seed: () => const LauncherState(
        allModules: UtilityModule.defaultModules,
        filteredModules: [],
        searchQuery: 'nonexistent',
        selectedCategory: ModuleCategory.fitness,
      ),
      act: (cubit) => cubit.resetFilters(),
      expect: () => [
        isA<LauncherState>()
            .having((s) => s.searchQuery, 'searchQuery', '')
            .having((s) => s.selectedCategory, 'category', ModuleCategory.all)
            .having((s) => s.filteredModules.length, 'filteredModules.length', 6),
      ],
    );
  });
}
