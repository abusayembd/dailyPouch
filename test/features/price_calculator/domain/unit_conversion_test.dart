import 'package:flutter_test/flutter_test.dart';
import 'package:dailypouch/features/price_calculator/domain/entities/comparison_item_entity.dart';
import 'package:dailypouch/features/price_calculator/domain/entities/price_comparison_result.dart';

void main() {
  group('Price Calculator Domain Logic', () {
    test('500g at \$3.50 vs 1kg at \$6.00 correctly identifies 1kg as the best deal', () {
      const itemA = ComparisonItemEntity(
        id: '1',
        label: '500g Pack',
        price: 3.50,
        quantity: 500,
        unit: MeasurementUnit.g,
      );

      const itemB = ComparisonItemEntity(
        id: '2',
        label: '1kg Bulk Pack',
        price: 6.00,
        quantity: 1,
        unit: MeasurementUnit.kg,
      );

      // Item A: $3.50 / 500g = $0.007/g => $0.70/100g
      expect(itemA.totalBaseUnits, equals(500.0));
      expect(itemA.pricePerStandardUnit, closeTo(0.70, 0.001));

      // Item B: $6.00 / 1000g = $0.006/g => $0.60/100g
      expect(itemB.totalBaseUnits, equals(1000.0));
      expect(itemB.pricePerStandardUnit, closeTo(0.60, 0.001));

      final result = PriceComparisonResult.calculate([itemA, itemB]);

      expect(result.bestDeal, equals(itemB));
      expect(result.worstDeal, equals(itemA));
      // Savings: ((0.007 - 0.006) / 0.007) * 100 = 14.28%
      expect(result.maxSavingsPercentage, closeTo(14.28, 0.1));
    });

    test('Volume comparison: 750ml at \$4.50 vs 2L at \$10.00', () {
      const itemA = ComparisonItemEntity(
        id: '1',
        label: 'Bottle',
        price: 4.50,
        quantity: 750,
        unit: MeasurementUnit.ml,
      );

      const itemB = ComparisonItemEntity(
        id: '2',
        label: 'Jug',
        price: 10.00,
        quantity: 2,
        unit: MeasurementUnit.l,
      );

      // Item A: $4.50 / 750ml = $0.006/ml => $0.60/100ml
      // Item B: $10.00 / 2000ml = $0.005/ml => $0.50/100ml
      final result = PriceComparisonResult.calculate([itemA, itemB]);

      expect(result.bestDeal, equals(itemB));
      expect(result.maxSavingsPercentage, closeTo(16.66, 0.1));
    });

    test('Flags mismatched categories when comparing Weight to Volume', () {
      const itemWeight = ComparisonItemEntity(
        id: '1',
        label: 'Flour',
        price: 3.00,
        quantity: 1,
        unit: MeasurementUnit.kg,
      );

      const itemVolume = ComparisonItemEntity(
        id: '2',
        label: 'Milk',
        price: 3.00,
        quantity: 1,
        unit: MeasurementUnit.l,
      );

      final result = PriceComparisonResult.calculate([itemWeight, itemVolume]);

      expect(result.hasMismatchedCategories, isTrue);
    });
  });
}
