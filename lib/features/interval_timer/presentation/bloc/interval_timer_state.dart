import 'package:equatable/equatable.dart';
import '../../domain/entities/interval_preset_entity.dart';

enum TimerPhase {
  idle,
  prepare,
  work,
  rest,
  cooldown,
  completed,
}

class IntervalTimerState extends Equatable {
  final List<IntervalPresetEntity> presets;
  final IntervalPresetEntity selectedPreset;
  final TimerPhase currentPhase;
  final int currentSet;
  final int currentSecondsRemaining;
  final int totalPhaseSeconds;
  final int totalElapsedSeconds;
  final bool isRunning;
  final bool isPaused;
  final String? message;

  const IntervalTimerState({
    required this.presets,
    required this.selectedPreset,
    this.currentPhase = TimerPhase.idle,
    this.currentSet = 1,
    this.currentSecondsRemaining = 0,
    this.totalPhaseSeconds = 1,
    this.totalElapsedSeconds = 0,
    this.isRunning = false,
    this.isPaused = false,
    this.message,
  });

  factory IntervalTimerState.initial() {
    final firstPreset = IntervalPresetEntity.defaultPresets.first;
    return IntervalTimerState(
      presets: IntervalPresetEntity.defaultPresets,
      selectedPreset: firstPreset,
      currentPhase: TimerPhase.idle,
      currentSet: 1,
      currentSecondsRemaining: firstPreset.workSeconds,
      totalPhaseSeconds: firstPreset.workSeconds,
      totalElapsedSeconds: 0,
      isRunning: false,
      isPaused: false,
    );
  }

  /// Progress ratio from 0.0 to 1.0 for countdown circle gauge.
  double get progressRatio {
    if (totalPhaseSeconds <= 0) return 1.0;
    return (currentSecondsRemaining / totalPhaseSeconds).clamp(0.0, 1.0);
  }

  IntervalTimerState copyWith({
    List<IntervalPresetEntity>? presets,
    IntervalPresetEntity? selectedPreset,
    TimerPhase? currentPhase,
    int? currentSet,
    int? currentSecondsRemaining,
    int? totalPhaseSeconds,
    int? totalElapsedSeconds,
    bool? isRunning,
    bool? isPaused,
    String? message,
  }) {
    return IntervalTimerState(
      presets: presets ?? this.presets,
      selectedPreset: selectedPreset ?? this.selectedPreset,
      currentPhase: currentPhase ?? this.currentPhase,
      currentSet: currentSet ?? this.currentSet,
      currentSecondsRemaining: currentSecondsRemaining ?? this.currentSecondsRemaining,
      totalPhaseSeconds: totalPhaseSeconds ?? this.totalPhaseSeconds,
      totalElapsedSeconds: totalElapsedSeconds ?? this.totalElapsedSeconds,
      isRunning: isRunning ?? this.isRunning,
      isPaused: isPaused ?? this.isPaused,
      message: message,
    );
  }

  @override
  List<Object?> get props => [
        presets,
        selectedPreset,
        currentPhase,
        currentSet,
        currentSecondsRemaining,
        totalPhaseSeconds,
        totalElapsedSeconds,
        isRunning,
        isPaused,
        message,
      ];
}
