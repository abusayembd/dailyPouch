import 'package:equatable/equatable.dart';
import 'comparison_item_entity.dart';

class SavedBenchmarkEntity extends Equatable {
  final String id;
  final String title;
  final DateTime createdAt;
  final List<ComparisonItemEntity> items;

  const SavedBenchmarkEntity({
    required this.id,
    required this.title,
    required this.createdAt,
    required this.items,
  });

  @override
  List<Object?> get props => [id, title, createdAt, items];
}
