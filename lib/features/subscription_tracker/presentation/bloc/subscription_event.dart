import 'package:equatable/equatable.dart';
import '../../domain/entities/subscription_entity.dart';

abstract class SubscriptionEvent extends Equatable {
  const SubscriptionEvent();

  @override
  List<Object?> get props => [];
}

class LoadSubscriptionsEvent extends SubscriptionEvent {
  const LoadSubscriptionsEvent();
}

class AddSubscriptionEvent extends SubscriptionEvent {
  final SubscriptionEntity subscription;

  const AddSubscriptionEvent(this.subscription);

  @override
  List<Object?> get props => [subscription];
}

class UpdateSubscriptionEvent extends SubscriptionEvent {
  final SubscriptionEntity subscription;

  const UpdateSubscriptionEvent(this.subscription);

  @override
  List<Object?> get props => [subscription];
}

class DeleteSubscriptionEvent extends SubscriptionEvent {
  final String id;

  const DeleteSubscriptionEvent(this.id);

  @override
  List<Object?> get props => [id];
}

class ToggleSubscriptionStatusEvent extends SubscriptionEvent {
  final String id;

  const ToggleSubscriptionStatusEvent(this.id);

  @override
  List<Object?> get props => [id];
}

class ToggleSubscriptionPaidEvent extends SubscriptionEvent {
  final String id;

  const ToggleSubscriptionPaidEvent(this.id);

  @override
  List<Object?> get props => [id];
}
