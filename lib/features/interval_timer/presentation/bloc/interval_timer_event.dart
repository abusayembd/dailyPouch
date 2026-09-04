import 'package:equatable/equatable.dart';
import '../../domain/entities/interval_preset_entity.dart';

abstract class IntervalTimerEvent extends Equatable {
  const IntervalTimerEvent();

  @override
  List<Object?> get props => [];
}

class LoadPresetsEvent extends IntervalTimerEvent {
  const LoadPresetsEvent();
}

class SelectPresetTimerEvent extends IntervalTimerEvent {
  final IntervalPresetEntity preset;

  const SelectPresetTimerEvent(this.preset);

  @override
  List<Object?> get props => [preset];
}

class StartTimerEvent extends IntervalTimerEvent {
  const StartTimerEvent();
}

class PauseTimerEvent extends IntervalTimerEvent {
  const PauseTimerEvent();
}

class ResumeTimerEvent extends IntervalTimerEvent {
  const ResumeTimerEvent();
}

class ResetTimerEvent extends IntervalTimerEvent {
  const ResetTimerEvent();
}

class SkipIntervalEvent extends IntervalTimerEvent {
  const SkipIntervalEvent();
}

class TimerTickEvent extends IntervalTimerEvent {
  const TimerTickEvent();
}

class SaveCustomPresetEvent extends IntervalTimerEvent {
  final IntervalPresetEntity preset;

  const SaveCustomPresetEvent(this.preset);

  @override
  List<Object?> get props => [preset];
}
