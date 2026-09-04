import 'package:flutter_test/flutter_test.dart';
import 'package:dailypouch/features/micro_budgeter/domain/entities/budget_envelope_entity.dart';

void main() {
  group('Budget Envelope Runway Calculations', () {
    test('Calculates remaining amount, progress, and daily runway correctly', () {
      final now = DateTime.now();
      final envelope = BudgetEnvelopeEntity(
        id: '1',
        name: 'Weekend Trip',
        targetAmount: 500.0,
        spentAmount: 100.0,
        startDate: now,
        endDate: now.add(const Duration(days: 4)), // 5 days total including today
      );

      expect(envelope.remainingAmount, equals(400.0));
      expect(envelope.burnProgressPercentage, equals(0.2));
      expect(envelope.remainingDays, equals(5));
      expect(envelope.dailyRunwayAllowance, equals(80.0)); // $400 / 5 days = $80/day
    });

    test('Handles overbudget gracefully', () {
      final now = DateTime.now();
      final envelope = BudgetEnvelopeEntity(
        id: '2',
        name: 'Dining',
        targetAmount: 100.0,
        spentAmount: 150.0,
        startDate: now,
        endDate: now.add(const Duration(days: 2)),
      );

      expect(envelope.remainingAmount, equals(-50.0));
      expect(envelope.dailyRunwayAllowance, equals(0.0));
    });
  });
}
