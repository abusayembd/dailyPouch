import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../core/usecases/usecase.dart';
import '../../domain/usecases/add_transaction_usecase.dart';
import '../../domain/usecases/delete_envelope_usecase.dart';
import '../../domain/usecases/get_envelopes_usecase.dart';
import '../../domain/usecases/get_transactions_usecase.dart';
import '../../domain/usecases/save_envelope_usecase.dart';
import '../../domain/repositories/budget_repository.dart';
import 'budget_event.dart';
import 'budget_state.dart';

class BudgetBloc extends Bloc<BudgetEvent, BudgetState> {
  final GetEnvelopesUseCase getEnvelopes;
  final SaveEnvelopeUseCase saveEnvelope;
  final DeleteEnvelopeUseCase deleteEnvelope;
  final AddTransactionUseCase addTransaction;
  final GetTransactionsUseCase getTransactions;
  final BudgetRepository repository;

  BudgetBloc({
    required this.getEnvelopes,
    required this.saveEnvelope,
    required this.deleteEnvelope,
    required this.addTransaction,
    required this.getTransactions,
    required this.repository,
  }) : super(const BudgetInitial()) {
    on<LoadEnvelopesEvent>(_onLoadEnvelopes);
    on<SelectEnvelopeEvent>(_onSelectEnvelope);
    on<AddEnvelopeEvent>(_onAddEnvelope);
    on<UpdateEnvelopeEvent>(_onUpdateEnvelope);
    on<DeleteEnvelopeEvent>(_onDeleteEnvelope);
    on<AddTransactionEvent>(_onAddTransaction);
    on<DeleteTransactionEvent>(_onDeleteTransaction);
  }

  Future<void> _onLoadEnvelopes(
    LoadEnvelopesEvent event,
    Emitter<BudgetState> emit,
  ) async {
    emit(const BudgetLoading());
    final result = await getEnvelopes(const NoParams());
    await result.fold(
      (failure) async => emit(BudgetError(failure.message)),
      (envelopes) async {
        if (envelopes.isNotEmpty) {
          final first = envelopes.first;
          final txResult = await getTransactions(first.id);
          final txs = txResult.getOrElse((_) => []);
          emit(BudgetLoaded(
            envelopes: envelopes,
            selectedEnvelope: first,
            transactions: txs,
          ));
        } else {
          emit(const BudgetLoaded(envelopes: []));
        }
      },
    );
  }

  Future<void> _onSelectEnvelope(
    SelectEnvelopeEvent event,
    Emitter<BudgetState> emit,
  ) async {
    if (state is BudgetLoaded) {
      final current = state as BudgetLoaded;
      final selected = current.envelopes.firstWhere((e) => e.id == event.envelopeId);
      final txResult = await getTransactions(selected.id);
      final txs = txResult.getOrElse((_) => []);

      emit(current.copyWith(
        selectedEnvelope: selected,
        transactions: txs,
      ));
    }
  }

  Future<void> _onAddEnvelope(
    AddEnvelopeEvent event,
    Emitter<BudgetState> emit,
  ) async {
    final result = await saveEnvelope(event.envelope);
    await result.fold(
      (failure) async => emit(BudgetError(failure.message)),
      (_) async {
        final refreshed = await getEnvelopes(const NoParams());
        refreshed.fold(
          (failure) => emit(BudgetError(failure.message)),
          (list) => emit(BudgetLoaded(
            envelopes: list,
            selectedEnvelope: event.envelope,
            transactions: const [],
            message: 'Budget envelope created',
          )),
        );
      },
    );
  }

  Future<void> _onUpdateEnvelope(
    UpdateEnvelopeEvent event,
    Emitter<BudgetState> emit,
  ) async {
    final result = await saveEnvelope(event.envelope);
    await result.fold(
      (failure) async => emit(BudgetError(failure.message)),
      (_) async {
        final refreshed = await getEnvelopes(const NoParams());
        refreshed.fold(
          (failure) => emit(BudgetError(failure.message)),
          (list) => emit(BudgetLoaded(
            envelopes: list,
            selectedEnvelope: event.envelope,
            message: 'Budget envelope updated',
          )),
        );
      },
    );
  }

  Future<void> _onDeleteEnvelope(
    DeleteEnvelopeEvent event,
    Emitter<BudgetState> emit,
  ) async {
    final result = await deleteEnvelope(event.id);
    await result.fold(
      (failure) async => emit(BudgetError(failure.message)),
      (_) async {
        final refreshed = await getEnvelopes(const NoParams());
        refreshed.fold(
          (failure) => emit(BudgetError(failure.message)),
          (list) {
            final nextSelected = list.isNotEmpty ? list.first : null;
            emit(BudgetLoaded(
              envelopes: list,
              selectedEnvelope: nextSelected,
              message: 'Envelope removed',
            ));
          },
        );
      },
    );
  }

  Future<void> _onAddTransaction(
    AddTransactionEvent event,
    Emitter<BudgetState> emit,
  ) async {
    final result = await addTransaction(event.transaction);
    await result.fold(
      (failure) async => emit(BudgetError(failure.message)),
      (_) async {
        final envListResult = await getEnvelopes(const NoParams());
        final envelopes = envListResult.getOrElse((_) => []);
        final selected = envelopes.firstWhere(
          (e) => e.id == event.transaction.envelopeId,
          orElse: () => envelopes.first,
        );
        final txResult = await getTransactions(selected.id);
        final txs = txResult.getOrElse((_) => []);

        emit(BudgetLoaded(
          envelopes: envelopes,
          selectedEnvelope: selected,
          transactions: txs,
          message: 'Logged: ${event.transaction.title} (\$${event.transaction.amount.toStringAsFixed(2)})',
        ));
      },
    );
  }

  Future<void> _onDeleteTransaction(
    DeleteTransactionEvent event,
    Emitter<BudgetState> emit,
  ) async {
    final result = await repository.deleteTransaction(event.id, event.envelopeId);
    await result.fold(
      (failure) async => emit(BudgetError(failure.message)),
      (_) async {
        final envListResult = await getEnvelopes(const NoParams());
        final envelopes = envListResult.getOrElse((_) => []);
        final selected = envelopes.firstWhere(
          (e) => e.id == event.envelopeId,
          orElse: () => envelopes.first,
        );
        final txResult = await getTransactions(selected.id);
        final txs = txResult.getOrElse((_) => []);

        emit(BudgetLoaded(
          envelopes: envelopes,
          selectedEnvelope: selected,
          transactions: txs,
          message: 'Transaction deleted',
        ));
      },
    );
  }
}
