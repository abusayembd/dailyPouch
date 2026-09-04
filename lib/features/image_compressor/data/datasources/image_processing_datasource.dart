import 'dart:typed_data';
import 'package:image/image.dart' as img;
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:uuid/uuid.dart';
import '../../../../core/error/exceptions.dart';
import '../../domain/entities/compression_preset.dart';

abstract class ImageProcessingDataSource {
  Future<ProcessedFileEntity> processImage({
    required Uint8List bytes,
    required String fileName,
    required CompressionPreset preset,
  });

  Future<Uint8List> compilePdf({
    required List<Uint8List> images,
  });
}

class ImageProcessingDataSourceImpl implements ImageProcessingDataSource {
  @override
  Future<ProcessedFileEntity> processImage({
    required Uint8List bytes,
    required String fileName,
    required CompressionPreset preset,
  }) async {
    try {
      final originalSize = bytes.lengthInBytes;
      final decoded = img.decodeImage(bytes);

      if (decoded == null) {
        throw CacheException('Unsupported image format or corrupt file.');
      }

      final origWidth = decoded.width;
      final origHeight = decoded.height;

      img.Image processed = decoded;

      // Handle Dimensional presets (Passport 600x600, Signature, A4)
      if (preset.targetWidth != null && preset.targetHeight != null) {
        if (preset.type == CompressionPresetType.passportPhoto) {
          // Crop square center first, then resize to 600x600
          final minSide = origWidth < origHeight ? origWidth : origHeight;
          final x = (origWidth - minSide) ~/ 2;
          final y = (origHeight - minSide) ~/ 2;
          processed = img.copyCrop(decoded, x: x, y: y, width: minSide, height: minSide);
          processed = img.copyResize(processed, width: preset.targetWidth!, height: preset.targetHeight!);
        } else {
          processed = img.copyResize(decoded, width: preset.targetWidth!, height: preset.targetHeight!);
        }
      } else if (preset.targetKb != null) {
        // Target file size limit in KB -> adjust dimensions if too large
        if (originalSize > preset.targetKb! * 1024 * 2) {
          final scaleFactor = 0.75;
          processed = img.copyResize(
            decoded,
            width: (origWidth * scaleFactor).round(),
            height: (origHeight * scaleFactor).round(),
          );
        }
      }

      // Encode as compressed JPEG
      int quality = preset.quality;
      Uint8List encodedBytes = Uint8List.fromList(img.encodeJpg(processed, quality: quality));

      // If targetKb is set and encoded size exceeds target, progressively reduce quality
      if (preset.targetKb != null) {
        final maxBytes = preset.targetKb! * 1024;
        while (encodedBytes.lengthInBytes > maxBytes && quality > 20) {
          quality -= 15;
          encodedBytes = Uint8List.fromList(img.encodeJpg(processed, quality: quality));
        }
      }

      return ProcessedFileEntity(
        id: const Uuid().v4(),
        fileName: fileName.endsWith('.jpg') ? fileName : '${fileName.split('.').first}.jpg',
        originalBytes: bytes,
        originalSizeBytes: originalSize,
        processedBytes: encodedBytes,
        processedSizeBytes: encodedBytes.lengthInBytes,
        originalWidth: origWidth,
        originalHeight: origHeight,
        processedWidth: processed.width,
        processedHeight: processed.height,
        format: 'JPEG',
        preset: preset,
      );
    } catch (e) {
      throw CacheException('Image processing failed: $e');
    }
  }

  @override
  Future<Uint8List> compilePdf({required List<Uint8List> images}) async {
    try {
      final pdf = pw.Document();

      for (final imgBytes in images) {
        final imageProvider = pw.MemoryImage(imgBytes);
        pdf.addPage(
          pw.Page(
            pageFormat: PdfPageFormat.a4,
            build: (pw.Context context) {
              return pw.Center(
                child: pw.Image(imageProvider, fit: pw.BoxFit.contain),
              );
            },
          ),
        );
      }

      return await pdf.save();
    } catch (e) {
      throw CacheException('PDF compilation failed: $e');
    }
  }
}
