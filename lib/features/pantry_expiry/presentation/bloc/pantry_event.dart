import 'package:equatable/equatable.dart';
import '../../domain/entities/pantry_item_entity.dart';

abstract class PantryEvent extends Equatable {
  const PantryEvent();

  @override
  List<Object?> get props => [];
}

class LoadPantryItemsEvent extends PantryEvent {
  const LoadPantryItemsEvent();
}

class FilterZoneEvent extends PantryEvent {
  final StorageZone zone;

  const FilterZoneEvent(this.zone);

  @override
  List<Object?> get props => [zone];
}

class SearchPantryEvent extends PantryEvent {
  final String query;

  const SearchPantryEvent(this.query);

  @override
  List<Object?> get props => [query];
}

class AddPantryItemEvent extends PantryEvent {
  final PantryItemEntity item;

  const AddPantryItemEvent(this.item);

  @override
  List<Object?> get props => [item];
}

class UpdatePantryItemEvent extends PantryEvent {
  final PantryItemEntity item;

  const UpdatePantryItemEvent(this.item);

  @override
  List<Object?> get props => [item];
}

class DeletePantryItemEvent extends PantryEvent {
  final String id;

  const DeletePantryItemEvent(this.id);

  @override
  List<Object?> get props => [id];
}

class ToggleConsumedItemEvent extends PantryEvent {
  final String id;

  const ToggleConsumedItemEvent(this.id);

  @override
  List<Object?> get props => [id];
}
