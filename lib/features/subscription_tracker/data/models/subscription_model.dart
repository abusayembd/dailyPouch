import '../../domain/entities/subscription_entity.dart';

class SubscriptionModel {
  final String id;
  final String name;
  final double amount;
  final String currency;
  final String billingCycle;
  final String nextBillingDate;
  final String category;
  final int remindDaysBefore;
  final bool isActive;
  final bool isPaid;
  final String? notes;

  const SubscriptionModel({
    required this.id,
    required this.name,
    required this.amount,
    required this.currency,
    required this.billingCycle,
    required this.nextBillingDate,
    required this.category,
    required this.remindDaysBefore,
    required this.isActive,
    this.isPaid = false,
    this.notes,
  });

  factory SubscriptionModel.fromEntity(SubscriptionEntity entity) {
    return SubscriptionModel(
      id: entity.id,
      name: entity.name,
      amount: entity.amount,
      currency: entity.currency,
      billingCycle: entity.billingCycle.name,
      nextBillingDate: entity.nextBillingDate.toIso8601String(),
      category: entity.category.name,
      remindDaysBefore: entity.remindDaysBefore,
      isActive: entity.isActive,
      isPaid: entity.isPaid,
      notes: entity.notes,
    );
  }

  SubscriptionEntity toEntity() {
    return SubscriptionEntity(
      id: id,
      name: name,
      amount: amount,
      currency: currency,
      billingCycle: BillingCycle.values.firstWhere(
        (e) => e.name == billingCycle,
        orElse: () => BillingCycle.monthly,
      ),
      nextBillingDate: DateTime.tryParse(nextBillingDate) ?? DateTime.now(),
      category: SubscriptionCategory.values.firstWhere(
        (e) => e.name == category,
        orElse: () => SubscriptionCategory.other,
      ),
      remindDaysBefore: remindDaysBefore,
      isActive: isActive,
      isPaid: isPaid,
      notes: notes,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'amount': amount,
      'currency': currency,
      'billingCycle': billingCycle,
      'nextBillingDate': nextBillingDate,
      'category': category,
      'remindDaysBefore': remindDaysBefore,
      'isActive': isActive,
      'isPaid': isPaid,
      'notes': notes,
    };
  }

  factory SubscriptionModel.fromJson(Map<String, dynamic> json) {
    return SubscriptionModel(
      id: json['id'] as String,
      name: json['name'] as String,
      amount: (json['amount'] as num).toDouble(),
      currency: (json['currency'] as String?) ?? '\$',
      billingCycle: (json['billingCycle'] as String?) ?? 'monthly',
      nextBillingDate: json['nextBillingDate'] as String,
      category: (json['category'] as String?) ?? 'other',
      remindDaysBefore: (json['remindDaysBefore'] as int?) ?? 3,
      isActive: (json['isActive'] as bool?) ?? true,
      isPaid: (json['isPaid'] as bool?) ?? false,
      notes: json['notes'] as String?,
    );
  }
}
