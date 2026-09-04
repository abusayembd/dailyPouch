import 'package:equatable/equatable.dart';
import '../../domain/entities/budget_envelope_entity.dart';

abstract class BudgetState extends Equatable {
  const BudgetState();

  @override
  List<Object?> get props => [];
}

class BudgetInitial extends BudgetState {
  const BudgetInitial();
}

class BudgetLoading extends BudgetState {
  const BudgetLoading();
}

class BudgetLoaded extends BudgetState {
  final List<BudgetEnvelopeEntity> envelopes;
  final BudgetEnvelopeEntity? selectedEnvelope;
  final List<ExpenseTransactionEntity> transactions;
  final String? message;

  const BudgetLoaded({
    required this.envelopes,
    this.selectedEnvelope,
    this.transactions = const [],
    this.message,
  });

  BudgetLoaded copyWith({
    List<BudgetEnvelopeEntity>? envelopes,
    BudgetEnvelopeEntity? selectedEnvelope,
    List<ExpenseTransactionEntity>? transactions,
    String? message,
  }) {
    return BudgetLoaded(
      envelopes: envelopes ?? this.envelopes,
      selectedEnvelope: selectedEnvelope ?? this.selectedEnvelope,
      transactions: transactions ?? this.transactions,
      message: message,
    );
  }

  @override
  List<Object?> get props => [
        envelopes,
        selectedEnvelope,
        transactions,
        message,
      ];
}

class BudgetError extends BudgetState {
  final String message;

  const BudgetError(this.message);

  @override
  List<Object?> get props => [message];
}
