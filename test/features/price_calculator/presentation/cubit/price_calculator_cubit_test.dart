import 'package:bloc_test/bloc_test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:dailypouch/features/price_calculator/domain/usecases/get_saved_benchmarks_usecase.dart';
import 'package:dailypouch/features/price_calculator/domain/usecases/save_benchmark_usecase.dart';
import 'package:dailypouch/features/price_calculator/presentation/cubit/price_calculator_cubit.dart';
import 'package:dailypouch/features/price_calculator/presentation/cubit/price_calculator_state.dart';

class MockGetSavedBenchmarksUseCase extends Mock implements GetSavedBenchmarksUseCase {}
class MockSaveBenchmarkUseCase extends Mock implements SaveBenchmarkUseCase {}

void main() {
  late PriceCalculatorCubit cubit;
  late MockGetSavedBenchmarksUseCase mockGetBenchmarks;
  late MockSaveBenchmarkUseCase mockSaveBenchmark;

  setUp(() {
    mockGetBenchmarks = MockGetSavedBenchmarksUseCase();
    mockSaveBenchmark = MockSaveBenchmarkUseCase();

    cubit = PriceCalculatorCubit(
      getSavedBenchmarks: mockGetBenchmarks,
      saveBenchmark: mockSaveBenchmark,
    );
  });

  tearDown(() {
    cubit.close();
  });

  test('initial state contains 2 options with initial zero prices', () {
    expect(cubit.state.items.length, equals(2));
    expect(cubit.state.items.first.price, equals(0.0));
    expect(cubit.state.items.first.quantity, equals(0.0));
  });

  blocTest<PriceCalculatorCubit, PriceCalculatorState>(
    'adds third comparison option when addItem is called',
    build: () => cubit,
    act: (c) => c.addItem(),
    expect: () => [
      isA<PriceCalculatorState>().having((s) => s.items.length, 'items.length', 3),
    ],
  );

  blocTest<PriceCalculatorCubit, PriceCalculatorState>(
    'allows adding more than 4 comparison options without limit',
    build: () => cubit,
    act: (c) {
      c.addItem(); // 3
      c.addItem(); // 4
      c.addItem(); // 5
      c.addItem(); // 6
    },
    expect: () => [
      isA<PriceCalculatorState>().having((s) => s.items.length, 'items.length', 3),
      isA<PriceCalculatorState>().having((s) => s.items.length, 'items.length', 4),
      isA<PriceCalculatorState>().having((s) => s.items.length, 'items.length', 5),
      isA<PriceCalculatorState>().having((s) => s.items.length, 'items.length', 6),
    ],
  );
}
