import 'package:flutter_test/flutter_test.dart';
import 'package:dailypouch/features/expense_tracker/data/models/expense_transaction_model.dart';
import 'package:dailypouch/features/expense_tracker/domain/entities/expense_category.dart';
import 'package:dailypouch/features/expense_tracker/domain/entities/expense_transaction.dart';

void main() {
  group('ExpenseTransactionModel JSON Serialization', () {
    final testDate = DateTime(2026, 9, 5, 14, 30);
    final model = ExpenseTransactionModel(
      id: 'tx-101',
      title: 'Whole Foods Market',
      amount: 85.50,
      type: TransactionType.expense,
      category: ExpenseCategory.groceries,
      date: testDate,
      paymentMethod: PaymentMethod.creditCard,
      notes: 'Weekly fresh vegetables restock',
    );

    test('toJson serializes all fields properly', () {
      final json = model.toJson();

      expect(json['id'], equals('tx-101'));
      expect(json['title'], equals('Whole Foods Market'));
      expect(json['amount'], equals(85.50));
      expect(json['type'], equals('expense'));
      expect(json['category'], equals('groceries'));
      expect(json['date'], equals(testDate.toIso8601String()));
      expect(json['paymentMethod'], equals('creditCard'));
      expect(json['notes'], equals('Weekly fresh vegetables restock'));
    });

    test('fromJson deserializes JSON map accurately into model', () {
      final json = {
        'id': 'tx-102',
        'title': 'Client Payment',
        'amount': 2400.0,
        'type': 'income',
        'category': 'business',
        'date': testDate.toIso8601String(),
        'paymentMethod': 'bankTransfer',
        'notes': 'Invoice #402 paid',
      };

      final parsed = ExpenseTransactionModel.fromJson(json);

      expect(parsed.id, equals('tx-102'));
      expect(parsed.title, equals('Client Payment'));
      expect(parsed.amount, equals(2400.0));
      expect(parsed.type, equals(TransactionType.income));
      expect(parsed.category, equals(ExpenseCategory.business));
      expect(parsed.date, equals(testDate));
      expect(parsed.paymentMethod, equals(PaymentMethod.bankTransfer));
      expect(parsed.notes, equals('Invoice #402 paid'));
      expect(parsed.isIncome, isTrue);
    });

    test('fromEntity and toEntity map interchangeably without data loss', () {
      final entity = ExpenseTransaction(
        id: 'tx-103',
        title: 'Uber Ride',
        amount: 24.50,
        type: TransactionType.expense,
        category: ExpenseCategory.transport,
        date: DateTime(2026, 9, 5),
        paymentMethod: PaymentMethod.mobileWallet,
      );

      final convertedModel = ExpenseTransactionModel.fromEntity(entity);
      expect(convertedModel.id, equals(entity.id));
      expect(convertedModel.title, equals(entity.title));
      expect(convertedModel.amount, equals(entity.amount));
      expect(convertedModel.paymentMethod, equals(PaymentMethod.mobileWallet));
    });
  });
}
