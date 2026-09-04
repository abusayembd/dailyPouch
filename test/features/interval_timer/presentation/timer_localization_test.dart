import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:dailypouch/core/localization/app_language.dart';
import 'package:dailypouch/core/localization/app_localizations.dart';
import 'package:dailypouch/core/theme/app_theme.dart';
import 'package:dailypouch/features/interval_timer/domain/entities/interval_preset_entity.dart';
import 'package:dailypouch/features/interval_timer/presentation/bloc/interval_timer_state.dart';
import 'package:dailypouch/features/interval_timer/presentation/widgets/preset_selector_carousel.dart';
import 'package:dailypouch/features/interval_timer/presentation/widgets/timer_countdown_gauge.dart';

void main() {
  group('Interval Timer Localization Details', () {
    test('Preset names and duration format translate correctly', () {
      final l10nBn = AppLocalizations(const Locale('bn'));
      final l10nEs = AppLocalizations(const Locale('es'));

      expect(l10nBn.getLocalizedPresetName('Tabata Protocol'), equals('তাবাতা প্রোটোকল'));
      expect(l10nBn.formatDuration(240), equals('৪m ০০s'));
      expect(l10nBn.setOfTotal(1, 8), equals('সেট ১ / ৮'));

      expect(l10nEs.getLocalizedPresetName('Boxing Sparring'), equals('Sparring de Boxeo'));
    });

    testWidgets('PresetSelectorCarousel displays localized presets in Bengali', (tester) async {
      final presets = IntervalPresetEntity.defaultPresets;

      await tester.pumpWidget(
        MaterialApp(
          theme: AppTheme.darkTheme,
          locale: const Locale('bn'),
          supportedLocales: kSupportedLanguages.map((l) => l.locale).toList(),
          localizationsDelegates: const [
            AppLocalizations.delegate,
            GlobalMaterialLocalizations.delegate,
            GlobalWidgetsLocalizations.delegate,
            GlobalCupertinoLocalizations.delegate,
          ],
          home: Scaffold(
            body: PresetSelectorCarousel(
              presets: presets,
              selectedPreset: presets.first,
              onPresetSelected: (_) {},
              onCustomPreset: () {},
            ),
          ),
        ),
      );
      await tester.pump();

      expect(find.text('ওয়ার্কআউট রুটিন প্রিসেট'), findsOneWidget);
      expect(find.text('তাবাতা প্রোটোকল'), findsOneWidget);
      expect(find.textContaining('অনুশীলন'), findsWidgets);
    });

    testWidgets('TimerCountdownGauge displays Bengali numerals and phase titles', (tester) async {
      final state = IntervalTimerState(
        presets: IntervalPresetEntity.defaultPresets,
        selectedPreset: IntervalPresetEntity.defaultPresets[0],
        currentPhase: TimerPhase.work,
        currentSecondsRemaining: 20,
        currentSet: 1,
        totalElapsedSeconds: 5,
        isRunning: true,
        isPaused: false,
      );

      await tester.pumpWidget(
        MaterialApp(
          theme: AppTheme.darkTheme,
          locale: const Locale('bn'),
          supportedLocales: kSupportedLanguages.map((l) => l.locale).toList(),
          localizationsDelegates: const [
            AppLocalizations.delegate,
            GlobalMaterialLocalizations.delegate,
            GlobalWidgetsLocalizations.delegate,
            GlobalCupertinoLocalizations.delegate,
          ],
          home: Scaffold(
            body: TimerCountdownGauge(state: state),
          ),
        ),
      );
      await tester.pump();

      expect(find.text('অনুশীলন'), findsOneWidget);
      expect(find.text('২০'), findsOneWidget);
      expect(find.text('সেট ১ / ৮'), findsOneWidget);
    });
  });
}
