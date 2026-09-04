import '../../domain/entities/budget_envelope_entity.dart';

class BudgetEnvelopeModel {
  final String id;
  final String name;
  final double targetAmount;
  final double spentAmount;
  final String startDate;
  final String endDate;
  final String currency;
  final String category;
  final bool isArchived;

  const BudgetEnvelopeModel({
    required this.id,
    required this.name,
    required this.targetAmount,
    required this.spentAmount,
    required this.startDate,
    required this.endDate,
    required this.currency,
    required this.category,
    required this.isArchived,
  });

  factory BudgetEnvelopeModel.fromEntity(BudgetEnvelopeEntity entity) {
    return BudgetEnvelopeModel(
      id: entity.id,
      name: entity.name,
      targetAmount: entity.targetAmount,
      spentAmount: entity.spentAmount,
      startDate: entity.startDate.toIso8601String(),
      endDate: entity.endDate.toIso8601String(),
      currency: entity.currency,
      category: entity.category,
      isArchived: entity.isArchived,
    );
  }

  BudgetEnvelopeEntity toEntity() {
    return BudgetEnvelopeEntity(
      id: id,
      name: name,
      targetAmount: targetAmount,
      spentAmount: spentAmount,
      startDate: DateTime.tryParse(startDate) ?? DateTime.now(),
      endDate: DateTime.tryParse(endDate) ?? DateTime.now().add(const Duration(days: 7)),
      currency: currency,
      category: category,
      isArchived: isArchived,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'targetAmount': targetAmount,
      'spentAmount': spentAmount,
      'startDate': startDate,
      'endDate': endDate,
      'currency': currency,
      'category': category,
      'isArchived': isArchived,
    };
  }

  factory BudgetEnvelopeModel.fromJson(Map<String, dynamic> json) {
    return BudgetEnvelopeModel(
      id: json['id'] as String,
      name: json['name'] as String,
      targetAmount: (json['targetAmount'] as num).toDouble(),
      spentAmount: (json['spentAmount'] as num?)?.toDouble() ?? 0.0,
      startDate: json['startDate'] as String,
      endDate: json['endDate'] as String,
      currency: (json['currency'] as String?) ?? '\$',
      category: (json['category'] as String?) ?? 'Trip/Goal',
      isArchived: (json['isArchived'] as bool?) ?? false,
    );
  }
}
