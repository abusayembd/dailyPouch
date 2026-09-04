import '../../domain/entities/interval_preset_entity.dart';

class IntervalPresetModel {
  final String id;
  final String name;
  final int prepSeconds;
  final int workSeconds;
  final int restSeconds;
  final int totalSets;
  final int cooldownSeconds;

  const IntervalPresetModel({
    required this.id,
    required this.name,
    required this.prepSeconds,
    required this.workSeconds,
    required this.restSeconds,
    required this.totalSets,
    required this.cooldownSeconds,
  });

  factory IntervalPresetModel.fromEntity(IntervalPresetEntity entity) {
    return IntervalPresetModel(
      id: entity.id,
      name: entity.name,
      prepSeconds: entity.prepSeconds,
      workSeconds: entity.workSeconds,
      restSeconds: entity.restSeconds,
      totalSets: entity.totalSets,
      cooldownSeconds: entity.cooldownSeconds,
    );
  }

  IntervalPresetEntity toEntity() {
    return IntervalPresetEntity(
      id: id,
      name: name,
      prepSeconds: prepSeconds,
      workSeconds: workSeconds,
      restSeconds: restSeconds,
      totalSets: totalSets,
      cooldownSeconds: cooldownSeconds,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'prepSeconds': prepSeconds,
      'workSeconds': workSeconds,
      'restSeconds': restSeconds,
      'totalSets': totalSets,
      'cooldownSeconds': cooldownSeconds,
    };
  }

  factory IntervalPresetModel.fromJson(Map<String, dynamic> json) {
    return IntervalPresetModel(
      id: json['id'] as String,
      name: json['name'] as String,
      prepSeconds: (json['prepSeconds'] as int?) ?? 5,
      workSeconds: (json['workSeconds'] as int?) ?? 30,
      restSeconds: (json['restSeconds'] as int?) ?? 15,
      totalSets: (json['totalSets'] as int?) ?? 8,
      cooldownSeconds: (json['cooldownSeconds'] as int?) ?? 0,
    );
  }
}
