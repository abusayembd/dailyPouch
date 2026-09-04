import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:dailypouch/core/localization/app_language.dart';
import 'package:dailypouch/core/localization/app_localizations.dart';
import 'package:dailypouch/core/theme/app_theme.dart';
import 'package:dailypouch/features/price_calculator/domain/entities/comparison_item_entity.dart';
import 'package:dailypouch/features/price_calculator/domain/entities/price_comparison_result.dart';
import 'package:dailypouch/features/price_calculator/presentation/widgets/best_deal_banner.dart';
import 'package:dailypouch/features/price_calculator/presentation/widgets/comparison_item_card.dart';

void main() {
  group('Price Calculator Localization Details', () {
    test('Localized Option names, Units and Benchmark strings', () {
      final l10nBn = AppLocalizations(const Locale('bn'));
      final l10nEn = AppLocalizations(const Locale('en'));

      // 1. Preset Option Label Localization
      expect(l10nBn.getLocalizedOptionLabel('Option A (Standard)'), 'বিকল্প ক (স্ট্যান্ডার্ড)');
      expect(l10nBn.getLocalizedOptionLabel('Option B (Bulk Pack)'), 'বিকল্প খ (বাল্ক প্যাক)');
      expect(l10nEn.getLocalizedOptionLabel('Option A (Standard)'), 'Option A (Standard)');

      // 2. Unit labels and names
      expect(l10nBn.getLocalizedUnitName(MeasurementUnit.g), 'গ্রাম (g)');
      expect(l10nBn.getLocalizedUnitName(MeasurementUnit.kg), 'কেজি (kg)');
      expect(l10nBn.getLocalizedUnitName(MeasurementUnit.ml), 'মি.লি. (ml)');
      expect(l10nBn.getLocalizedUnitName(MeasurementUnit.l), 'লিটার (L)');
      expect(l10nBn.getLocalizedUnitName(MeasurementUnit.pcs), 'পিস (pcs)');
      expect(l10nBn.getStandardUnitLabel(UnitCategory.weight), '/ ১০০গ্রাম');
      expect(l10nEn.getStandardUnitLabel(UnitCategory.weight), '/ 100g');
      expect(l10nBn.getBulkUnitLabel(UnitCategory.weight), '/ ১কেজি');
      expect(l10nEn.getBulkUnitLabel(UnitCategory.weight), '/ 1kg');

      // 3. Normalization of native digits
      expect(AppLocalizations.normalizeNumber('৩.৪৯'), '3.49');
      expect(AppLocalizations.normalizeNumber('٥٠.٥'), '50.5');

      // 4. Benchmarks
      expect(l10nBn.saveBenchmarkTitle, 'বেঞ্চমার্ক সংরক্ষণ করুন');
      expect(l10nBn.optionsCompared(3, '১০ অক্টো, ২০২৬'), '৩টি বিকল্প তুলনা করা হয়েছে • ১০ অক্টো, ২০২৬');
    });

    testWidgets('BestDealBanner displays localized option and savings in Bengali', (tester) async {
      const items = [
        ComparisonItemEntity(
          id: '1',
          label: 'Option A (Standard)',
          price: 3.49,
          quantity: 500,
          unit: MeasurementUnit.g,
        ),
        ComparisonItemEntity(
          id: '2',
          label: 'Option B (Bulk Pack)',
          price: 5.99,
          quantity: 1,
          unit: MeasurementUnit.kg,
        ),
      ];
      final result = PriceComparisonResult.calculate(items);

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
              child: BestDealBanner(
                result: result,
                currencySymbol: '\$',
              ),
            ),
          ),
        ),
      );
      await tester.pumpAndSettle();

      expect(find.text('সেরা সাশ্রয়ী ডিল'), findsOneWidget);
      expect(find.text('বিকল্প খ (বাল্ক প্যাক)'), findsOneWidget);
      expect(find.textContaining('১৪.২% সাশ্রয়ী'), findsOneWidget);
    });

    testWidgets('ComparisonItemCard displays localized unit cost and tags in Bengali', (tester) async {
      const item = ComparisonItemEntity(
        id: '1',
        label: 'Option A (Standard)',
        price: 3.49,
        quantity: 500,
        unit: MeasurementUnit.g,
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
              child: ComparisonItemCard(
                item: item,
                isBestDeal: true,
                percentMoreExpensive: 0,
                canDelete: false,
                currencySymbol: '\$',
                onPriceChanged: (_) {},
                onQuantityChanged: (_) {},
                onUnitChanged: (_) {},
                onLabelChanged: (_) {},
                onDelete: () {},
              ),
            ),
          ),
        ),
      );
      await tester.pumpAndSettle();

      expect(find.text('সেরা ডিল'), findsOneWidget);
      expect(find.textContaining('প্রতি একক খরচ:'), findsOneWidget);
      expect(find.text('গ্রাম (g)'), findsOneWidget);
    });
  });
}
