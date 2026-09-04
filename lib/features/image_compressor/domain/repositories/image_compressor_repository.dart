import 'dart:typed_data';
import 'package:fpdart/fpdart.dart';
import '../../../../core/error/failures.dart';
import '../entities/compression_preset.dart';

abstract class ImageCompressorRepository {
  Future<Either<Failure, ProcessedFileEntity>> compressImage({
    required Uint8List bytes,
    required String fileName,
    required CompressionPreset preset,
  });

  Future<Either<Failure, Uint8List>> compileImagesToPdf({
    required List<Uint8List> images,
  });
}
