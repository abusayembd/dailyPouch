import 'package:equatable/equatable.dart';
import '../../domain/entities/subscription_entity.dart';

abstract class SubscriptionState extends Equatable {
  const SubscriptionState();

  @override
  List<Object?> get props => [];
}

class SubscriptionInitial extends SubscriptionState {
  const SubscriptionInitial();
}

class SubscriptionLoading extends SubscriptionState {
  const SubscriptionLoading();
}

class SubscriptionLoaded extends SubscriptionState {
  final List<SubscriptionEntity> subscriptions;
  final double totalMonthlyBurn;
  final double totalYearlyBurn;
  final int activeCount;
  final String? message;

  const SubscriptionLoaded({
    required this.subscriptions,
    required this.totalMonthlyBurn,
    required this.totalYearlyBurn,
    required this.activeCount,
    this.message,
  });

  factory SubscriptionLoaded.fromList(
    List<SubscriptionEntity> list, {
    String? message,
  }) {
    double monthly = 0;
    double yearly = 0;
    int active = 0;

    for (final s in list) {
      if (s.isActive) {
        monthly += s.monthlyEquivalent;
        yearly += s.yearlyEquivalent;
        active++;
      }
    }

    return SubscriptionLoaded(
      subscriptions: list,
      totalMonthlyBurn: monthly,
      totalYearlyBurn: yearly,
      activeCount: active,
      message: message,
    );
  }

  @override
  List<Object?> get props => [
        subscriptions,
        totalMonthlyBurn,
        totalYearlyBurn,
        activeCount,
        message,
      ];
}

class SubscriptionError extends SubscriptionState {
  final String message;

  const SubscriptionError(this.message);

  @override
  List<Object?> get props => [message];
}
