import 'package:equatable/equatable.dart';

enum StorageZone {
  all,
  fridge,
  freezer,
  pantry,
  medicine,
}

enum FreshnessStatus {
  fresh,    // > 5 days left
  warning,  // <= 5 days left and >= 0
  expired,  // < 0 days left (overdue)
}

class PantryItemEntity extends Equatable {
  final String id;
  final String name;
  final String? barcode;
  final StorageZone zone;
  final DateTime expiryDate;
  final double quantity;
  final String unit;
  final bool isConsumed;
  final DateTime addedDate;
  final String? notes;

  const PantryItemEntity({
    required this.id,
    required this.name,
    this.barcode,
    required this.zone,
    required this.expiryDate,
    this.quantity = 1.0,
    this.unit = 'pcs',
    this.isConsumed = false,
    required this.addedDate,
    this.notes,
  });

  /// Days remaining until expiration.
  int get daysUntilExpiry {
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    final expiry = DateTime(expiryDate.year, expiryDate.month, expiryDate.day);
    return expiry.difference(today).inDays;
  }

  /// Freshness level: Fresh, Warning (expiring soon), or Expired.
  FreshnessStatus get freshnessStatus {
    final days = daysUntilExpiry;
    if (days < 0) return FreshnessStatus.expired;
    if (days <= 5) return FreshnessStatus.warning;
    return FreshnessStatus.fresh;
  }

  PantryItemEntity copyWith({
    String? id,
    String? name,
    String? barcode,
    StorageZone? zone,
    DateTime? expiryDate,
    double? quantity,
    String? unit,
    bool? isConsumed,
    DateTime? addedDate,
    String? notes,
  }) {
    return PantryItemEntity(
      id: id ?? this.id,
      name: name ?? this.name,
      barcode: barcode ?? this.barcode,
      zone: zone ?? this.zone,
      expiryDate: expiryDate ?? this.expiryDate,
      quantity: quantity ?? this.quantity,
      unit: unit ?? this.unit,
      isConsumed: isConsumed ?? this.isConsumed,
      addedDate: addedDate ?? this.addedDate,
      notes: notes ?? this.notes,
    );
  }

  @override
  List<Object?> get props => [
        id,
        name,
        barcode,
        zone,
        expiryDate,
        quantity,
        unit,
        isConsumed,
        addedDate,
        notes,
      ];
}
