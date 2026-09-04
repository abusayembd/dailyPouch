import 'package:bloc_test/bloc_test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:fpdart/fpdart.dart';
import 'package:mocktail/mocktail.dart';
import 'package:dailypouch/core/usecases/usecase.dart';
import 'package:dailypouch/features/interval_timer/domain/entities/interval_preset_entity.dart';
import 'package:dailypouch/features/interval_timer/domain/usecases/timer_usecases.dart';
import 'package:dailypouch/features/interval_timer/presentation/bloc/interval_timer_bloc.dart';
import 'package:dailypouch/features/interval_timer/presentation/bloc/interval_timer_event.dart';
import 'package:dailypouch/features/interval_timer/presentation/bloc/interval_timer_state.dart';

class MockGetTimerPresetsUseCase extends Mock implements GetTimerPresetsUseCase {}
class MockSaveTimerPresetUseCase extends Mock implements SaveTimerPresetUseCase {}

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  late IntervalTimerBloc bloc;
  late MockGetTimerPresetsUseCase mockGetPresets;
  late MockSaveTimerPresetUseCase mockSavePreset;

  setUp(() {
    mockGetPresets = MockGetTimerPresetsUseCase();
    mockSavePreset = MockSaveTimerPresetUseCase();

    when(() => mockGetPresets(const NoParams()))
        .thenAnswer((_) async => const Right(IntervalPresetEntity.defaultPresets));

    bloc = IntervalTimerBloc(
      getPresets: mockGetPresets,
      savePreset: mockSavePreset,
    );
  });

  tearDown(() {
    bloc.close();
  });

  test('initial state has default preset selected in idle phase', () {
    expect(bloc.state.currentPhase, equals(TimerPhase.idle));
    expect(bloc.state.selectedPreset.id, equals('tabata'));
  });

  blocTest<IntervalTimerBloc, IntervalTimerState>(
    'starts countdown in prepare phase when StartTimerEvent is added',
    build: () => bloc,
    act: (b) => b.add(const StartTimerEvent()),
    expect: () => [
      isA<IntervalTimerState>()
          .having((s) => s.currentPhase, 'currentPhase', TimerPhase.prepare)
          .having((s) => s.isRunning, 'isRunning', true),
    ],
  );

  blocTest<IntervalTimerBloc, IntervalTimerState>(
    'pauses timer when PauseTimerEvent is added',
    build: () => bloc,
    seed: () => bloc.state.copyWith(
      currentPhase: TimerPhase.work,
      isRunning: true,
    ),
    act: (b) => b.add(const PauseTimerEvent()),
    expect: () => [
      isA<IntervalTimerState>()
          .having((s) => s.isRunning, 'isRunning', false)
          .having((s) => s.isPaused, 'isPaused', true),
    ],
  );

  blocTest<IntervalTimerBloc, IntervalTimerState>(
    'resets timer back to idle when ResetTimerEvent is added',
    build: () => bloc,
    seed: () => bloc.state.copyWith(
      currentPhase: TimerPhase.work,
      isRunning: true,
      currentSet: 3,
    ),
    act: (b) => b.add(const ResetTimerEvent()),
    expect: () => [
      isA<IntervalTimerState>()
          .having((s) => s.currentPhase, 'currentPhase', TimerPhase.idle)
          .having((s) => s.currentSet, 'currentSet', 1)
          .having((s) => s.isRunning, 'isRunning', false),
    ],
  );
}
