import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:uuid/uuid.dart';
import '../../../../core/usecases/usecase.dart';
import '../../domain/entities/comparison_item_entity.dart';
import '../../domain/entities/price_comparison_result.dart';
import '../../domain/entities/saved_benchmark_entity.dart';
import '../../domain/usecases/get_saved_benchmarks_usecase.dart';
import '../../domain/usecases/save_benchmark_usecase.dart';
import 'price_calculator_state.dart';

class PriceCalculatorCubit extends Cubit<PriceCalculatorState> {
  final GetSavedBenchmarksUseCase getSavedBenchmarks;
  final SaveBenchmarkUseCase saveBenchmark;

  PriceCalculatorCubit({
    required this.getSavedBenchmarks,
    required this.saveBenchmark,
  }) : super(PriceCalculatorState.initial());

  void loadSavedBenchmarks() async {
    final result = await getSavedBenchmarks(const NoParams());
    result.fold(
      (failure) => null,
      (benchmarks) => emit(state.copyWith(savedBenchmarks: benchmarks)),
    );
  }

  void updateItemPrice(String id, double price) {
    final updated = state.items.map((i) {
      return i.id == id ? i.copyWith(price: price) : i;
    }).toList();
    _emitUpdated(updated);
  }

  void updateItemQuantity(String id, double quantity) {
    final updated = state.items.map((i) {
      return i.id == id ? i.copyWith(quantity: quantity) : i;
    }).toList();
    _emitUpdated(updated);
  }

  void updateItemUnit(String id, MeasurementUnit unit) {
    final updated = state.items.map((i) {
      return i.id == id ? i.copyWith(unit: unit) : i;
    }).toList();
    _emitUpdated(updated);
  }

  void updateItemLabel(String id, String label) {
    final updated = state.items.map((i) {
      return i.id == id ? i.copyWith(label: label) : i;
    }).toList();
    _emitUpdated(updated);
  }

  void addItem() {
    final newIndex = state.items.length + 1;
    final defaultUnit = state.items.isNotEmpty ? state.items.first.unit : MeasurementUnit.g;
    final letter = newIndex <= 26
        ? String.fromCharCode(64 + newIndex)
        : '$newIndex';

    final newItem = ComparisonItemEntity(
      id: const Uuid().v4(),
      label: 'Option $letter',
      price: 0.0,
      quantity: 0.0,
      unit: defaultUnit,
    );

    final updated = [...state.items, newItem];
    _emitUpdated(updated);
  }

  void removeItem(String id) {
    if (state.items.length <= 2) return; // Maintain minimum 2 options

    final updated = state.items.where((i) => i.id != id).toList();
    _emitUpdated(updated);
  }

  void saveCurrentBenchmark(String title) async {
    final benchmark = SavedBenchmarkEntity(
      id: const Uuid().v4(),
      title: title,
      createdAt: DateTime.now(),
      items: state.items,
    );

    final result = await saveBenchmark(benchmark);
    result.fold(
      (failure) => emit(state.copyWith(message: failure.message)),
      (_) {
        loadSavedBenchmarks();
        emit(state.copyWith(message: 'Benchmark saved: $title'));
      },
    );
  }

  void loadBenchmark(SavedBenchmarkEntity benchmark) {
    _emitUpdated(benchmark.items, message: 'Loaded "${benchmark.title}"');
  }

  void resetDefaults() {
    final defaultState = PriceCalculatorState.initial();
    emit(defaultState.copyWith(savedBenchmarks: state.savedBenchmarks));
  }

  void _emitUpdated(List<ComparisonItemEntity> items, {String? message}) {
    final result = PriceComparisonResult.calculate(items);
    emit(state.copyWith(
      items: items,
      result: result,
      message: message,
    ));
  }
}
