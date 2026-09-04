import 'package:bloc_test/bloc_test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:fpdart/fpdart.dart';
import 'package:mocktail/mocktail.dart';
import 'package:dailypouch/core/error/failures.dart';
import 'package:dailypouch/features/expense_tracker/domain/entities/expense_category.dart';
import 'package:dailypouch/features/expense_tracker/domain/entities/expense_transaction.dart';
import 'package:dailypouch/features/expense_tracker/domain/usecases/expense_usecases.dart';
import 'package:dailypouch/features/expense_tracker/presentation/bloc/expense_bloc.dart';
import 'package:dailypouch/features/expense_tracker/presentation/bloc/expense_event.dart';
import 'package:dailypouch/features/expense_tracker/presentation/bloc/expense_state.dart';

class MockGetExpenseTransactionsUseCase extends Mock implements GetExpenseTransactionsUseCase {}
class MockSaveExpenseTransactionUseCase extends Mock implements SaveExpenseTransactionUseCase {}
class MockDeleteExpenseTransactionUseCase extends Mock implements DeleteExpenseTransactionUseCase {}
class FakeExpenseTransaction extends Fake implements ExpenseTransaction {}

void main() {
  setUpAll(() {
    registerFallbackValue(FakeExpenseTransaction());
  });

  late ExpenseBloc bloc;
  late MockGetExpenseTransactionsUseCase mockGetTransactions;
  late MockSaveExpenseTransactionUseCase mockSaveTransaction;
  late MockDeleteExpenseTransactionUseCase mockDeleteTransaction;

  final sampleTransactions = [
    ExpenseTransaction(
      id: 'tx_1',
      title: 'Salary Deposit',
      amount: 4000.0,
      type: TransactionType.income,
      category: ExpenseCategory.salary,
      date: DateTime.now(),
      paymentMethod: PaymentMethod.bankTransfer,
    ),
    ExpenseTransaction(
      id: 'tx_2',
      title: 'Monthly Rent',
      amount: 1200.0,
      type: TransactionType.expense,
      category: ExpenseCategory.housing,
      date: DateTime.now(),
      paymentMethod: PaymentMethod.bankTransfer,
    ),
    ExpenseTransaction(
      id: 'tx_3',
      title: 'Groceries Restock',
      amount: 150.0,
      type: TransactionType.expense,
      category: ExpenseCategory.groceries,
      date: DateTime.now(),
      paymentMethod: PaymentMethod.creditCard,
    ),
  ];

  setUp(() {
    mockGetTransactions = MockGetExpenseTransactionsUseCase();
    mockSaveTransaction = MockSaveExpenseTransactionUseCase();
    mockDeleteTransaction = MockDeleteExpenseTransactionUseCase();

    bloc = ExpenseBloc(
      getTransactions: mockGetTransactions,
      saveTransaction: mockSaveTransaction,
      deleteTransaction: mockDeleteTransaction,
    );
  });

  tearDown(() {
    bloc.close();
  });

  test('initial state should be ExpenseInitialState', () {
    expect(bloc.state, equals(const ExpenseInitialState()));
  });

  group('LoadExpensesEvent', () {
    blocTest<ExpenseBloc, ExpenseState>(
      'emits [ExpenseLoadingState, ExpenseLoadedState] with accurate calculations when successful',
      build: () {
        when(() => mockGetTransactions()).thenAnswer((_) async => Right(sampleTransactions));
        return bloc;
      },
      act: (b) => b.add(const LoadExpensesEvent()),
      expect: () => [
        const ExpenseLoadingState(),
        isA<ExpenseLoadedState>()
            .having((s) => s.allTransactions.length, 'allTransactions.length', 3)
            .having((s) => s.filteredTransactions.length, 'filteredTransactions.length', 3)
            .having((s) => s.summary.totalIncome, 'summary.totalIncome', 4000.0)
            .having((s) => s.summary.totalExpense, 'summary.totalExpense', 1350.0)
            .having((s) => s.summary.netCashFlow, 'summary.netCashFlow', 2650.0),
      ],
    );

    blocTest<ExpenseBloc, ExpenseState>(
      'emits [ExpenseLoadingState, ExpenseErrorState] when datasource fails',
      build: () {
        when(() => mockGetTransactions()).thenAnswer(
          (_) async => const Left(DatabaseFailure('Disk read failed')),
        );
        return bloc;
      },
      act: (b) => b.add(const LoadExpensesEvent()),
      expect: () => [
        const ExpenseLoadingState(),
        const ExpenseErrorState('Disk read failed'),
      ],
    );
  });

  group('SaveExpenseEvent & DeleteExpenseEvent', () {
    final newTransaction = ExpenseTransaction(
      id: 'tx_4',
      title: 'Movie Night',
      amount: 35.0,
      type: TransactionType.expense,
      category: ExpenseCategory.entertainment,
      date: DateTime.now(),
    );

    blocTest<ExpenseBloc, ExpenseState>(
      'saves transaction and refreshes state smoothly',
      build: () {
        when(() => mockSaveTransaction(any())).thenAnswer((_) async => const Right(null));
        when(() => mockGetTransactions()).thenAnswer(
          (_) async => Right([...sampleTransactions, newTransaction]),
        );
        return bloc;
      },
      act: (b) => b.add(SaveExpenseEvent(newTransaction)),
      expect: () => [
        isA<ExpenseLoadedState>()
            .having((s) => s.allTransactions.length, 'allTransactions.length', 4)
            .having((s) => s.summary.totalExpense, 'summary.totalExpense', 1385.0),
      ],
    );

    blocTest<ExpenseBloc, ExpenseState>(
      'deletes transaction and refreshes state smoothly',
      build: () {
        when(() => mockDeleteTransaction('tx_3')).thenAnswer((_) async => const Right(null));
        when(() => mockGetTransactions()).thenAnswer(
          (_) async => Right(sampleTransactions.where((t) => t.id != 'tx_3').toList()),
        );
        return bloc;
      },
      act: (b) => b.add(const DeleteExpenseEvent('tx_3')),
      expect: () => [
        isA<ExpenseLoadedState>()
            .having((s) => s.allTransactions.length, 'allTransactions.length', 2)
            .having((s) => s.summary.totalExpense, 'summary.totalExpense', 1200.0),
      ],
    );
  });

  group('Filters & Search', () {
    blocTest<ExpenseBloc, ExpenseState>(
      'filters transactions by type when ChangeTypeFilterEvent dispatched',
      build: () => bloc,
      seed: () => ExpenseLoadedState(
        allTransactions: sampleTransactions,
        filteredTransactions: sampleTransactions,
        summary: FinancialSummary.fromTransactions(sampleTransactions),
      ),
      act: (b) => b.add(const ChangeTypeFilterEvent(TransactionType.expense)),
      expect: () => [
        isA<ExpenseLoadedState>()
            .having((s) => s.filteredTransactions.length, 'filteredTransactions.length', 2)
            .having((s) => s.selectedType, 'selectedType', TransactionType.expense),
      ],
    );

    blocTest<ExpenseBloc, ExpenseState>(
      'filters transactions by search query when SearchExpensesEvent dispatched',
      build: () => bloc,
      seed: () => ExpenseLoadedState(
        allTransactions: sampleTransactions,
        filteredTransactions: sampleTransactions,
        summary: FinancialSummary.fromTransactions(sampleTransactions),
      ),
      act: (b) => b.add(const SearchExpensesEvent('Rent')),
      expect: () => [
        isA<ExpenseLoadedState>()
            .having((s) => s.filteredTransactions.length, 'filteredTransactions.length', 1)
            .having((s) => s.filteredTransactions.first.title, 'title', 'Monthly Rent'),
      ],
    );
  });
}
