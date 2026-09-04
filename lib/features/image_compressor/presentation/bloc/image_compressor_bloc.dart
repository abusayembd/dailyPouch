import 'dart:typed_data';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image/image.dart' as img;
import '../../domain/entities/compression_preset.dart';
import '../../domain/usecases/compile_pdf_usecase.dart';
import '../../domain/usecases/compress_image_usecase.dart';
import 'image_compressor_event.dart';
import 'image_compressor_state.dart';

class ImageCompressorBloc extends Bloc<ImageCompressorEvent, ImageCompressorState> {
  final CompressImageUseCase compressImage;
  final CompilePdfUseCase compilePdf;

  ImageCompressorBloc({
    required this.compressImage,
    required this.compilePdf,
  }) : super(ImageCompressorState.initial()) {
    on<SelectPresetEvent>(_onSelectPreset);
    on<UpdateTargetKbEvent>(_onUpdateTargetKb);
    on<ProcessImageEvent>(_onProcessImage);
    on<GenerateSampleImageEvent>(_onGenerateSampleImage);
    on<CompilePdfEvent>(_onCompilePdf);
  }

  void _onSelectPreset(
    SelectPresetEvent event,
    Emitter<ImageCompressorState> emit,
  ) {
    emit(state.copyWith(selectedPreset: event.preset));
    // If we already have a processed file, re-process with the new preset
    if (state.lastProcessed != null) {
      add(ProcessImageEvent(
        bytes: state.lastProcessed!.originalBytes,
        fileName: state.lastProcessed!.fileName,
      ));
    }
  }

  void _onUpdateTargetKb(
    UpdateTargetKbEvent event,
    Emitter<ImageCompressorState> emit,
  ) {
    final customPreset = CompressionPreset(
      type: CompressionPresetType.custom,
      title: 'Custom (<${event.targetKb}KB)',
      description: 'Compress to exact target file size of ${event.targetKb} KB.',
      targetKb: event.targetKb,
      quality: 75,
    );

    emit(state.copyWith(
      selectedPreset: customPreset,
      customTargetKb: event.targetKb,
    ));

    if (state.lastProcessed != null) {
      add(ProcessImageEvent(
        bytes: state.lastProcessed!.originalBytes,
        fileName: state.lastProcessed!.fileName,
      ));
    }
  }

  Future<void> _onProcessImage(
    ProcessImageEvent event,
    Emitter<ImageCompressorState> emit,
  ) async {
    emit(state.copyWith(isProcessing: true, errorMessage: null));

    final result = await compressImage(CompressImageParams(
      bytes: event.bytes,
      fileName: event.fileName,
      preset: state.selectedPreset,
    ));

    result.fold(
      (failure) => emit(state.copyWith(
        isProcessing: false,
        errorMessage: failure.message,
      )),
      (processed) => emit(state.copyWith(
        isProcessing: false,
        lastProcessed: processed,
        successMessage: 'Compressed from ${processed.originalKb.toStringAsFixed(1)} KB to ${processed.processedKb.toStringAsFixed(1)} KB (${processed.savingsPercentage.toStringAsFixed(0)}% saved)',
      )),
    );
  }

  Future<void> _onGenerateSampleImage(
    GenerateSampleImageEvent event,
    Emitter<ImageCompressorState> emit,
  ) async {
    emit(state.copyWith(isProcessing: true));

    // Generate a high-resolution synthetic test photo (1200x900)
    final image = img.Image(width: 1200, height: 900);
    for (var y = 0; y < 900; y++) {
      for (var x = 0; x < 1200; x++) {
        final r = (x * 255 / 1200).round();
        final g = (y * 255 / 900).round();
        final b = 200;
        image.setPixelRgb(x, y, r, g, b);
      }
    }

    // Draw grid lines
    img.drawCircle(image, x: 600, y: 450, radius: 250, color: img.ColorRgb8(255, 255, 255));
    img.drawString(image, 'DAILYPOUCH TEST DOCUMENT', font: img.arial24, x: 420, y: 430);

    final rawBytes = Uint8List.fromList(img.encodePng(image));

    add(ProcessImageEvent(
      bytes: rawBytes,
      fileName: 'test_document_scan.png',
    ));
  }

  Future<void> _onCompilePdf(
    CompilePdfEvent event,
    Emitter<ImageCompressorState> emit,
  ) async {
    emit(state.copyWith(isProcessing: true));

    final result = await compilePdf(event.images);
    result.fold(
      (failure) => emit(state.copyWith(
        isProcessing: false,
        errorMessage: failure.message,
      )),
      (pdfBytes) => emit(state.copyWith(
        isProcessing: false,
        compiledPdf: pdfBytes,
        successMessage: 'PDF document generated (${(pdfBytes.lengthInBytes / 1024).toStringAsFixed(1)} KB)',
      )),
    );
  }
}
