import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../core/usecases/usecase.dart';
import '../../domain/entities/pantry_item_entity.dart';
import '../../domain/usecases/delete_pantry_item_usecase.dart';
import '../../domain/usecases/get_pantry_items_usecase.dart';
import '../../domain/usecases/save_pantry_item_usecase.dart';
import '../../domain/usecases/toggle_consumed_usecase.dart';
import 'pantry_event.dart';
import 'pantry_state.dart';

class PantryBloc extends Bloc<PantryEvent, PantryState> {
  final GetPantryItemsUseCase getPantryItems;
  final SavePantryItemUseCase savePantryItem;
  final DeletePantryItemUseCase deletePantryItem;
  final ToggleConsumedUseCase toggleConsumed;

  PantryBloc({
    required this.getPantryItems,
    required this.savePantryItem,
    required this.deletePantryItem,
    required this.toggleConsumed,
  }) : super(const PantryInitial()) {
    on<LoadPantryItemsEvent>(_onLoadPantryItems);
    on<FilterZoneEvent>(_onFilterZone);
    on<SearchPantryEvent>(_onSearchPantry);
    on<AddPantryItemEvent>(_onAddPantryItem);
    on<UpdatePantryItemEvent>(_onUpdatePantryItem);
    on<DeletePantryItemEvent>(_onDeletePantryItem);
    on<ToggleConsumedItemEvent>(_onToggleConsumed);
  }

  Future<void> _onLoadPantryItems(
    LoadPantryItemsEvent event,
    Emitter<PantryState> emit,
  ) async {
    emit(const PantryLoading());
    final result = await getPantryItems(const NoParams());
    result.fold(
      (failure) => emit(PantryError(failure.message)),
      (items) => emit(PantryLoaded.fromItems(items)),
    );
  }

  void _onFilterZone(
    FilterZoneEvent event,
    Emitter<PantryState> emit,
  ) {
    if (state is PantryLoaded) {
      final current = state as PantryLoaded;
      emit(PantryLoaded.fromItems(
        current.allItems,
        zone: event.zone,
        query: current.searchQuery,
      ));
    }
  }

  void _onSearchPantry(
    SearchPantryEvent event,
    Emitter<PantryState> emit,
  ) {
    if (state is PantryLoaded) {
      final current = state as PantryLoaded;
      emit(PantryLoaded.fromItems(
        current.allItems,
        zone: current.selectedZone,
        query: event.query,
      ));
    }
  }

  Future<void> _onAddPantryItem(
    AddPantryItemEvent event,
    Emitter<PantryState> emit,
  ) async {
    final result = await savePantryItem(event.item);
    await result.fold(
      (failure) async => emit(PantryError(failure.message)),
      (_) async {
        final refreshed = await getPantryItems(const NoParams());
        refreshed.fold(
          (failure) => emit(PantryError(failure.message)),
          (items) {
            final currentZone = state is PantryLoaded ? (state as PantryLoaded).selectedZone : StorageZone.all;
            emit(PantryLoaded.fromItems(
              items,
              zone: currentZone,
              message: 'Added "${event.item.name}"',
            ));
          },
        );
      },
    );
  }

  Future<void> _onUpdatePantryItem(
    UpdatePantryItemEvent event,
    Emitter<PantryState> emit,
  ) async {
    final result = await savePantryItem(event.item);
    await result.fold(
      (failure) async => emit(PantryError(failure.message)),
      (_) async {
        final refreshed = await getPantryItems(const NoParams());
        refreshed.fold(
          (failure) => emit(PantryError(failure.message)),
          (items) {
            final currentZone = state is PantryLoaded ? (state as PantryLoaded).selectedZone : StorageZone.all;
            emit(PantryLoaded.fromItems(
              items,
              zone: currentZone,
              message: 'Updated item',
            ));
          },
        );
      },
    );
  }

  Future<void> _onDeletePantryItem(
    DeletePantryItemEvent event,
    Emitter<PantryState> emit,
  ) async {
    final result = await deletePantryItem(event.id);
    await result.fold(
      (failure) async => emit(PantryError(failure.message)),
      (_) async {
        final refreshed = await getPantryItems(const NoParams());
        refreshed.fold(
          (failure) => emit(PantryError(failure.message)),
          (items) {
            final currentZone = state is PantryLoaded ? (state as PantryLoaded).selectedZone : StorageZone.all;
            emit(PantryLoaded.fromItems(
              items,
              zone: currentZone,
              message: 'Item removed',
            ));
          },
        );
      },
    );
  }

  Future<void> _onToggleConsumed(
    ToggleConsumedItemEvent event,
    Emitter<PantryState> emit,
  ) async {
    final result = await toggleConsumed(event.id);
    await result.fold(
      (failure) async => emit(PantryError(failure.message)),
      (_) async {
        final refreshed = await getPantryItems(const NoParams());
        refreshed.fold(
          (failure) => emit(PantryError(failure.message)),
          (items) {
            final currentZone = state is PantryLoaded ? (state as PantryLoaded).selectedZone : StorageZone.all;
            emit(PantryLoaded.fromItems(
              items,
              zone: currentZone,
            ));
          },
        );
      },
    );
  }
}
