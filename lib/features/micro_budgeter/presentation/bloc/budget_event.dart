import 'package:equatable/equatable.dart';
import '../../domain/entities/budget_envelope_entity.dart';

abstract class BudgetEvent extends Equatable {
  const BudgetEvent();

  @override
  List<Object?> get props => [];
}

class LoadEnvelopesEvent extends BudgetEvent {
  const LoadEnvelopesEvent();
}

class SelectEnvelopeEvent extends BudgetEvent {
  final String envelopeId;

  const SelectEnvelopeEvent(this.envelopeId);

  @override
  List<Object?> get props => [envelopeId];
}

class AddEnvelopeEvent extends BudgetEvent {
  final BudgetEnvelopeEntity envelope;

  const AddEnvelopeEvent(this.envelope);

  @override
  List<Object?> get props => [envelope];
}

class UpdateEnvelopeEvent extends BudgetEvent {
  final BudgetEnvelopeEntity envelope;

  const UpdateEnvelopeEvent(this.envelope);

  @override
  List<Object?> get props => [envelope];
}

class DeleteEnvelopeEvent extends BudgetEvent {
  final String id;

  const DeleteEnvelopeEvent(this.id);

  @override
  List<Object?> get props => [id];
}

class AddTransactionEvent extends BudgetEvent {
  final ExpenseTransactionEntity transaction;

  const AddTransactionEvent(this.transaction);

  @override
  List<Object?> get props => [transaction];
}

class DeleteTransactionEvent extends BudgetEvent {
  final String id;
  final String envelopeId;

  const DeleteTransactionEvent({required this.id, required this.envelopeId});

  @override
  List<Object?> get props => [id, envelopeId];
}
