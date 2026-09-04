import 'package:flutter_test/flutter_test.dart';
import 'package:dailypouch/features/interval_timer/domain/entities/interval_preset_entity.dart';

void main() {
  group('Interval Preset Math Calculations', () {
    test('Calculates total duration and formatted duration correctly', () {
      const tabata = IntervalPresetEntity(
        id: 'tabata',
        name: 'Tabata',
        prepSeconds: 5,
        workSeconds: 20,
        restSeconds: 10,
        totalSets: 8,
        cooldownSeconds: 30,
      );

      // 5 + (30 * 8) + 30 = 5 + 240 + 30 = 275 sec
      expect(tabata.totalDurationSeconds, equals(275));
      expect(tabata.formattedTotalDuration, equals('4m 35s'));
    });

    test('Zero rest and zero cooldown calculates correctly', () {
      const routine = IntervalPresetEntity(
        id: 'plank',
        name: 'Plank Hold',
        prepSeconds: 0,
        workSeconds: 60,
        restSeconds: 0,
        totalSets: 3,
        cooldownSeconds: 0,
      );

      expect(routine.totalDurationSeconds, equals(180));
      expect(routine.formattedTotalDuration, equals('3m 00s'));
    });
  });
}
