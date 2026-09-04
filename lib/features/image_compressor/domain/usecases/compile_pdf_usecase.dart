import 'dart:typed_data';
import 'package:fpdart/fpdart.dart';
import '../../../../core/error/failures.dart';
import '../../../../core/usecases/usecase.dart';
import '../repositories/image_compressor_repository.dart';

class CompilePdfUseCase implements UseCase<Uint8List, List<Uint8List>> {
  final ImageCompressorRepository repository;

  CompilePdfUseCase(this.repository);

  @override
  Future<Either<Failure, Uint8List>> call(List<Uint8List> images) async {
    if (images.isEmpty) {
      return const Left(ValidationFailure('No images provided for PDF generation.'));
    }
    return await repository.compileImagesToPdf(images: images);
  }
}
