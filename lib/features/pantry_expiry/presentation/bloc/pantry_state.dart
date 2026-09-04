import 'package:equatable/equatable.dart';
import '../../domain/entities/pantry_item_entity.dart';

abstract class PantryState extends Equatable {
  const PantryState();

  @override
  List<Object?> get props => [];
}

class PantryInitial extends PantryState {
  const PantryInitial();
}

class PantryLoading extends PantryState {
  const PantryLoading();
}

class PantryLoaded extends PantryState {
  final List<PantryItemEntity> allItems;
  final List<PantryItemEntity> filteredItems;
  final StorageZone selectedZone;
  final String searchQuery;
  final int freshCount;
  final int warningCount;
  final int expiredCount;
  final String? message;

  const PantryLoaded({
    required this.allItems,
    required this.filteredItems,
    this.selectedZone = StorageZone.all,
    this.searchQuery = '',
    required this.freshCount,
    required this.warningCount,
    required this.expiredCount,
    this.message,
  });

  factory PantryLoaded.fromItems(
    List<PantryItemEntity> items, {
    StorageZone zone = StorageZone.all,
    String query = '',
    String? message,
  }) {
    int fresh = 0;
    int warning = 0;
    int expired = 0;

    for (final i in items) {
      if (!i.isConsumed) {
        switch (i.freshnessStatus) {
          case FreshnessStatus.fresh:
            fresh++;
            break;
          case FreshnessStatus.warning:
            warning++;
            break;
          case FreshnessStatus.expired:
            expired++;
            break;
        }
      }
    }

    final cleanQuery = query.trim().toLowerCase();
    final filtered = items.where((i) {
      final matchesZone = zone == StorageZone.all || i.zone == zone;
      final matchesQuery = cleanQuery.isEmpty ||
          i.name.toLowerCase().contains(cleanQuery) ||
          (i.barcode != null && i.barcode!.toLowerCase().contains(cleanQuery));
      return matchesZone && matchesQuery;
    }).toList();

    // Sort by expiration date ascending (nearest to expire first)
    filtered.sort((a, b) => a.expiryDate.compareTo(b.expiryDate));

    return PantryLoaded(
      allItems: items,
      filteredItems: filtered,
      selectedZone: zone,
      searchQuery: query,
      freshCount: fresh,
      warningCount: warning,
      expiredCount: expired,
      message: message,
    );
  }

  @override
  List<Object?> get props => [
        allItems,
        filteredItems,
        selectedZone,
        searchQuery,
        freshCount,
        warningCount,
        expiredCount,
        message,
      ];
}

class PantryError extends PantryState {
  final String message;

  const PantryError(this.message);

  @override
  List<Object?> get props => [message];
}
