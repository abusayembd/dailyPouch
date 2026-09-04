import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:dailypouch/core/localization/app_language.dart';
import 'package:dailypouch/core/localization/app_localizations.dart';
import 'package:dailypouch/core/theme/app_theme.dart';
import 'package:dailypouch/features/subscription_tracker/domain/entities/subscription_entity.dart';
import 'package:dailypouch/features/subscription_tracker/presentation/widgets/burn_rate_card.dart';
import 'package:dailypouch/features/subscription_tracker/presentation/widgets/subscription_tile.dart';

void main() {
  group('Subscription Tracker Localization Details', () {
    test('Number, Date and Currency formatting for Bengali and English', () {
      final l10nBn = AppLocalizations(const Locale('bn'));
      final l10nEn = AppLocalizations(const Locale('en'));

      // 1. Money Value formatting
      expect(l10nBn.formatCurrency(19.99, '\$'), '\$১৯.৯৯');
      expect(l10nEn.formatCurrency(19.99, '\$'), '\$19.99');

      // 2. Projected Annual Burn formatting
      expect(l10nBn.formatYearlyBurn(239.88, '\$'), '\$২৩৯.৮৮/বছর');
      expect(l10nEn.formatYearlyBurn(239.88, '\$'), '\$239.88/yr');

      // 3. Date formatting
      final sampleDate = DateTime(2026, 10, 10);
      expect(l10nBn.formatDate(sampleDate), '১০ অক্টো, ২০২৬');
      expect(l10nEn.formatDate(sampleDate), 'Oct 10, 2026');

      // 4. "2 of 2 active" count localization
      expect(l10nBn.activeCount(2, 2), '২টির মধ্যে ২টি সক্রিয়');
      expect(l10nEn.activeCount(2, 2), '2 of 2 Active');

      // 5. Subscription Name translation
      expect(l10nBn.getLocalizedSubscriptionName('Netflix'), 'নেটফ্লিক্স');
      expect(l10nBn.getLocalizedSubscriptionName('Gym Membership'), 'জিম মেম্বারশিপ');
    });

    testWidgets('BurnRateCard displays localized activeCount and money values', (tester) async {
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
          home: const Scaffold(
            body: SingleChildScrollView(
              child: BurnRateCard(
                monthlyBurn: 19.99,
                yearlyBurn: 239.88,
                activeCount: 2,
                totalCount: 2,
                currencySymbol: '\$',
              ),
            ),
          ),
        ),
      );
      await tester.pumpAndSettle();

      expect(find.text('২টির মধ্যে ২টি সক্রিয়'), findsOneWidget);
      expect(find.text('\$১৯.৯৯'), findsOneWidget);
      expect(find.text('\$২৩৯.৮৮/বছর'), findsOneWidget);
    });

    testWidgets('SubscriptionTile displays localized date, name, and currency in Bengali', (tester) async {
      final sub = SubscriptionEntity(
        id: '1',
        name: 'Gym Membership',
        amount: 35.00,
        billingCycle: BillingCycle.monthly,
        nextBillingDate: DateTime(2026, 10, 10),
        category: SubscriptionCategory.health,
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
            body: SingleChildScrollView(
              child: SubscriptionTile(
                subscription: sub,
                currencySymbol: '\$',
                onToggle: () {},
                onTogglePaid: () {},
                onEdit: () {},
                onDelete: () {},
              ),
            ),
          ),
        ),
      );
      await tester.pumpAndSettle();

      expect(find.text('জিম মেম্বারশিপ'), findsOneWidget);
      expect(find.text('\$৩৫.০০'), findsOneWidget);
      expect(find.textContaining('১০ অক্টো, ২০২৬'), findsOneWidget);
    });
  });
}
