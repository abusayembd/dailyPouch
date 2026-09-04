import 'dart:typed_data';
import 'package:flutter_test/flutter_test.dart';
import 'package:image/image.dart' as img;
import 'package:dailypouch/features/image_compressor/data/datasources/image_processing_datasource.dart';
import 'package:dailypouch/features/image_compressor/domain/entities/compression_preset.dart';

void main() {
  late ImageProcessingDataSourceImpl dataSource;
  late Uint8List testImageBytes;

  setUp(() {
    dataSource = ImageProcessingDataSourceImpl();

    // Create a 800x600 test image in memory
    final image = img.Image(width: 800, height: 600);
    img.fill(image, color: img.ColorRgb8(100, 150, 200));
    testImageBytes = Uint8List.fromList(img.encodePng(image));
  });

  group('ImageProcessingDataSource', () {
    test('Passport preset crops and resizes image to exact 600x600 dimensions', () async {
      final result = await dataSource.processImage(
        bytes: testImageBytes,
        fileName: 'test.png',
        preset: const CompressionPreset(
          type: CompressionPresetType.passportPhoto,
          title: 'Passport 2x2',
          description: '',
          targetWidth: 600,
          targetHeight: 600,
        ),
      );

      expect(result.processedWidth, equals(600));
      expect(result.processedHeight, equals(600));
      expect(result.processedSizeBytes, greaterThan(0));
    });

    test('Target <100KB preset compresses image bytes', () async {
      final result = await dataSource.processImage(
        bytes: testImageBytes,
        fileName: 'test.png',
        preset: const CompressionPreset(
          type: CompressionPresetType.targetKb100,
          title: 'Ultra Compact',
          description: '',
          targetKb: 100,
        ),
      );

      expect(result.processedKb, lessThanOrEqualTo(100.0));
      expect(result.savingsPercentage, greaterThanOrEqualTo(0.0));
    });

    test('compilePdf generates valid PDF bytes from image list', () async {
      final pdfBytes = await dataSource.compilePdf(images: [testImageBytes]);

      expect(pdfBytes, isNotEmpty);
      // Valid PDF files begin with %PDF header
      final header = String.fromCharCodes(pdfBytes.take(4));
      expect(header, equals('%PDF'));
    });
  });
}
