import 'dart:typed_data';
import 'package:fpdart/fpdart.dart';
import '../../../../core/error/exceptions.dart';
import '../../../../core/error/failures.dart';
import '../../domain/entities/compression_preset.dart';
import '../../domain/repositories/image_compressor_repository.dart';
import '../datasources/image_processing_datasource.dart';

class ImageCompressorRepositoryImpl implements ImageCompressorRepository {
  final ImageProcessingDataSource dataSource;

  ImageCompressorRepositoryImpl({required this.dataSource});

  @override
  Future<Either<Failure, ProcessedFileEntity>> compressImage({
    required Uint8List bytes,
    required String fileName,
    required CompressionPreset preset,
  }) async {
    try {
      final processed = await dataSource.processImage(
        bytes: bytes,
        fileName: fileName,
        preset: preset,
      );
      return Right(processed);
    } on CacheException catch (e) {
      return Left(CacheFailure(e.message));
    } catch (e) {
      return Left(UnexpectedFailure('Image compression failed: $e'));
    }
  }

  @override
  Future<Either<Failure, Uint8List>> compileImagesToPdf({
    required List<Uint8List> images,
  }) async {
    try {
      final pdfBytes = await dataSource.compilePdf(images: images);
      return Right(pdfBytes);
    } on CacheException catch (e) {
      return Left(CacheFailure(e.message));
    } catch (e) {
      return Left(UnexpectedFailure('PDF compilation failed: $e'));
    }
  }
}
