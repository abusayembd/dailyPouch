import 'dart:typed_data';
import 'package:equatable/equatable.dart';
import '../../domain/entities/compression_preset.dart';

class ImageCompressorState extends Equatable {
  final CompressionPreset selectedPreset;
  final int customTargetKb;
  final ProcessedFileEntity? lastProcessed;
  final Uint8List? compiledPdf;
  final bool isProcessing;
  final String? errorMessage;
  final String? successMessage;

  const ImageCompressorState({
    required this.selectedPreset,
    this.customTargetKb = 200,
    this.lastProcessed,
    this.compiledPdf,
    this.isProcessing = false,
    this.errorMessage,
    this.successMessage,
  });

  factory ImageCompressorState.initial() {
    return ImageCompressorState(
      selectedPreset: CompressionPreset.allPresets.first,
      customTargetKb: 200,
    );
  }

  ImageCompressorState copyWith({
    CompressionPreset? selectedPreset,
    int? customTargetKb,
    ProcessedFileEntity? lastProcessed,
    Uint8List? compiledPdf,
    bool? isProcessing,
    String? errorMessage,
    String? successMessage,
  }) {
    return ImageCompressorState(
      selectedPreset: selectedPreset ?? this.selectedPreset,
      customTargetKb: customTargetKb ?? this.customTargetKb,
      lastProcessed: lastProcessed ?? this.lastProcessed,
      compiledPdf: compiledPdf ?? this.compiledPdf,
      isProcessing: isProcessing ?? this.isProcessing,
      errorMessage: errorMessage,
      successMessage: successMessage,
    );
  }

  @override
  List<Object?> get props => [
        selectedPreset,
        customTargetKb,
        lastProcessed,
        compiledPdf,
        isProcessing,
        errorMessage,
        successMessage,
      ];
}
