import 'package:flutter_test/flutter_test.dart';
import 'package:dailypouch/features/expense_tracker/domain/entities/expense_category.dart';
import 'package:dailypouch/features/expense_tracker/domain/entities/expense_transaction.dart';

void main() {
  group('ExpenseCategory Enum & Properties', () {
    test('verifies income vs expense category flags', () {
      expect(ExpenseCategory.food.isExpense, isTrue);
      expect(ExpenseCategory.groceries.isExpense, isTrue);
      expect(ExpenseCategory.shopping.isExpense, isTrue);
      expect(ExpenseCategory.salary.isIncome, isTrue);
      expect(ExpenseCategory.freelance.isIncome, isTrue);
      expect(ExpenseCategory.business.isIncome, isTrue);
      expect(ExpenseCategory.investment.isIncome, isTrue);
    });

    test('expenseCategories and incomeCategories helper getters return valid partitions', () {
      final expenses = ExpenseCategory.expenseCategories;
      final incomes = ExpenseCategory.incomeCategories;

      expect(expenses.every((c) => c.isExpense), isTrue);
      expect(incomes.every((c) => c.isIncome), isTrue);
      expect(expenses.length + incomes.length, equals(ExpenseCategory.values.length));
    });

    test('all categories have non-null icons, colors, and display names', () {
      for (final cat in ExpenseCategory.values) {
        expect(cat.icon, isNotNull);
        expect(cat.color, isNotNull);
        expect(cat.displayName.isNotEmpty, isTrue);
      }
    });
  });

  group('FinancialSummary Calculations', () {
    test('returns zeroed empty summary when no transactions provided', () {
      final summary = FinancialSummary.empty();

      expect(summary.totalIncome, equals(0.0));
      expect(summary.totalExpense, equals(0.0));
      expect(summary.netCashFlow, equals(0.0));
      expect(summary.savingsRate, equals(0.0));
      expect(summary.transactionCount, equals(0));
      expect(summary.categorySpending.isEmpty, isTrue);
    });

    test('correctly calculates net cash flow, savings rate, and category breakdowns', () {
      final transactions = [
        ExpenseTransaction(
          id: '1',
          title: 'Monthly Salary',
          amount: 5000.0,
          type: TransactionType.income,
          category: ExpenseCategory.salary,
          date: DateTime(2026, 9, 1),
        ),
        ExpenseTransaction(
          id: '2',
          title: 'Freelance Project',
          amount: 1000.0,
          type: TransactionType.income,
          category: ExpenseCategory.freelance,
          date: DateTime(2026, 9, 2),
        ),
        ExpenseTransaction(
          id: '3',
          title: 'Apartment Rent',
          amount: 1500.0,
          type: TransactionType.expense,
          category: ExpenseCategory.housing,
          date: DateTime(2026, 9, 3),
        ),
        ExpenseTransaction(
          id: '4',
          title: 'Supermarket Grocery Restock',
          amount: 500.0,
          type: TransactionType.expense,
          category: ExpenseCategory.groceries,
          date: DateTime(2026, 9, 4),
        ),
        ExpenseTransaction(
          id: '5',
          title: 'Dinner at Italian Bistro',
          amount: 100.0,
          type: TransactionType.expense,
          category: ExpenseCategory.food,
          date: DateTime(2026, 9, 4),
        ),
      ];

      final summary = FinancialSummary.fromTransactions(transactions);

      // Total Income: 5000 + 1000 = 6000
      expect(summary.totalIncome, equals(6000.0));

      // Total Expense: 1500 + 500 + 100 = 2100
      expect(summary.totalExpense, equals(2100.0));

      // Net Cash Flow: 6000 - 2100 = 3900
      expect(summary.netCashFlow, equals(3900.0));

      // Savings Rate: (3900 / 6000) * 100 = 65%
      expect(summary.savingsRate, equals(65.0));

      expect(summary.transactionCount, equals(5));

      // Category spending breakdown checks
      expect(summary.categorySpending[ExpenseCategory.housing], equals(1500.0));
      expect(summary.categorySpending[ExpenseCategory.groceries], equals(500.0));
      expect(summary.categorySpending[ExpenseCategory.food], equals(100.0));
      expect(summary.categorySpending[ExpenseCategory.shopping], isNull);
    });

    test('handles deficit where expenses exceed income', () {
      final transactions = [
        ExpenseTransaction(
          id: '1',
          title: 'Side Gig',
          amount: 500.0,
          type: TransactionType.income,
          category: ExpenseCategory.freelance,
          date: DateTime.now(),
        ),
        ExpenseTransaction(
          id: '2',
          title: 'Emergency Vet Bill',
          amount: 1200.0,
          type: TransactionType.expense,
          category: ExpenseCategory.health,
          date: DateTime.now(),
        ),
      ];

      final summary = FinancialSummary.fromTransactions(transactions);

      expect(summary.totalIncome, equals(500.0));
      expect(summary.totalExpense, equals(1200.0));
      expect(summary.netCashFlow, equals(-700.0));
      expect(summary.savingsRate, equals(0.0)); // Clamped to 0%
    });
  });
}
