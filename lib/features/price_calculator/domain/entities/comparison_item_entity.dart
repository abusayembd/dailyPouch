import 'package:equatable/equatable.dart';

enum UnitCategory {
  weight,
  volume,
  count,
}

enum MeasurementUnit {
  // Weight (base: gram)
  g(name: 'Grams (g)', symbol: 'g', category: UnitCategory.weight, baseFactor: 1.0),
  kg(name: 'Kilograms (kg)', symbol: 'kg', category: UnitCategory.weight, baseFactor: 1000.0),
  oz(name: 'Ounces (oz)', symbol: 'oz', category: UnitCategory.weight, baseFactor: 28.3495),
  lb(name: 'Pounds (lb)', symbol: 'lb', category: UnitCategory.weight, baseFactor: 453.592),

  // Volume (base: milliliter)
  ml(name: 'Milliliters (ml)', symbol: 'ml', category: UnitCategory.volume, baseFactor: 1.0),
  l(name: 'Liters (L)', symbol: 'L', category: UnitCategory.volume, baseFactor: 1000.0),
  flOz(name: 'Fluid Oz (fl oz)', symbol: 'fl oz', category: UnitCategory.volume, baseFactor: 29.5735),
  gal(name: 'Gallons (gal)', symbol: 'gal', category: UnitCategory.volume, baseFactor: 3785.41),

  // Count (base: piece)
  pcs(name: 'Pieces (pcs)', symbol: 'pcs', category: UnitCategory.count, baseFactor: 1.0),
  pack(name: 'Pack (10 pcs)', symbol: 'pk(10)', category: UnitCategory.count, baseFactor: 10.0),
  dozen(name: 'Dozen (12 pcs)', symbol: 'doz', category: UnitCategory.count, baseFactor: 12.0);

  final String name;
  final String symbol;
  final UnitCategory category;
  final double baseFactor;

  const MeasurementUnit({
    required this.name,
    required this.symbol,
    required this.category,
    required this.baseFactor,
  });
}

class ComparisonItemEntity extends Equatable {
  final String id;
  final String label;
  final double price;
  final double quantity;
  final MeasurementUnit unit;

  const ComparisonItemEntity({
    required this.id,
    required this.label,
    required this.price,
    required this.quantity,
    required this.unit,
  });

  /// Total base units (grams, milliliters, or pieces).
  double get totalBaseUnits => quantity * unit.baseFactor;

  /// Price per single base unit (e.g. per gram / per ml / per piece).
  double get pricePerBaseUnit {
    if (totalBaseUnits <= 0) return 0.0;
    return price / totalBaseUnits;
  }

  /// Price per standard reference unit (per 100g, per 100ml, or per 1pc).
  double get pricePerStandardUnit {
    switch (unit.category) {
      case UnitCategory.weight:
      case UnitCategory.volume:
        return pricePerBaseUnit * 100; // per 100g or per 100ml
      case UnitCategory.count:
        return pricePerBaseUnit; // per 1 piece
    }
  }

  /// Price per bulk reference unit (per 1kg, per 1L, or per 100pcs).
  double get pricePerBulkUnit {
    switch (unit.category) {
      case UnitCategory.weight:
      case UnitCategory.volume:
        return pricePerBaseUnit * 1000; // per 1kg or per 1L
      case UnitCategory.count:
        return pricePerBaseUnit * 100; // per 100 pieces
    }
  }

  String get standardUnitLabel {
    switch (unit.category) {
      case UnitCategory.weight:
        return '/ 100g';
      case UnitCategory.volume:
        return '/ 100ml';
      case UnitCategory.count:
        return '/ pc';
    }
  }

  String get bulkUnitLabel {
    switch (unit.category) {
      case UnitCategory.weight:
        return '/ 1kg';
      case UnitCategory.volume:
        return '/ 1L';
      case UnitCategory.count:
        return '/ 100pcs';
    }
  }

  ComparisonItemEntity copyWith({
    String? id,
    String? label,
    double? price,
    double? quantity,
    MeasurementUnit? unit,
  }) {
    return ComparisonItemEntity(
      id: id ?? this.id,
      label: label ?? this.label,
      price: price ?? this.price,
      quantity: quantity ?? this.quantity,
      unit: unit ?? this.unit,
    );
  }

  @override
  List<Object?> get props => [id, label, price, quantity, unit];
}
