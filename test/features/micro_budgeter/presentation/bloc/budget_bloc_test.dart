import 'package:bloc_test/bloc_test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:fpdart/fpdart.dart';
import 'package:mocktail/mocktail.dart';
import 'package:dailypouch/core/error/failures.dart';
import 'package:dailypouch/core/usecases/usecase.dart';
import 'package:dailypouch/features/micro_budgeter/domain/entities/budget_envelope_entity.dart';
import 'package:dailypouch/features/micro_budgeter/domain/repositories/budget_repository.dart';
import 'package:dailypouch/features/micro_budgeter/domain/usecases/add_transaction_usecase.dart';
import 'package:dailypouch/features/micro_budgeter/domain/usecases/delete_envelope_usecase.dart';
import 'package:dailypouch/features/micro_budgeter/domain/usecases/get_envelopes_usecase.dart';
import 'package:dailypouch/features/micro_budgeter/domain/usecases/get_transactions_usecase.dart';
import 'package:dailypouch/features/micro_budgeter/domain/usecases/save_envelope_usecase.dart';
import 'package:dailypouch/features/micro_budgeter/presentation/bloc/budget_bloc.dart';
import 'package:dailypouch/features/micro_budgeter/presentation/bloc/budget_event.dart';
import 'package:dailypouch/features/micro_budgeter/presentation/bloc/budget_state.dart';

class MockGetEnvelopesUseCase extends Mock implements GetEnvelopesUseCase {}
class MockSaveEnvelopeUseCase extends Mock implements SaveEnvelopeUseCase {}
class MockDeleteEnvelopeUseCase extends Mock implements DeleteEnvelopeUseCase {}
class MockAddTransactionUseCase extends Mock implements AddTransactionUseCase {}
class MockGetTransactionsUseCase extends Mock implements GetTransactionsUseCase {}
class MockBudgetRepository extends Mock implements BudgetRepository {}

void main() {
  late BudgetBloc bloc;
  late MockGetEnvelopesUseCase mockGetEnvelopes;
  late MockSaveEnvelopeUseCase mockSaveEnvelope;
  late MockDeleteEnvelopeUseCase mockDeleteEnvelope;
  late MockAddTransactionUseCase mockAddTransaction;
  late MockGetTransactionsUseCase mockGetTransactions;
  late MockBudgetRepository mockRepository;

  final testEnvelope = BudgetEnvelopeEntity(
    id: 'env_1',
    name: 'Vacation',
    targetAmount: 1000.0,
    startDate: DateTime(2026, 10, 1),
    endDate: DateTime(2026, 10, 8),
  );

  setUp(() {
    mockGetEnvelopes = MockGetEnvelopesUseCase();
    mockSaveEnvelope = MockSaveEnvelopeUseCase();
    mockDeleteEnvelope = MockDeleteEnvelopeUseCase();
    mockAddTransaction = MockAddTransactionUseCase();
    mockGetTransactions = MockGetTransactionsUseCase();
    mockRepository = MockBudgetRepository();

    bloc = BudgetBloc(
      getEnvelopes: mockGetEnvelopes,
      saveEnvelope: mockSaveEnvelope,
      deleteEnvelope: mockDeleteEnvelope,
      addTransaction: mockAddTransaction,
      getTransactions: mockGetTransactions,
      repository: mockRepository,
    );
  });

  tearDown(() {
    bloc.close();
  });

  test('initial state is BudgetInitial', () {
    expect(bloc.state, equals(const BudgetInitial()));
  });

  blocTest<BudgetBloc, BudgetState>(
    'emits [BudgetLoading, BudgetLoaded] when LoadEnvelopesEvent succeeds',
    build: () {
      when(() => mockGetEnvelopes(const NoParams()))
          .thenAnswer((_) async => Right([testEnvelope]));
      when(() => mockGetTransactions('env_1'))
          .thenAnswer((_) async => const Right([]));
      return bloc;
    },
    act: (b) => b.add(const LoadEnvelopesEvent()),
    expect: () => [
      const BudgetLoading(),
      BudgetLoaded(
        envelopes: [testEnvelope],
        selectedEnvelope: testEnvelope,
        transactions: const [],
      ),
    ],
  );

  blocTest<BudgetBloc, BudgetState>(
    'emits [BudgetLoading, BudgetError] when LoadEnvelopesEvent fails',
    build: () {
      when(() => mockGetEnvelopes(const NoParams()))
          .thenAnswer((_) async => const Left(DatabaseFailure('Read error')));
      return bloc;
    },
    act: (b) => b.add(const LoadEnvelopesEvent()),
    expect: () => [
      const BudgetLoading(),
      const BudgetError('Read error'),
    ],
  );
}
