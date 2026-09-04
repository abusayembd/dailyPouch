import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:dailypouch/core/localization/app_language.dart';
import 'package:dailypouch/core/localization/app_localizations.dart';
import 'package:dailypouch/core/theme/app_theme.dart';
import 'package:dailypouch/features/image_compressor/domain/entities/compression_preset.dart';
import 'package:dailypouch/features/image_compressor/presentation/widgets/compression_preview_card.dart';
import 'package:dailypouch/features/image_compressor/presentation/widgets/preset_selector_chip_group.dart';

void main() {
  group('Image Compressor Localization Details', () {
    test('Preset title translations in Bengali and Spanish', () {
      final l10nBn = AppLocalizations(const Locale('bn'));
      final l10nEs = AppLocalizations(const Locale('es'));

      expect(
        l10nBn.getLocalizedCompressionPresetTitle(CompressionPresetType.passportPhoto),
        equals('পাসপোর্ট ২x২ (৬০০x৬০০)'),
      );
      expect(
        l10nBn.getLocalizedCompressionPresetTitle(CompressionPresetType.targetKb100),
        equals('আল্ট্রা কমপ্যাক্ট (<১০০KB)'),
      );

      expect(
        l10nEs.getLocalizedCompressionPresetTitle(CompressionPresetType.passportPhoto),
        equals('Pasaporte 2x2 (600x600)'),
      );
    });

    testWidgets('PresetSelectorChipGroup displays localized preset titles in Bengali', (tester) async {
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
            body: PresetSelectorChipGroup(
              selectedPreset: CompressionPreset.allPresets.first,
              onPresetSelected: (_) {},
            ),
          ),
        ),
      );
      await tester.pump();

      expect(find.text('পোর্টাল স্ট্যান্ডার্ড (<২০০KB)'), findsOneWidget);
    });

    testWidgets('CompressionPreviewCard displays localized dimensions and numbers in Bengali', (tester) async {
      // 1x1 transparent PNG bytes
      final sampleBytes = Uint8List.fromList([
        0x89, 0x50, 0x4E, 0x47, 0x0D, 0x0A, 0x1A, 0x0A,
        0x00, 0x00, 0x00, 0x0D, 0x49, 0x48, 0x44, 0x52,
        0x00, 0x00, 0x00, 0x01, 0x00, 0x00, 0x00, 0x01,
        0x08, 0x06, 0x00, 0x00, 0x00, 0x1F, 0x15, 0xC4,
        0x89, 0x00, 0x00, 0x00, 0x0A, 0x49, 0x44, 0x41,
        0x54, 0x78, 0x9C, 0x63, 0x00, 0x01, 0x00, 0x00,
        0x05, 0x00, 0x01, 0x0D, 0x0A, 0x2D, 0xB4, 0x00,
        0x00, 0x00, 0x00, 0x49, 0x45, 0x4E, 0x44, 0xAE,
        0x42, 0x60, 0x82
      ]);

      final processed = ProcessedFileEntity(
        id: 'proc_1',
        fileName: 'sample.png',
        originalBytes: sampleBytes,
        originalSizeBytes: 204800,
        processedBytes: sampleBytes,
        processedSizeBytes: 51200,
        originalWidth: 1200,
        originalHeight: 800,
        processedWidth: 600,
        processedHeight: 400,
        format: 'JPEG',
        preset: CompressionPreset.allPresets.first,
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
            body: CompressionPreviewCard(processed: processed),
          ),
        ),
      );
      await tester.pump();

      expect(find.text('কম্প্রেশন ফলাফল'), findsOneWidget);
      expect(find.text('-৭৫% হ্রাস পেয়েছে'), findsOneWidget);
      expect(find.text('২০০.০ KB'), findsOneWidget);
      expect(find.text('৫০.০ KB'), findsOneWidget);
    });
  });
}
