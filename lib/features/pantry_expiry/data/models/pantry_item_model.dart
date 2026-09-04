import '../../domain/entities/pantry_item_entity.dart';

class PantryItemModel {
  final String id;
  final String name;
  final String? barcode;
  final String zone;
  final String expiryDate;
  final double quantity;
  final String unit;
  final bool isConsumed;
  final String addedDate;
  final String? notes;

  const PantryItemModel({
    required this.id,
    required this.name,
    this.barcode,
    required this.zone,
    required this.expiryDate,
    required this.quantity,
    required this.unit,
    required this.isConsumed,
    required this.addedDate,
    this.notes,
  });

  factory PantryItemModel.fromEntity(PantryItemEntity entity) {
    return PantryItemModel(
      id: entity.id,
      name: entity.name,
      barcode: entity.barcode,
      zone: entity.zone.name,
      expiryDate: entity.expiryDate.toIso8601String(),
      quantity: entity.quantity,
      unit: entity.unit,
      isConsumed: entity.isConsumed,
      addedDate: entity.addedDate.toIso8601String(),
      notes: entity.notes,
    );
  }

  PantryItemEntity toEntity() {
    return PantryItemEntity(
      id: id,
      name: name,
      barcode: barcode,
      zone: StorageZone.values.firstWhere(
        (z) => z.name == zone,
        orElse: () => StorageZone.pantry,
      ),
      expiryDate: DateTime.tryParse(expiryDate) ?? DateTime.now(),
      quantity: quantity,
      unit: unit,
      isConsumed: isConsumed,
      addedDate: DateTime.tryParse(addedDate) ?? DateTime.now(),
      notes: notes,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'barcode': barcode,
      'zone': zone,
      'expiryDate': expiryDate,
      'quantity': quantity,
      'unit': unit,
      'isConsumed': isConsumed,
      'addedDate': addedDate,
      'notes': notes,
    };
  }

  factory PantryItemModel.fromJson(Map<String, dynamic> json) {
    return PantryItemModel(
      id: json['id'] as String,
      name: json['name'] as String,
      barcode: json['barcode'] as String?,
      zone: (json['zone'] as String?) ?? 'pantry',
      expiryDate: json['expiryDate'] as String,
      quantity: (json['quantity'] as num?)?.toDouble() ?? 1.0,
      unit: (json['unit'] as String?) ?? 'pcs',
      isConsumed: (json['isConsumed'] as bool?) ?? false,
      addedDate: (json['addedDate'] as String?) ?? DateTime.now().toIso8601String(),
      notes: json['notes'] as String?,
    );
  }
}
