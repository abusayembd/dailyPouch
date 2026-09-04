import 'package:equatable/equatable.dart';

enum BillingCycle {
  weekly,
  monthly,
  yearly,
}

enum SubscriptionCategory {
  entertainment,
  utilities,
  software,
  health,
  work,
  other,
}

class SubscriptionEntity extends Equatable {
  final String id;
  final String name;
  final double amount;
  final String currency;
  final BillingCycle billingCycle;
  final DateTime nextBillingDate;
  final SubscriptionCategory category;
  final int remindDaysBefore;
  final bool isActive;
  final bool isPaid;
  final String? notes;

  const SubscriptionEntity({
    required this.id,
    required this.name,
    required this.amount,
    this.currency = '\$',
    required this.billingCycle,
    required this.nextBillingDate,
    required this.category,
    this.remindDaysBefore = 3,
    this.isActive = true,
    this.isPaid = false,
    this.notes,
  });

  /// Calculates the normalized monthly cost.
  double get monthlyEquivalent {
    if (!isActive) return 0.0;
    switch (billingCycle) {
      case BillingCycle.weekly:
        return (amount * 52) / 12;
      case BillingCycle.monthly:
        return amount;
      case BillingCycle.yearly:
        return amount / 12;
    }
  }

  /// Calculates the normalized yearly cost.
  double get yearlyEquivalent {
    if (!isActive) return 0.0;
    switch (billingCycle) {
      case BillingCycle.weekly:
        return amount * 52;
      case BillingCycle.monthly:
        return amount * 12;
      case BillingCycle.yearly:
        return amount;
    }
  }

  /// Calculates days remaining until the next billing date.
  int get daysUntilNextBilling {
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    final billingDay = DateTime(
      nextBillingDate.year,
      nextBillingDate.month,
      nextBillingDate.day,
    );
    return billingDay.difference(today).inDays;
  }

  SubscriptionEntity copyWith({
    String? id,
    String? name,
    double? amount,
    String? currency,
    BillingCycle? billingCycle,
    DateTime? nextBillingDate,
    SubscriptionCategory? category,
    int? remindDaysBefore,
    bool? isActive,
    bool? isPaid,
    String? notes,
  }) {
    return SubscriptionEntity(
      id: id ?? this.id,
      name: name ?? this.name,
      amount: amount ?? this.amount,
      currency: currency ?? this.currency,
      billingCycle: billingCycle ?? this.billingCycle,
      nextBillingDate: nextBillingDate ?? this.nextBillingDate,
      category: category ?? this.category,
      remindDaysBefore: remindDaysBefore ?? this.remindDaysBefore,
      isActive: isActive ?? this.isActive,
      isPaid: isPaid ?? this.isPaid,
      notes: notes ?? this.notes,
    );
  }

  @override
  List<Object?> get props => [
        id,
        name,
        amount,
        currency,
        billingCycle,
        nextBillingDate,
        category,
        remindDaysBefore,
        isActive,
        isPaid,
        notes,
      ];
}
