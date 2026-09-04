import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import '../../../../core/theme/app_colors.dart';

enum ModuleCategory {
  all,
  finance,
  kitchen,
  media,
  fitness,
}

class UtilityModule extends Equatable {
  final String id;
  final String title;
  final String shortTitle;
  final String description;
  final IconData icon;
  final Color accentColor;
  final LinearGradient gradient;
  final ModuleCategory category;
  final int phase;
  final String badgeText;

  const UtilityModule({
    required this.id,
    required this.title,
    required this.shortTitle,
    required this.description,
    required this.icon,
    required this.accentColor,
    required this.gradient,
    required this.category,
    required this.phase,
    required this.badgeText,
  });

  @override
  List<Object?> get props => [
        id,
        title,
        shortTitle,
        description,
        icon,
        accentColor,
        gradient,
        category,
        phase,
        badgeText,
      ];

  /// Standard list of all 6 utility modules in the hub.
  static const List<UtilityModule> defaultModules = [
    UtilityModule(
      id: 'subscription_tracker',
      title: 'Subscription Tracker',
      shortTitle: 'Subscriptions',
      description: 'Track recurring expenses, burn rate & renewal alerts',
      icon: Icons.auto_awesome_motion_rounded,
      accentColor: AppColors.moduleSubscription,
      gradient: AppColors.subscriptionGradient,
      category: ModuleCategory.finance,
      phase: 1,
      badgeText: 'FINANCE',
    ),
    UtilityModule(
      id: 'price_calculator',
      title: 'Smart Price Compare',
      shortTitle: 'Price Compare',
      description: 'Side-by-side grocery unit comparison & best deal finder',
      icon: Icons.calculate_rounded,
      accentColor: AppColors.modulePriceCalc,
      gradient: AppColors.priceCalcGradient,
      category: ModuleCategory.finance,
      phase: 2,
      badgeText: 'GROCERY',
    ),
    UtilityModule(
      id: 'pantry_expiry',
      title: 'Pantry & Medicine',
      shortTitle: 'Pantry Expiry',
      description: 'Barcode scanning, zone tracking & spoilage warnings',
      icon: Icons.inventory_2_rounded,
      accentColor: AppColors.modulePantry,
      gradient: AppColors.pantryGradient,
      category: ModuleCategory.kitchen,
      phase: 3,
      badgeText: 'PANTRY',
    ),
    UtilityModule(
      id: 'expense_tracker',
      title: 'Daily Expense Tracker',
      shortTitle: 'Expense Tracker',
      description: 'All-in-one money manager to track spending & savings rate',
      icon: Icons.account_balance_wallet_rounded,
      accentColor: AppColors.moduleExpenseTracker,
      gradient: AppColors.expenseTrackerGradient,
      category: ModuleCategory.finance,
      phase: 4,
      badgeText: 'MONEY',
    ),
    UtilityModule(
      id: 'micro_budgeter',
      title: 'Single-Goal Budgeter',
      shortTitle: 'Micro Budget',
      description: 'Isolated budget envelopes, runway gauge & quick log',
      icon: Icons.account_balance_wallet_rounded,
      accentColor: AppColors.moduleBudgeter,
      gradient: AppColors.budgeterGradient,
      category: ModuleCategory.finance,
      phase: 5,
      badgeText: 'BUDGET',
    ),
    UtilityModule(
      id: 'interval_timer',
      title: 'Interval & Rest Timer',
      shortTitle: 'HIIT Timer',
      description: 'Custom workout intervals, wakelock & audio chimes',
      icon: Icons.timer_rounded,
      accentColor: AppColors.moduleTimer,
      gradient: AppColors.timerGradient,
      category: ModuleCategory.fitness,
      phase: 6,
      badgeText: 'FITNESS',
    ),
  ];
}
