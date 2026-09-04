import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:dailypouch/core/localization/app_language.dart';
import 'package:dailypouch/core/localization/app_localizations.dart';
import 'package:dailypouch/core/theme/app_theme.dart';
import 'package:dailypouch/features/micro_budgeter/domain/entities/budget_envelope_entity.dart';
import 'package:dailypouch/features/micro_budgeter/presentation/widgets/runway_gauge_card.dart';

void main() {
  group('Micro Budgeter Localization Details', () {
    test('Envelope names and category tags translate correctly', () {
      final l10nBn = AppLocalizations(const Locale('bn'));
      final l10nEs = AppLocalizations(const Locale('es'));

      expect(l10nBn.getLocalizedEnvelopeName('Weekend Trip'), equals('উইকেন্ড ট্রিপ / ছুটি'));
      expect(l10nBn.getLocalizedCategoryTag('Food & Drinks'), equals('খাবার ও পানীয়'));
      expect(l10nBn.entriesCount(5), equals('৫ টি এন্ট্রি'));

      expect(l10nEs.getLocalizedEnvelopeName('Dining Out'), equals('Restaurantes y Cenas'));
      expect(l10nEs.getLocalizedCategoryTag('Transport'), equals('Transporte'));
    });

    testWidgets('RunwayGaugeCard displays localized daily allowance and numbers in Bengali', (tester) async {
      final envelope = BudgetEnvelopeEntity(
        id: 'env_1',
        name: 'Weekend Trip',
        targetAmount: 500.0,
        spentAmount: 150.0,
        startDate: DateTime.now(),
        endDate: DateTime.now().add(const Duration(days: 7)),
        currency: '৳',
        category: 'Travel',
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
            body: RunwayGaugeCard(
              envelope: envelope,
              currencySymbol: '৳',
            ),
          ),
        ),
      );
      await tester.pump();

      expect(find.text('দৈনিক খরচের রানওয়ে'), findsOneWidget);
      expect(find.textContaining('৳১৫০.০০'), findsOneWidget);
      expect(find.textContaining('৳৫০০.০০'), findsOneWidget);
    });
  });
}
