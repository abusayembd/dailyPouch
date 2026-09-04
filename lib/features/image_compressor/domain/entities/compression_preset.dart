import 'dart:typed_data';
import 'package:equatable/equatable.dart';

enum CompressionPresetType {
  targetKb200,    // Target < 200 KB
  targetKb100,    // Target < 100 KB
  passportPhoto,  // 600x600 px (1:1 square)
  signatureStrip, // 400x150 px
  a4Document,     // 1240x1754 px
  custom,
}

class CompressionPreset extends Equatable {
  final CompressionPresetType type;
  final String title;
  final String description;
  final int? targetKb;
  final int? targetWidth;
  final int? targetHeight;
  final int quality; // 1 to 100

  const CompressionPreset({
    required this.type,
    required this.title,
    required this.description,
    this.targetKb,
    this.targetWidth,
    this.targetHeight,
    this.quality = 80,
  });

  static const List<CompressionPreset> allPresets = [
    CompressionPreset(
      type: CompressionPresetType.targetKb200,
      title: 'Portal Standard (<200KB)',
      description: 'Ideal for job applications, university portals, and visa forms.',
      targetKb: 200,
      quality: 75,
    ),
    CompressionPreset(
      type: CompressionPresetType.targetKb100,
      title: 'Ultra Compact (<100KB)',
      description: 'Strict upload limits and government web forms.',
      targetKb: 100,
      quality: 60,
    ),
    CompressionPreset(
      type: CompressionPresetType.passportPhoto,
      title: 'Passport 2x2 (600x600)',
      description: 'Standard square biometric crop for ID cards and passports.',
      targetWidth: 600,
      targetHeight: 600,
      quality: 90,
    ),
    CompressionPreset(
      type: CompressionPresetType.signatureStrip,
      title: 'Signature Strip',
      description: 'Wide aspect crop (400x150) for signatures and stamps.',
      targetWidth: 400,
      targetHeight: 150,
      quality: 90,
    ),
    CompressionPreset(
      type: CompressionPresetType.a4Document,
      title: 'A4 Document Scan',
      description: 'Standard letter/A4 aspect ratio for scanned documents.',
      targetWidth: 1240,
      targetHeight: 1754,
      quality: 80,
    ),
  ];

  @override
  List<Object?> get props => [
        type,
        title,
        description,
        targetKb,
        targetWidth,
        targetHeight,
        quality,
      ];
}

class ProcessedFileEntity extends Equatable {
  final String id;
  final String fileName;
  final Uint8List originalBytes;
  final int originalSizeBytes;
  final Uint8List processedBytes;
  final int processedSizeBytes;
  final int originalWidth;
  final int originalHeight;
  final int processedWidth;
  final int processedHeight;
  final String format;
  final CompressionPreset preset;

  const ProcessedFileEntity({
    required this.id,
    required this.fileName,
    required this.originalBytes,
    required this.originalSizeBytes,
    required this.processedBytes,
    required this.processedSizeBytes,
    required this.originalWidth,
    required this.originalHeight,
    required this.processedWidth,
    required this.processedHeight,
    required this.format,
    required this.preset,
  });

  /// Percentage reduced from original size.
  double get savingsPercentage {
    if (originalSizeBytes <= 0) return 0.0;
    final diff = originalSizeBytes - processedSizeBytes;
    if (diff <= 0) return 0.0;
    return (diff / originalSizeBytes) * 100;
  }

  /// Size formatted in KB.
  double get originalKb => originalSizeBytes / 1024.0;
  double get processedKb => processedSizeBytes / 1024.0;

  @override
  List<Object?> get props => [
        id,
        fileName,
        originalSizeBytes,
        processedSizeBytes,
        originalWidth,
        originalHeight,
        processedWidth,
        processedHeight,
        format,
        preset,
      ];
}
