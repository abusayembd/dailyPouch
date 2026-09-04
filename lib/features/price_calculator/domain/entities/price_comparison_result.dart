import 'package:equatable/equatable.dart';
import 'comparison_item_entity.dart';

class PriceComparisonResult extends Equatable {
  final List<ComparisonItemEntity> items;
  final ComparisonItemEntity? bestDeal;
  final ComparisonItemEntity? worstDeal;
  final double maxSavingsPercentage;
  final bool hasMismatchedCategories;

  const PriceComparisonResult({
    required this.items,
    this.bestDeal,
    this.worstDeal,
    this.maxSavingsPercentage = 0.0,
    this.hasMismatchedCategories = false,
  });

  factory PriceComparisonResult.calculate(List<ComparisonItemEntity> items) {
    if (items.isEmpty) {
      return const PriceComparisonResult(items: []);
    }

    // Filter valid items (price > 0 and quantity > 0)
    final validItems = items.where((i) => i.price > 0 && i.quantity > 0).toList();
    if (validItems.length < 2) {
      return PriceComparisonResult(
        items: items,
        bestDeal: validItems.isNotEmpty ? validItems.first : null,
      );
    }

    // Check if category matches across items (e.g. comparing weight to weight)
    final firstCategory = validItems.first.unit.category;
    final mismatched = validItems.any((i) => i.unit.category != firstCategory);

    if (mismatched) {
      return PriceComparisonResult(
        items: items,
        hasMismatchedCategories: true,
      );
    }

    // Sort by pricePerBaseUnit ascending
    final sorted = List<ComparisonItemEntity>.from(validItems)
      ..sort((a, b) => a.pricePerBaseUnit.compareTo(b.pricePerBaseUnit));

    final best = sorted.first;
    final worst = sorted.last;

    double maxSavings = 0.0;
    if (worst.pricePerBaseUnit > 0) {
      maxSavings = ((worst.pricePerBaseUnit - best.pricePerBaseUnit) / worst.pricePerBaseUnit) * 100;
    }

    return PriceComparisonResult(
      items: items,
      bestDeal: best,
      worstDeal: worst,
      maxSavingsPercentage: maxSavings > 0 ? maxSavings : 0.0,
      hasMismatchedCategories: false,
    );
  }

  /// Calculates individual percentage savings for a specific item compared to the best deal.
  double getPercentDifferenceFromBest(ComparisonItemEntity item) {
    if (bestDeal == null || item.pricePerBaseUnit <= 0) return 0.0;
    if (item.id == bestDeal!.id) return 0.0;

    final diff = ((item.pricePerBaseUnit - bestDeal!.pricePerBaseUnit) / item.pricePerBaseUnit) * 100;
    return diff > 0 ? diff : 0.0;
  }

  @override
  List<Object?> get props => [
        items,
        bestDeal,
        worstDeal,
        maxSavingsPercentage,
        hasMismatchedCategories,
      ];
}
