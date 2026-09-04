import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'expense_category.dart';

/// Type of financial transaction.
enum TransactionType {
  expense,
  income,
}

/// Payment method used for transaction.
enum PaymentMethod {
  cash,
  creditCard,
  debitCard,
  bankTransfer,
  mobileWallet,
  other;

  IconData get icon {
    switch (this) {
      case PaymentMethod.cash:
        return Icons.money_rounded;
      case PaymentMethod.creditCard:
        return Icons.credit_card_rounded;
      case PaymentMethod.debitCard:
        return Icons.credit_card_outlined;
      case PaymentMethod.bankTransfer:
        return Icons.account_balance_rounded;
      case PaymentMethod.mobileWallet:
        return Icons.phone_android_rounded;
      case PaymentMethod.other:
        return Icons.more_horiz_rounded;
    }
  }

  String get displayName {
    switch (this) {
      case PaymentMethod.cash:
        return 'Cash';
      case PaymentMethod.creditCard:
        return 'Credit Card';
      case PaymentMethod.debitCard:
        return 'Debit Card';
      case PaymentMethod.bankTransfer:
        return 'Bank Transfer';
      case PaymentMethod.mobileWallet:
        return 'Mobile Wallet';
      case PaymentMethod.other:
        return 'Other';
    }
  }
}

/// Filter options for time periods in the Expense Tracker.
enum TimePeriodFilter {
  today,
  thisWeek,
  thisMonth,
  allTime;

  String get displayName {
    switch (this) {
      case TimePeriodFilter.today:
        return 'Today';
      case TimePeriodFilter.thisWeek:
        return 'This Week';
      case TimePeriodFilter.thisMonth:
        return 'This Month';
      case TimePeriodFilter.allTime:
        return 'All Time';
    }
  }
}

/// Core domain entity representing an individual income or expense record.
class ExpenseTransaction extends Equatable {
  final String id;
  final String title;
  final double amount;
  final TransactionType type;
  final ExpenseCategory category;
  final DateTime date;
  final PaymentMethod paymentMethod;
  final String? notes;

  const ExpenseTransaction({
    required this.id,
    required this.title,
    required this.amount,
    required this.type,
    required this.category,
    required this.date,
    this.paymentMethod = PaymentMethod.cash,
    this.notes,
  });

  bool get isExpense => type == TransactionType.expense;
  bool get isIncome => type == TransactionType.income;

  ExpenseTransaction copyWith({
    String? id,
    String? title,
    double? amount,
    TransactionType? type,
    ExpenseCategory? category,
    DateTime? date,
    PaymentMethod? paymentMethod,
    String? notes,
  }) {
    return ExpenseTransaction(
      id: id ?? this.id,
      title: title ?? this.title,
      amount: amount ?? this.amount,
      type: type ?? this.type,
      category: category ?? this.category,
      date: date ?? this.date,
      paymentMethod: paymentMethod ?? this.paymentMethod,
      notes: notes ?? this.notes,
    );
  }

  @override
  List<Object?> get props => [
        id,
        title,
        amount,
        type,
        category,
        date,
        paymentMethod,
        notes,
      ];
}

/// Financial summary computed over a set of transactions.
class FinancialSummary extends Equatable {
  final double totalIncome;
  final double totalExpense;
  final double netCashFlow;
  final double savingsRate;
  final int transactionCount;
  final Map<ExpenseCategory, double> categorySpending;
  final Map<ExpenseCategory, double> categoryIncome;

  const FinancialSummary({
    required this.totalIncome,
    required this.totalExpense,
    required this.netCashFlow,
    required this.savingsRate,
    required this.transactionCount,
    required this.categorySpending,
    required this.categoryIncome,
  });

  factory FinancialSummary.empty() {
    return const FinancialSummary(
      totalIncome: 0.0,
      totalExpense: 0.0,
      netCashFlow: 0.0,
      savingsRate: 0.0,
      transactionCount: 0,
      categorySpending: {},
      categoryIncome: {},
    );
  }

  factory FinancialSummary.fromTransactions(List<ExpenseTransaction> transactions) {
    double income = 0.0;
    double expense = 0.0;
    final spendingMap = <ExpenseCategory, double>{};
    final incomeMap = <ExpenseCategory, double>{};

    for (final t in transactions) {
      if (t.isIncome) {
        income += t.amount;
        incomeMap[t.category] = (incomeMap[t.category] ?? 0.0) + t.amount;
      } else {
        expense += t.amount;
        spendingMap[t.category] = (spendingMap[t.category] ?? 0.0) + t.amount;
      }
    }

    final net = income - expense;
    final savings = income > 0 ? ((income - expense) / income * 100.0).clamp(0.0, 100.0) : 0.0;

    return FinancialSummary(
      totalIncome: income,
      totalExpense: expense,
      netCashFlow: net,
      savingsRate: savings,
      transactionCount: transactions.length,
      categorySpending: spendingMap,
      categoryIncome: incomeMap,
    );
  }

  @override
  List<Object?> get props => [
        totalIncome,
        totalExpense,
        netCashFlow,
        savingsRate,
        transactionCount,
        categorySpending,
        categoryIncome,
      ];
}
