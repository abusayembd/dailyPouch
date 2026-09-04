import 'dart:typed_data';
import 'package:equatable/equatable.dart';
import '../../domain/entities/compression_preset.dart';

abstract class ImageCompressorEvent extends Equatable {
  const ImageCompressorEvent();

  @override
  List<Object?> get props => [];
}

class SelectPresetEvent extends ImageCompressorEvent {
  final CompressionPreset preset;

  const SelectPresetEvent(this.preset);

  @override
  List<Object?> get props => [preset];
}

class UpdateTargetKbEvent extends ImageCompressorEvent {
  final int targetKb;

  const UpdateTargetKbEvent(this.targetKb);

  @override
  List<Object?> get props => [targetKb];
}

class ProcessImageEvent extends ImageCompressorEvent {
  final Uint8List bytes;
  final String fileName;

  const ProcessImageEvent({
    required this.bytes,
    required this.fileName,
  });

  @override
  List<Object?> get props => [bytes, fileName];
}

class GenerateSampleImageEvent extends ImageCompressorEvent {
  const GenerateSampleImageEvent();
}

class CompilePdfEvent extends ImageCompressorEvent {
  final List<Uint8List> images;

  const CompilePdfEvent(this.images);

  @override
  List<Object?> get props => [images];
}
