import 'dart:typed_data';
import 'package:equatable/equatable.dart';
import 'package:fpdart/fpdart.dart';
import '../../../../core/error/failures.dart';
import '../../../../core/usecases/usecase.dart';
import '../entities/compression_preset.dart';
import '../repositories/image_compressor_repository.dart';

class CompressImageParams extends Equatable {
  final Uint8List bytes;
  final String fileName;
  final CompressionPreset preset;

  const CompressImageParams({
    required this.bytes,
    required this.fileName,
    required this.preset,
  });

  @override
  List<Object?> get props => [bytes, fileName, preset];
}

class CompressImageUseCase implements UseCase<ProcessedFileEntity, CompressImageParams> {
  final ImageCompressorRepository repository;

  CompressImageUseCase(this.repository);

  @override
  Future<Either<Failure, ProcessedFileEntity>> call(CompressImageParams params) async {
    if (params.bytes.isEmpty) {
      return const Left(ValidationFailure('Image data is empty.'));
    }
    return await repository.compressImage(
      bytes: params.bytes,
      fileName: params.fileName,
      preset: params.preset,
    );
  }
}
