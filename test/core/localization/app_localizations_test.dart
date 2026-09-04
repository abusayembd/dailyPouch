import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:dailypouch/core/localization/app_localizations.dart';

void main() {
  group('AppLocalizations Translations', () {
    test('English translations match expected defaults', () {
      final l10n = AppLocalizations(const Locale('en'));
      expect(l10n.appTitle, 'DailyPouch');
      expect(l10n.appSubtitle, 'Offline Life Tools');
      expect(l10n.subTrackerTitle, 'Subscriptions');
      expect(l10n.monthlyCashBurn, 'MONTHLY CASH BURN');
      expect(l10n.inXDays(3), 'In 3 Days');
      expect(l10n.inXDays(1), 'In 1 Day');
      expect(l10n.dueToday, 'Due Today');
      expect(l10n.overdueByDays(2), 'Overdue by 2 Days');
    });

    test('Bengali translations return localized values', () {
      final l10n = AppLocalizations(const Locale('bn'));
      expect(l10n.appTitle, 'ডেইলি পাউচ');
      expect(l10n.appSubtitle, 'অফলাইন লাইফ টুলস');
      expect(l10n.subTrackerTitle, 'সাবস্ক্রিপশন ও বিল');
      expect(l10n.monthlyCashBurn, 'মাসিক মোট খরচ');
      expect(l10n.paid, 'পরিশোধিত');
      expect(l10n.unpaid, 'অপরিশোধিত');
    });

    test('Spanish translations return localized values', () {
      final l10n = AppLocalizations(const Locale('es'));
      expect(l10n.subTrackerTitle, 'Suscripciones');
      expect(l10n.paid, 'Pagado');
      expect(l10n.unpaid, 'Pendiente');
    });
  });
}
