import '../../domain/entities/comparison_item_entity.dart';
import '../../domain/entities/saved_benchmark_entity.dart';

class ComparisonItemModel {
  final String id;
  final String label;
  final double price;
  final double quantity;
  final String unitSymbol;

  const ComparisonItemModel({
    required this.id,
    required this.label,
    required this.price,
    required this.quantity,
    required this.unitSymbol,
  });

  factory ComparisonItemModel.fromEntity(ComparisonItemEntity entity) {
    return ComparisonItemModel(
      id: entity.id,
      label: entity.label,
      price: entity.price,
      quantity: entity.quantity,
      unitSymbol: entity.unit.name,
    );
  }

  ComparisonItemEntity toEntity() {
    return ComparisonItemEntity(
      id: id,
      label: label,
      price: price,
      quantity: quantity,
      unit: MeasurementUnit.values.firstWhere(
        (u) => u.name == unitSymbol,
        orElse: () => MeasurementUnit.g,
      ),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'label': label,
      'price': price,
      'quantity': quantity,
      'unitSymbol': unitSymbol,
    };
  }

  factory ComparisonItemModel.fromJson(Map<String, dynamic> json) {
    return ComparisonItemModel(
      id: json['id'] as String,
      label: json['label'] as String,
      price: (json['price'] as num).toDouble(),
      quantity: (json['quantity'] as num).toDouble(),
      unitSymbol: json['unitSymbol'] as String,
    );
  }
}

class SavedBenchmarkModel {
  final String id;
  final String title;
  final String createdAt;
  final List<ComparisonItemModel> items;

  const SavedBenchmarkModel({
    required this.id,
    required this.title,
    required this.createdAt,
    required this.items,
  });

  factory SavedBenchmarkModel.fromEntity(SavedBenchmarkEntity entity) {
    return SavedBenchmarkModel(
      id: entity.id,
      title: entity.title,
      createdAt: entity.createdAt.toIso8601String(),
      items: entity.items.map((i) => ComparisonItemModel.fromEntity(i)).toList(),
    );
  }

  SavedBenchmarkEntity toEntity() {
    return SavedBenchmarkEntity(
      id: id,
      title: title,
      createdAt: DateTime.tryParse(createdAt) ?? DateTime.now(),
      items: items.map((i) => i.toEntity()).toList(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'createdAt': createdAt,
      'items': items.map((i) => i.toJson()).toList(),
    };
  }

  factory SavedBenchmarkModel.fromJson(Map<String, dynamic> json) {
    final list = json['items'] as List<dynamic>? ?? [];
    return SavedBenchmarkModel(
      id: json['id'] as String,
      title: json['title'] as String,
      createdAt: json['createdAt'] as String,
      items: list.map((e) => ComparisonItemModel.fromJson(e as Map<String, dynamic>)).toList(),
    );
  }
}
