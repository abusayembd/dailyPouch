import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../core/usecases/usecase.dart';
import '../../domain/usecases/delete_subscription_usecase.dart';
import '../../domain/usecases/get_subscriptions_usecase.dart';
import '../../domain/usecases/save_subscription_usecase.dart';
import '../../domain/repositories/subscription_repository.dart';
import 'subscription_event.dart';
import 'subscription_state.dart';

class SubscriptionBloc extends Bloc<SubscriptionEvent, SubscriptionState> {
  final GetSubscriptionsUseCase getSubscriptions;
  final SaveSubscriptionUseCase saveSubscription;
  final DeleteSubscriptionUseCase deleteSubscription;
  final SubscriptionRepository repository;

  SubscriptionBloc({
    required this.getSubscriptions,
    required this.saveSubscription,
    required this.deleteSubscription,
    required this.repository,
  }) : super(const SubscriptionInitial()) {
    on<LoadSubscriptionsEvent>(_onLoadSubscriptions);
    on<AddSubscriptionEvent>(_onAddSubscription);
    on<UpdateSubscriptionEvent>(_onUpdateSubscription);
    on<DeleteSubscriptionEvent>(_onDeleteSubscription);
    on<ToggleSubscriptionStatusEvent>(_onToggleStatus);
    on<ToggleSubscriptionPaidEvent>(_onTogglePaid);
  }

  Future<void> _onLoadSubscriptions(
    LoadSubscriptionsEvent event,
    Emitter<SubscriptionState> emit,
  ) async {
    emit(const SubscriptionLoading());
    final result = await getSubscriptions(const NoParams());
    result.fold(
      (failure) => emit(SubscriptionError(failure.message)),
      (subscriptions) => emit(SubscriptionLoaded.fromList(subscriptions)),
    );
  }

  Future<void> _onAddSubscription(
    AddSubscriptionEvent event,
    Emitter<SubscriptionState> emit,
  ) async {
    final result = await saveSubscription(event.subscription);
    await result.fold(
      (failure) async => emit(SubscriptionError(failure.message)),
      (_) async {
        final refreshed = await getSubscriptions(const NoParams());
        refreshed.fold(
          (failure) => emit(SubscriptionError(failure.message)),
          (list) => emit(SubscriptionLoaded.fromList(
            list,
            message: 'Subscription added successfully',
          )),
        );
      },
    );
  }

  Future<void> _onUpdateSubscription(
    UpdateSubscriptionEvent event,
    Emitter<SubscriptionState> emit,
  ) async {
    final result = await saveSubscription(event.subscription);
    await result.fold(
      (failure) async => emit(SubscriptionError(failure.message)),
      (_) async {
        final refreshed = await getSubscriptions(const NoParams());
        refreshed.fold(
          (failure) => emit(SubscriptionError(failure.message)),
          (list) => emit(SubscriptionLoaded.fromList(
            list,
            message: 'Subscription updated',
          )),
        );
      },
    );
  }

  Future<void> _onDeleteSubscription(
    DeleteSubscriptionEvent event,
    Emitter<SubscriptionState> emit,
  ) async {
    final result = await deleteSubscription(event.id);
    await result.fold(
      (failure) async => emit(SubscriptionError(failure.message)),
      (_) async {
        final refreshed = await getSubscriptions(const NoParams());
        refreshed.fold(
          (failure) => emit(SubscriptionError(failure.message)),
          (list) => emit(SubscriptionLoaded.fromList(
            list,
            message: 'Subscription removed',
          )),
        );
      },
    );
  }

  Future<void> _onToggleStatus(
    ToggleSubscriptionStatusEvent event,
    Emitter<SubscriptionState> emit,
  ) async {
    final result = await repository.toggleSubscriptionStatus(event.id);
    await result.fold(
      (failure) async => emit(SubscriptionError(failure.message)),
      (_) async {
        final refreshed = await getSubscriptions(const NoParams());
        refreshed.fold(
          (failure) => emit(SubscriptionError(failure.message)),
          (list) => emit(SubscriptionLoaded.fromList(list)),
        );
      },
    );
  }

  Future<void> _onTogglePaid(
    ToggleSubscriptionPaidEvent event,
    Emitter<SubscriptionState> emit,
  ) async {
    final currentState = state;
    if (currentState is SubscriptionLoaded) {
      final index = currentState.subscriptions.indexWhere((s) => s.id == event.id);
      if (index >= 0) {
        final sub = currentState.subscriptions[index];
        final updated = sub.copyWith(isPaid: !sub.isPaid);
        final result = await saveSubscription(updated);
        await result.fold(
          (failure) async => emit(SubscriptionError(failure.message)),
          (_) async {
            final refreshed = await getSubscriptions(const NoParams());
            refreshed.fold(
              (failure) => emit(SubscriptionError(failure.message)),
              (list) => emit(SubscriptionLoaded.fromList(list)),
            );
          },
        );
      }
    }
  }
}
