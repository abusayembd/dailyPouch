import '../../domain/entities/expense_category.dart';
import '../../domain/entities/expense_transaction.dart';

/// Data transfer model for ExpenseTransaction with JSON serialization.
class ExpenseTransactionModel extends ExpenseTransaction {
  const ExpenseTransactionModel({
    required super.id,
    required super.title,
    required super.amount,
    required super.type,
    required super.category,
    required super.date,
    super.paymentMethod = PaymentMethod.cash,
    super.notes,
  });

  factory ExpenseTransactionModel.fromJson(Map<String, dynamic> json) {
    return ExpenseTransactionModel(
      id: json['id'] as String,
      title: json['title'] as String,
      amount: (json['amount'] as num).toDouble(),
      type: TransactionType.values.firstWhere(
        (e) => e.name == json['type'],
        orElse: () => TransactionType.expense,
      ),
      category: ExpenseCategory.values.firstWhere(
        (e) => e.name == json['category'],
        orElse: () => ExpenseCategory.otherExpense,
      ),
      date: DateTime.parse(json['date'] as String),
      paymentMethod: PaymentMethod.values.firstWhere(
        (e) => e.name == json['paymentMethod'],
        orElse: () => PaymentMethod.cash,
      ),
      notes: json['notes'] as String?,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'amount': amount,
      'type': type.name,
      'category': category.name,
      'date': date.toIso8601String(),
      'paymentMethod': paymentMethod.name,
      if (notes != null) 'notes': notes,
    };
  }

  factory ExpenseTransactionModel.fromEntity(ExpenseTransaction entity) {
    return ExpenseTransactionModel(
      id: entity.id,
      title: entity.title,
      amount: entity.amount,
      type: entity.type,
      category: entity.category,
      date: entity.date,
      paymentMethod: entity.paymentMethod,
      notes: entity.notes,
    );
  }
}
