import 'package:equatable/equatable.dart';

class IntervalPresetEntity extends Equatable {
  final String id;
  final String name;
  final int prepSeconds;
  final int workSeconds;
  final int restSeconds;
  final int totalSets;
  final int cooldownSeconds;

  const IntervalPresetEntity({
    required this.id,
    required this.name,
    this.prepSeconds = 5,
    required this.workSeconds,
    required this.restSeconds,
    required this.totalSets,
    this.cooldownSeconds = 0,
  });

  /// Total workout duration in seconds.
  int get totalDurationSeconds {
    return prepSeconds + ((workSeconds + restSeconds) * totalSets) + cooldownSeconds;
  }

  /// Formatted duration string (e.g. 4m 00s).
  String get formattedTotalDuration {
    final mins = totalDurationSeconds ~/ 60;
    final secs = totalDurationSeconds % 60;
    return '${mins}m ${secs.toString().padLeft(2, '0')}s';
  }

  static const List<IntervalPresetEntity> defaultPresets = [
    IntervalPresetEntity(
      id: 'tabata',
      name: 'Tabata Protocol',
      prepSeconds: 5,
      workSeconds: 20,
      restSeconds: 10,
      totalSets: 8,
      cooldownSeconds: 30,
    ),
    IntervalPresetEntity(
      id: 'hiit_cardio',
      name: 'HIIT Cardio Blast',
      prepSeconds: 10,
      workSeconds: 45,
      restSeconds: 15,
      totalSets: 10,
      cooldownSeconds: 60,
    ),
    IntervalPresetEntity(
      id: 'boxing_rounds',
      name: 'Boxing Sparring',
      prepSeconds: 10,
      workSeconds: 180,
      restSeconds: 60,
      totalSets: 5,
      cooldownSeconds: 60,
    ),
    IntervalPresetEntity(
      id: 'stretch_breath',
      name: 'Stretch & Rest',
      prepSeconds: 5,
      workSeconds: 60,
      restSeconds: 20,
      totalSets: 6,
      cooldownSeconds: 0,
    ),
  ];

  IntervalPresetEntity copyWith({
    String? id,
    String? name,
    int? prepSeconds,
    int? workSeconds,
    int? restSeconds,
    int? totalSets,
    int? cooldownSeconds,
  }) {
    return IntervalPresetEntity(
      id: id ?? this.id,
      name: name ?? this.name,
      prepSeconds: prepSeconds ?? this.prepSeconds,
      workSeconds: workSeconds ?? this.workSeconds,
      restSeconds: restSeconds ?? this.restSeconds,
      totalSets: totalSets ?? this.totalSets,
      cooldownSeconds: cooldownSeconds ?? this.cooldownSeconds,
    );
  }

  @override
  List<Object?> get props => [
        id,
        name,
        prepSeconds,
        workSeconds,
        restSeconds,
        totalSets,
        cooldownSeconds,
      ];
}
