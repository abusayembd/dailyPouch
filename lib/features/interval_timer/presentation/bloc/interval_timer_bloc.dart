import 'dart:async';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:wakelock_plus/wakelock_plus.dart';
import '../../../../core/usecases/usecase.dart';
import '../../domain/entities/interval_preset_entity.dart';
import '../../domain/usecases/timer_usecases.dart';
import 'interval_timer_event.dart';
import 'interval_timer_state.dart';

class IntervalTimerBloc extends Bloc<IntervalTimerEvent, IntervalTimerState> {
  final GetTimerPresetsUseCase getPresets;
  final SaveTimerPresetUseCase savePreset;

  Timer? _ticker;

  IntervalTimerBloc({
    required this.getPresets,
    required this.savePreset,
  }) : super(IntervalTimerState.initial()) {
    on<LoadPresetsEvent>(_onLoadPresets);
    on<SelectPresetTimerEvent>(_onSelectPreset);
    on<StartTimerEvent>(_onStartTimer);
    on<PauseTimerEvent>(_onPauseTimer);
    on<ResumeTimerEvent>(_onResumeTimer);
    on<ResetTimerEvent>(_onResetTimer);
    on<SkipIntervalEvent>(_onSkipInterval);
    on<TimerTickEvent>(_onTimerTick);
    on<SaveCustomPresetEvent>(_onSaveCustomPreset);
  }

  @override
  Future<void> close() {
    _ticker?.cancel();
    WakelockPlus.disable().ignore();
    return super.close();
  }

  void _onLoadPresets(
    LoadPresetsEvent event,
    Emitter<IntervalTimerState> emit,
  ) async {
    final result = await getPresets(const NoParams());
    result.fold(
      (failure) => null,
      (presets) => emit(state.copyWith(presets: presets)),
    );
  }

  void _onSelectPreset(
    SelectPresetTimerEvent event,
    Emitter<IntervalTimerState> emit,
  ) {
    _ticker?.cancel();
    WakelockPlus.disable().ignore();

    final preset = event.preset;
    emit(state.copyWith(
      selectedPreset: preset,
      currentPhase: TimerPhase.idle,
      currentSet: 1,
      currentSecondsRemaining: preset.workSeconds,
      totalPhaseSeconds: preset.workSeconds,
      totalElapsedSeconds: 0,
      isRunning: false,
      isPaused: false,
    ));
  }

  void _onStartTimer(
    StartTimerEvent event,
    Emitter<IntervalTimerState> emit,
  ) {
    _ticker?.cancel();
    WakelockPlus.enable().ignore();

    final preset = state.selectedPreset;
    TimerPhase startPhase;
    int duration;

    if (preset.prepSeconds > 0) {
      startPhase = TimerPhase.prepare;
      duration = preset.prepSeconds;
    } else {
      startPhase = TimerPhase.work;
      duration = preset.workSeconds;
    }

    emit(state.copyWith(
      currentPhase: startPhase,
      currentSet: 1,
      currentSecondsRemaining: duration,
      totalPhaseSeconds: duration,
      totalElapsedSeconds: 0,
      isRunning: true,
      isPaused: false,
    ));

    _startTicker();
  }

  void _onPauseTimer(
    PauseTimerEvent event,
    Emitter<IntervalTimerState> emit,
  ) {
    _ticker?.cancel();
    WakelockPlus.disable().ignore();
    emit(state.copyWith(isRunning: false, isPaused: true));
  }

  void _onResumeTimer(
    ResumeTimerEvent event,
    Emitter<IntervalTimerState> emit,
  ) {
    WakelockPlus.enable().ignore();
    emit(state.copyWith(isRunning: true, isPaused: false));
    _startTicker();
  }

  void _onResetTimer(
    ResetTimerEvent event,
    Emitter<IntervalTimerState> emit,
  ) {
    _ticker?.cancel();
    WakelockPlus.disable().ignore();

    final preset = state.selectedPreset;
    emit(state.copyWith(
      currentPhase: TimerPhase.idle,
      currentSet: 1,
      currentSecondsRemaining: preset.workSeconds,
      totalPhaseSeconds: preset.workSeconds,
      totalElapsedSeconds: 0,
      isRunning: false,
      isPaused: false,
    ));
  }

  void _onSkipInterval(
    SkipIntervalEvent event,
    Emitter<IntervalTimerState> emit,
  ) {
    _advanceToNextInterval(emit);
  }

  void _onTimerTick(
    TimerTickEvent event,
    Emitter<IntervalTimerState> emit,
  ) {
    if (!state.isRunning) return;

    if (state.currentSecondsRemaining > 1) {
      emit(state.copyWith(
        currentSecondsRemaining: state.currentSecondsRemaining - 1,
        totalElapsedSeconds: state.totalElapsedSeconds + 1,
      ));
    } else {
      emit(state.copyWith(
        totalElapsedSeconds: state.totalElapsedSeconds + 1,
      ));
      _advanceToNextInterval(emit);
    }
  }

  void _advanceToNextInterval(Emitter<IntervalTimerState> emit) {
    final preset = state.selectedPreset;

    switch (state.currentPhase) {
      case TimerPhase.idle:
        break;

      case TimerPhase.prepare:
        // Move to Work Set 1
        emit(state.copyWith(
          currentPhase: TimerPhase.work,
          currentSet: 1,
          currentSecondsRemaining: preset.workSeconds,
          totalPhaseSeconds: preset.workSeconds,
        ));
        break;

      case TimerPhase.work:
        if (state.currentSet < preset.totalSets) {
          // If rest duration > 0, go to Rest, else next Work set
          if (preset.restSeconds > 0) {
            emit(state.copyWith(
              currentPhase: TimerPhase.rest,
              currentSecondsRemaining: preset.restSeconds,
              totalPhaseSeconds: preset.restSeconds,
            ));
          } else {
            emit(state.copyWith(
              currentPhase: TimerPhase.work,
              currentSet: state.currentSet + 1,
              currentSecondsRemaining: preset.workSeconds,
              totalPhaseSeconds: preset.workSeconds,
            ));
          }
        } else {
          // Finished all sets
          if (preset.cooldownSeconds > 0) {
            emit(state.copyWith(
              currentPhase: TimerPhase.cooldown,
              currentSecondsRemaining: preset.cooldownSeconds,
              totalPhaseSeconds: preset.cooldownSeconds,
            ));
          } else {
            _completeWorkout(emit);
          }
        }
        break;

      case TimerPhase.rest:
        emit(state.copyWith(
          currentPhase: TimerPhase.work,
          currentSet: state.currentSet + 1,
          currentSecondsRemaining: preset.workSeconds,
          totalPhaseSeconds: preset.workSeconds,
        ));
        break;

      case TimerPhase.cooldown:
        _completeWorkout(emit);
        break;

      case TimerPhase.completed:
        break;
    }
  }

  void _completeWorkout(Emitter<IntervalTimerState> emit) {
    _ticker?.cancel();
    WakelockPlus.disable().ignore();
    emit(state.copyWith(
      currentPhase: TimerPhase.completed,
      currentSecondsRemaining: 0,
      totalPhaseSeconds: 1,
      isRunning: false,
      isPaused: false,
      message: 'Workout Complete! Great job.',
    ));
  }

  void _onSaveCustomPreset(
    SaveCustomPresetEvent event,
    Emitter<IntervalTimerState> emit,
  ) async {
    final result = await savePreset(event.preset);
    result.fold(
      (failure) => emit(state.copyWith(message: failure.message)),
      (_) {
        final updatedList = List<IntervalPresetEntity>.from(state.presets);
        final index = updatedList.indexWhere((p) => p.id == event.preset.id);
        if (index >= 0) {
          updatedList[index] = event.preset;
        } else {
          updatedList.add(event.preset);
        }
        emit(state.copyWith(
          presets: updatedList,
          selectedPreset: event.preset,
          currentSecondsRemaining: event.preset.workSeconds,
          totalPhaseSeconds: event.preset.workSeconds,
          message: 'Saved preset: ${event.preset.name}',
        ));
      },
    );
  }

  void _startTicker() {
    _ticker?.cancel();
    _ticker = Timer.periodic(const Duration(seconds: 1), (_) {
      add(const TimerTickEvent());
    });
  }
}
