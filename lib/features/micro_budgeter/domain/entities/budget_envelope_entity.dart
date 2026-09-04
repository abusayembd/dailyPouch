import 'package:equatable/equatable.dart';

class ExpenseTransactionEntity extends Equatable {
  final String id;
  final String envelopeId;
  final double amount;
  final String title;
  final DateTime timestamp;
  final String categoryTag;

  const ExpenseTransactionEntity({
    required this.id,
    required this.envelopeId,
    required this.amount,
    required this.title,
    required this.timestamp,
    this.categoryTag = 'General',
  });

  @override
  List<Object?> get props => [
        id,
        envelopeId,
        amount,
        title,
        timestamp,
        categoryTag,
      ];
}

class BudgetEnvelopeEntity extends Equatable {
  final String id;
  final String name;
  final double targetAmount;
  final double spentAmount;
  final DateTime startDate;
  final DateTime endDate;
  final String currency;
  final String category;
  final bool isArchived;

  const BudgetEnvelopeEntity({
    required this.id,
    required this.name,
    required this.targetAmount,
    this.spentAmount = 0.0,
    required this.startDate,
    required this.endDate,
    this.currency = '\$',
    this.category = 'Trip/Goal',
    this.isArchived = false,
  });

  /// Remaining budget allowance.
  double get remainingAmount => targetAmount - spentAmount;

  /// Progress ratio from 0.0 to 1.0+
  double get burnProgressPercentage {
    if (targetAmount <= 0) return 0.0;
    return (spentAmount / targetAmount).clamp(0.0, 2.0);
  }

  /// Total active days in the envelope timeline.
  int get totalDays {
    final diff = endDate.difference(startDate).inDays;
    return diff > 0 ? diff : 1;
  }

  /// Remaining days from today until end date.
  int get remainingDays {
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    final end = DateTime(endDate.year, endDate.month, endDate.day);
    final diff = end.difference(today).inDays;
    return diff >= 0 ? diff + 1 : 0;
  }

  /// Safe daily spending limit.
  double get dailyRunwayAllowance {
    if (remainingDays <= 0 || remainingAmount <= 0) return 0.0;
    return remainingAmount / remainingDays;
  }

  BudgetEnvelopeEntity copyWith({
    String? id,
    String? name,
    double? targetAmount,
    double? spentAmount,
    DateTime? startDate,
    DateTime? endDate,
    String? currency,
    String? category,
    bool? isArchived,
  }) {
    return BudgetEnvelopeEntity(
      id: id ?? this.id,
      name: name ?? this.name,
      targetAmount: targetAmount ?? this.targetAmount,
      spentAmount: spentAmount ?? this.spentAmount,
      startDate: startDate ?? this.startDate,
      endDate: endDate ?? this.endDate,
      currency: currency ?? this.currency,
      category: category ?? this.category,
      isArchived: isArchived ?? this.isArchived,
    );
  }

  @override
  List<Object?> get props => [
        id,
        name,
        targetAmount,
        spentAmount,
        startDate,
        endDate,
        currency,
        category,
        isArchived,
      ];
}
