import 'package:flutter_test/flutter_test.dart';
import 'package:dailypouch/features/pantry_expiry/domain/entities/pantry_item_entity.dart';

void main() {
  group('Pantry Item Freshness Calculation', () {
    test('Items with > 5 days remaining are Fresh', () {
      final item = PantryItemEntity(
        id: '1',
        name: 'Unopened Rice',
        zone: StorageZone.pantry,
        expiryDate: DateTime.now().add(const Duration(days: 30)),
        addedDate: DateTime.now(),
      );

      expect(item.freshnessStatus, equals(FreshnessStatus.fresh));
      expect(item.daysUntilExpiry, greaterThan(5));
    });

    test('Items with <= 5 days remaining are Warning', () {
      final item = PantryItemEntity(
        id: '2',
        name: 'Fresh Milk',
        zone: StorageZone.fridge,
        expiryDate: DateTime.now().add(const Duration(days: 3)),
        addedDate: DateTime.now(),
      );

      expect(item.freshnessStatus, equals(FreshnessStatus.warning));
    });

    test('Items with negative days remaining are Expired', () {
      final item = PantryItemEntity(
        id: '3',
        name: 'Old Yogurt',
        zone: StorageZone.fridge,
        expiryDate: DateTime.now().subtract(const Duration(days: 2)),
        addedDate: DateTime.now(),
      );

      expect(item.freshnessStatus, equals(FreshnessStatus.expired));
      expect(item.daysUntilExpiry, lessThan(0));
    });
  });
}
