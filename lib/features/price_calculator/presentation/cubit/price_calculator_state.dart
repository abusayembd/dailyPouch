import 'package:equatable/equatable.dart';
import '../../domain/entities/comparison_item_entity.dart';
import '../../domain/entities/price_comparison_result.dart';
import '../../domain/entities/saved_benchmark_entity.dart';

class PriceCalculatorState extends Equatable {
  final List<ComparisonItemEntity> items;
  final PriceComparisonResult result;
  final List<SavedBenchmarkEntity> savedBenchmarks;
  final String? message;

  const PriceCalculatorState({
    required this.items,
    required this.result,
    this.savedBenchmarks = const [],
    this.message,
  });

  factory PriceCalculatorState.initial() {
    final defaultItems = [
      const ComparisonItemEntity(
        id: 'item_1',
        label: 'Option A (Standard)',
        price: 0.0,
        quantity: 0.0,
        unit: MeasurementUnit.g,
      ),
      const ComparisonItemEntity(
        id: 'item_2',
        label: 'Option B (Bulk Pack)',
        price: 0.0,
        quantity: 0.0,
        unit: MeasurementUnit.kg,
      ),
    ];

    return PriceCalculatorState(
      items: defaultItems,
      result: PriceComparisonResult.calculate(defaultItems),
    );
  }

  PriceCalculatorState copyWith({
    List<ComparisonItemEntity>? items,
    PriceComparisonResult? result,
    List<SavedBenchmarkEntity>? savedBenchmarks,
    String? message,
  }) {
    return PriceCalculatorState(
      items: items ?? this.items,
      result: result ?? this.result,
      savedBenchmarks: savedBenchmarks ?? this.savedBenchmarks,
      message: message,
    );
  }

  @override
  List<Object?> get props => [items, result, savedBenchmarks, message];
}
