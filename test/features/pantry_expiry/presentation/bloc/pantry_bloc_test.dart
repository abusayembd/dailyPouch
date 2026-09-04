import 'package:bloc_test/bloc_test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:fpdart/fpdart.dart';
import 'package:mocktail/mocktail.dart';
import 'package:dailypouch/core/error/failures.dart';
import 'package:dailypouch/core/usecases/usecase.dart';
import 'package:dailypouch/features/pantry_expiry/domain/entities/pantry_item_entity.dart';
import 'package:dailypouch/features/pantry_expiry/domain/usecases/delete_pantry_item_usecase.dart';
import 'package:dailypouch/features/pantry_expiry/domain/usecases/get_pantry_items_usecase.dart';
import 'package:dailypouch/features/pantry_expiry/domain/usecases/save_pantry_item_usecase.dart';
import 'package:dailypouch/features/pantry_expiry/domain/usecases/toggle_consumed_usecase.dart';
import 'package:dailypouch/features/pantry_expiry/presentation/bloc/pantry_bloc.dart';
import 'package:dailypouch/features/pantry_expiry/presentation/bloc/pantry_event.dart';
import 'package:dailypouch/features/pantry_expiry/presentation/bloc/pantry_state.dart';

class MockGetPantryItemsUseCase extends Mock implements GetPantryItemsUseCase {}
class MockSavePantryItemUseCase extends Mock implements SavePantryItemUseCase {}
class MockDeletePantryItemUseCase extends Mock implements DeletePantryItemUseCase {}
class MockToggleConsumedUseCase extends Mock implements ToggleConsumedUseCase {}

void main() {
  late PantryBloc bloc;
  late MockGetPantryItemsUseCase mockGetItems;
  late MockSavePantryItemUseCase mockSaveItem;
  late MockDeletePantryItemUseCase mockDeleteItem;
  late MockToggleConsumedUseCase mockToggleConsumed;

  final testItem = PantryItemEntity(
    id: 'pantry_1',
    name: 'Almond Milk',
    zone: StorageZone.fridge,
    expiryDate: DateTime(2026, 11, 15),
    addedDate: DateTime(2026, 10, 1),
  );

  setUp(() {
    mockGetItems = MockGetPantryItemsUseCase();
    mockSaveItem = MockSavePantryItemUseCase();
    mockDeleteItem = MockDeletePantryItemUseCase();
    mockToggleConsumed = MockToggleConsumedUseCase();

    bloc = PantryBloc(
      getPantryItems: mockGetItems,
      savePantryItem: mockSaveItem,
      deletePantryItem: mockDeleteItem,
      toggleConsumed: mockToggleConsumed,
    );
  });

  tearDown(() {
    bloc.close();
  });

  test('initial state is PantryInitial', () {
    expect(bloc.state, equals(const PantryInitial()));
  });

  blocTest<PantryBloc, PantryState>(
    'emits [PantryLoading, PantryLoaded] when LoadPantryItemsEvent is added and succeeds',
    build: () {
      when(() => mockGetItems(const NoParams()))
          .thenAnswer((_) async => Right([testItem]));
      return bloc;
    },
    act: (b) => b.add(const LoadPantryItemsEvent()),
    expect: () => [
      const PantryLoading(),
      PantryLoaded.fromItems([testItem]),
    ],
  );

  blocTest<PantryBloc, PantryState>(
    'emits [PantryLoading, PantryError] when LoadPantryItemsEvent fails',
    build: () {
      when(() => mockGetItems(const NoParams()))
          .thenAnswer((_) async => const Left(DatabaseFailure('Storage read error')));
      return bloc;
    },
    act: (b) => b.add(const LoadPantryItemsEvent()),
    expect: () => [
      const PantryLoading(),
      const PantryError('Storage read error'),
    ],
  );
}
