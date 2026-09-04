import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:dailypouch/core/localization/app_localizations.dart';

void main() {
  group('Expense Tracker Multi-Language Localization Tests', () {
    const supportedCodes = ['en', 'bn', 'es', 'fr', 'de', 'hi', 'ar', 'zh', 'ja'];

    test('verifies module title and description localized across all 9 languages', () {
      for (final code in supportedCodes) {
        final l10n = AppLocalizations(Locale(code));
        final title = l10n.getModuleTitle('expense_tracker');
        final desc = l10n.getModuleDescription('expense_tracker');
        final badge = l10n.getModuleBadge('expense_tracker');

        expect(title.isNotEmpty, isTrue, reason: 'Title empty for $code');
        expect(desc.isNotEmpty, isTrue, reason: 'Description empty for $code');
        expect(badge.isNotEmpty, isTrue, reason: 'Badge empty for $code');
      }
    });

    test('verifies English, Bengali, Spanish specific translations for Expense Tracker', () {
      final en = AppLocalizations(const Locale('en'));
      expect(en.getModuleTitle('expense_tracker'), equals('Daily Expense Tracker'));
      expect(en.getModuleBadge('expense_tracker'), equals('MONEY'));

      final bn = AppLocalizations(const Locale('bn'));
      expect(bn.getModuleTitle('expense_tracker'), equals('দৈনিক খরচ ট্র্যাকার'));
      expect(bn.getModuleBadge('expense_tracker'), equals('আর্থিক'));

      final es = AppLocalizations(const Locale('es'));
      expect(es.getModuleTitle('expense_tracker'), equals('Control de Gastos'));
      expect(es.getModuleBadge('expense_tracker'), equals('FINANZAS'));
    });

    test('verifies number and currency formatting for English, Bengali, and Arabic', () {
      final en = AppLocalizations(const Locale('en'));
      expect(en.formatCurrency(1250.50, '\$'), equals('\$1250.50'));

      final bn = AppLocalizations(const Locale('bn'));
      expect(bn.formatCurrency(1250.50, '৳'), equals('৳১২৫০.৫০'));

      final ar = AppLocalizations(const Locale('ar'));
      expect(ar.formatCurrency(1250.50, 'د.إ'), equals('د.إ١٢٥٠.٥٠'));
    });
  });
}
