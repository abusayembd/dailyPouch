import 'dart:typed_data';
import 'package:bloc_test/bloc_test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:fpdart/fpdart.dart';
import 'package:mocktail/mocktail.dart';
import 'package:dailypouch/features/image_compressor/domain/entities/compression_preset.dart';
import 'package:dailypouch/features/image_compressor/domain/usecases/compile_pdf_usecase.dart';
import 'package:dailypouch/features/image_compressor/domain/usecases/compress_image_usecase.dart';
import 'package:dailypouch/features/image_compressor/presentation/bloc/image_compressor_bloc.dart';
import 'package:dailypouch/features/image_compressor/presentation/bloc/image_compressor_event.dart';
import 'package:dailypouch/features/image_compressor/presentation/bloc/image_compressor_state.dart';

class MockCompressImageUseCase extends Mock implements CompressImageUseCase {}
class MockCompilePdfUseCase extends Mock implements CompilePdfUseCase {}

void main() {
  late ImageCompressorBloc bloc;
  late MockCompressImageUseCase mockCompressImage;
  late MockCompilePdfUseCase mockCompilePdf;

  setUpAll(() {
    registerFallbackValue(CompressImageParams(
      bytes: Uint8List(0),
      fileName: 'test.jpg',
      preset: CompressionPreset.allPresets.first,
    ));
  });

  setUp(() {
    mockCompressImage = MockCompressImageUseCase();
    mockCompilePdf = MockCompilePdfUseCase();

    bloc = ImageCompressorBloc(
      compressImage: mockCompressImage,
      compilePdf: mockCompilePdf,
    );
  });

  tearDown(() {
    bloc.close();
  });

  test('initial state has default preset and 200KB limit', () {
    expect(bloc.state.selectedPreset.type, equals(CompressionPresetType.targetKb200));
    expect(bloc.state.customTargetKb, equals(200));
  });

  blocTest<ImageCompressorBloc, ImageCompressorState>(
    'updates selected preset when SelectPresetEvent is added',
    build: () => bloc,
    act: (b) => b.add(const SelectPresetEvent(CompressionPreset(
      type: CompressionPresetType.passportPhoto,
      title: 'Passport 2x2',
      description: '',
    ))),
    expect: () => [
      isA<ImageCompressorState>().having(
        (s) => s.selectedPreset.type,
        'type',
        CompressionPresetType.passportPhoto,
      ),
    ],
  );

  blocTest<ImageCompressorBloc, ImageCompressorState>(
    'updates target KB when UpdateTargetKbEvent is added',
    build: () => bloc,
    act: (b) => b.add(const UpdateTargetKbEvent(500)),
    expect: () => [
      isA<ImageCompressorState>().having(
        (s) => s.customTargetKb,
        'customTargetKb',
        500,
      ),
    ],
  );

  final testProcessed = ProcessedFileEntity(
    id: 'proc_1',
    fileName: 'test.jpg',
    originalBytes: Uint8List.fromList([1, 2, 3]),
    originalSizeBytes: 3000,
    processedBytes: Uint8List.fromList([1, 2]),
    processedSizeBytes: 1500,
    originalWidth: 800,
    originalHeight: 600,
    processedWidth: 600,
    processedHeight: 600,
    format: 'JPEG',
    preset: CompressionPreset.allPresets.first,
  );

  blocTest<ImageCompressorBloc, ImageCompressorState>(
    'emits isProcessing then lastProcessed when ProcessImageEvent succeeds',
    build: () {
      when(() => mockCompressImage(any()))
          .thenAnswer((_) async => Right(testProcessed));
      return bloc;
    },
    act: (b) => b.add(ProcessImageEvent(
      bytes: Uint8List.fromList([1, 2, 3]),
      fileName: 'test.jpg',
    )),
    expect: () => [
      isA<ImageCompressorState>().having((s) => s.isProcessing, 'isProcessing', true),
      isA<ImageCompressorState>()
          .having((s) => s.isProcessing, 'isProcessing', false)
          .having((s) => s.lastProcessed, 'lastProcessed', testProcessed),
    ],
  );
}
