import 'package:flutter/material.dart';

/// Available spending and income categories in the Expense Tracker.
enum ExpenseCategory {
  // Expense Categories
  food,
  groceries,
  shopping,
  housing,
  transport,
  bills,
  health,
  entertainment,
  education,
  personal,
  otherExpense,

  // Income Categories
  salary,
  freelance,
  business,
  investment,
  gift,
  otherIncome;

  /// Whether this category is an income category.
  bool get isIncome {
    switch (this) {
      case ExpenseCategory.salary:
      case ExpenseCategory.freelance:
      case ExpenseCategory.business:
      case ExpenseCategory.investment:
      case ExpenseCategory.gift:
      case ExpenseCategory.otherIncome:
        return true;
      default:
        return false;
    }
  }

  /// Whether this category is an expense category.
  bool get isExpense => !isIncome;

  /// Default icon associated with the category.
  IconData get icon {
    switch (this) {
      case ExpenseCategory.food:
        return Icons.restaurant_rounded;
      case ExpenseCategory.groceries:
        return Icons.shopping_basket_rounded;
      case ExpenseCategory.shopping:
        return Icons.shopping_bag_rounded;
      case ExpenseCategory.housing:
        return Icons.home_rounded;
      case ExpenseCategory.transport:
        return Icons.directions_car_rounded;
      case ExpenseCategory.bills:
        return Icons.receipt_long_rounded;
      case ExpenseCategory.health:
        return Icons.local_hospital_rounded;
      case ExpenseCategory.entertainment:
        return Icons.movie_filter_rounded;
      case ExpenseCategory.education:
        return Icons.school_rounded;
      case ExpenseCategory.personal:
        return Icons.face_retouching_natural_rounded;
      case ExpenseCategory.otherExpense:
        return Icons.category_rounded;

      case ExpenseCategory.salary:
        return Icons.payments_rounded;
      case ExpenseCategory.freelance:
        return Icons.laptop_mac_rounded;
      case ExpenseCategory.business:
        return Icons.store_mall_directory_rounded;
      case ExpenseCategory.investment:
        return Icons.trending_up_rounded;
      case ExpenseCategory.gift:
        return Icons.card_giftcard_rounded;
      case ExpenseCategory.otherIncome:
        return Icons.account_balance_wallet_rounded;
    }
  }

  /// Accent color associated with the category.
  Color get color {
    switch (this) {
      case ExpenseCategory.food:
        return const Color(0xFFF97316); // Orange
      case ExpenseCategory.groceries:
        return const Color(0xFF84CC16); // Lime
      case ExpenseCategory.shopping:
        return const Color(0xFFEC4899); // Pink
      case ExpenseCategory.housing:
        return const Color(0xFF6366F1); // Indigo
      case ExpenseCategory.transport:
        return const Color(0xFF3B82F6); // Blue
      case ExpenseCategory.bills:
        return const Color(0xFFEF4444); // Red
      case ExpenseCategory.health:
        return const Color(0xFF14B8A6); // Teal
      case ExpenseCategory.entertainment:
        return const Color(0xFF8B5CF6); // Purple
      case ExpenseCategory.education:
        return const Color(0xFF06B6D4); // Cyan
      case ExpenseCategory.personal:
        return const Color(0xFFF43F5E); // Rose
      case ExpenseCategory.otherExpense:
        return const Color(0xFF64748B); // Slate

      case ExpenseCategory.salary:
        return const Color(0xFF10B981); // Emerald
      case ExpenseCategory.freelance:
        return const Color(0xFF059669); // Dark Emerald
      case ExpenseCategory.business:
        return const Color(0xFF0284C7); // Sky
      case ExpenseCategory.investment:
        return const Color(0xFFEAB308); // Yellow
      case ExpenseCategory.gift:
        return const Color(0xFFA855F7); // Violet
      case ExpenseCategory.otherIncome:
        return const Color(0xFF14B8A6); // Teal
    }
  }

  /// English fallback display name.
  String get displayName {
    switch (this) {
      case ExpenseCategory.food:
        return 'Food & Dining';
      case ExpenseCategory.groceries:
        return 'Groceries';
      case ExpenseCategory.shopping:
        return 'Shopping';
      case ExpenseCategory.housing:
        return 'Housing & Rent';
      case ExpenseCategory.transport:
        return 'Transport';
      case ExpenseCategory.bills:
        return 'Bills & Utilities';
      case ExpenseCategory.health:
        return 'Health & Medical';
      case ExpenseCategory.entertainment:
        return 'Entertainment';
      case ExpenseCategory.education:
        return 'Education';
      case ExpenseCategory.personal:
        return 'Personal Care';
      case ExpenseCategory.otherExpense:
        return 'Other Expense';

      case ExpenseCategory.salary:
        return 'Salary';
      case ExpenseCategory.freelance:
        return 'Freelance';
      case ExpenseCategory.business:
        return 'Business';
      case ExpenseCategory.investment:
        return 'Investment';
      case ExpenseCategory.gift:
        return 'Gifts & Awards';
      case ExpenseCategory.otherIncome:
        return 'Other Income';
    }
  }

  /// List of all expense categories.
  static List<ExpenseCategory> get expenseCategories =>
      ExpenseCategory.values.where((c) => c.isExpense).toList();

  /// List of all income categories.
  static List<ExpenseCategory> get incomeCategories =>
      ExpenseCategory.values.where((c) => c.isIncome).toList();
}
