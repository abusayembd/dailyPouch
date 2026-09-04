import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:dailypouch/core/localization/app_language.dart';
import 'package:dailypouch/core/localization/app_localizations.dart';
import 'package:dailypouch/core/theme/app_theme.dart';
import 'package:dailypouch/features/pantry_expiry/domain/entities/pantry_item_entity.dart';
import 'package:dailypouch/features/pantry_expiry/presentation/widgets/expiry_status_badge.dart';
import 'package:dailypouch/features/pantry_expiry/presentation/widgets/pantry_item_tile.dart';

void main() {
  group('Pantry Expiry Localization Details', () {
    test('Storage zone and item name translations in Bengali and Spanish', () {
      final l10nBn = AppLocalizations(const Locale('bn'));
      final l10nEs = AppLocalizations(const Locale('es'));

      expect(l10nBn.getStorageZoneName(StorageZone.fridge), equals('ফ্রিজ'));
      expect(l10nBn.getStorageZoneName(StorageZone.medicine), equals('ওষুধের ক্যাবিনেট'));
      expect(l10nBn.getLocalizedPantryItemName('Milk'), equals('দুধ'));
      expect(l10nBn.getLocalizedPantryUnit('pcs'), equals('টি'));

      expect(l10nEs.getStorageZoneName(StorageZone.freezer), equals('Congelador'));
      expect(l10nEs.getLocalizedPantryItemName('Bread'), equals('Pan'));
    });

    testWidgets('ExpiryStatusBadge displays Bengali localized days and labels', (tester) async {
      final item = PantryItemEntity(
        id: 'pantry_1',
        name: 'Milk',
        zone: StorageZone.fridge,
        expiryDate: DateTime.now().add(const Duration(days: 3)),
        quantity: 2,
        unit: 'pcs',
        addedDate: DateTime.now(),
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
            body: ExpiryStatusBadge(item: item),
          ),
        ),
      );
      await tester.pump();

      expect(find.textContaining('৩'), findsOneWidget);
      expect(find.textContaining('দিন বাকি'), findsOneWidget);
    });

    testWidgets('PantryItemTile displays localized zone, quantity and date in Bengali', (tester) async {
      final item = PantryItemEntity(
        id: 'pantry_2',
        name: 'Eggs',
        zone: StorageZone.fridge,
        expiryDate: DateTime(2026, 9, 15),
        quantity: 12,
        unit: 'pcs',
        addedDate: DateTime.now(),
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
            body: PantryItemTile(
              item: item,
              onToggleConsumed: () {},
              onEdit: () {},
              onDelete: () {},
            ),
          ),
        ),
      );
      await tester.pump();

      expect(find.text('ডিম'), findsOneWidget);
      expect(find.textContaining('ফ্রিজ'), findsOneWidget);
      expect(find.textContaining('১২ টি'), findsOneWidget);
    });
  });
}
