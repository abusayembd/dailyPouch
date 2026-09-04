import '../../domain/entities/budget_envelope_entity.dart';

class ExpenseTransactionModel {
  final String id;
  final String envelopeId;
  final double amount;
  final String title;
  final String timestamp;
  final String categoryTag;

  const ExpenseTransactionModel({
    required this.id,
    required this.envelopeId,
    required this.amount,
    required this.title,
    required this.timestamp,
    required this.categoryTag,
  });

  factory ExpenseTransactionModel.fromEntity(ExpenseTransactionEntity entity) {
    return ExpenseTransactionModel(
      id: entity.id,
      envelopeId: entity.envelopeId,
      amount: entity.amount,
      title: entity.title,
      timestamp: entity.timestamp.toIso8601String(),
      categoryTag: entity.categoryTag,
    );
  }

  ExpenseTransactionEntity toEntity() {
    return ExpenseTransactionEntity(
      id: id,
      envelopeId: envelopeId,
      amount: amount,
      title: title,
      timestamp: DateTime.tryParse(timestamp) ?? DateTime.now(),
      categoryTag: categoryTag,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'envelopeId': envelopeId,
      'amount': amount,
      'title': title,
      'timestamp': timestamp,
      'categoryTag': categoryTag,
    };
  }

  factory ExpenseTransactionModel.fromJson(Map<String, dynamic> json) {
    return ExpenseTransactionModel(
      id: json['id'] as String,
      envelopeId: json['envelopeId'] as String,
      amount: (json['amount'] as num).toDouble(),
      title: json['title'] as String,
      timestamp: json['timestamp'] as String,
      categoryTag: (json['categoryTag'] as String?) ?? 'General',
    );
  }
}
