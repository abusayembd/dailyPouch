import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../core/currency/currency_cubit.dart';
import '../../../../core/localization/app_localizations.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_typography.dart';
import '../../../../core/widgets/custom_app_bar.dart';
import '../../../../core/widgets/glass_card.dart';
import '../../domain/entities/saved_benchmark_entity.dart';
import '../cubit/price_calculator_cubit.dart';
import '../cubit/price_calculator_state.dart';
import '../widgets/best_deal_banner.dart';
import '../widgets/comparison_item_card.dart';

class PriceCalculatorPage extends StatefulWidget {
  const PriceCalculatorPage({super.key});

  @override
  State<PriceCalculatorPage> createState() => _PriceCalculatorPageState();
}

class _PriceCalculatorPageState extends State<PriceCalculatorPage> {
  @override
  void initState() {
    super.initState();
    context.read<PriceCalculatorCubit>().loadSavedBenchmarks();
  }

  void _showSaveBenchmarkDialog(BuildContext context) {
    final titleController = TextEditingController();
    final cubit = context.read<PriceCalculatorCubit>();
    final l10n = context.l10n;

    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        backgroundColor: AppColors.surfaceCard,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
          side: const BorderSide(color: AppColors.cardBorder),
        ),
        title: Text(l10n.saveBenchmarkTitle, style: AppTypography.headlineMedium),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              l10n.saveBenchmarkDesc,
              style: AppTypography.bodyMedium,
            ),
            const SizedBox(height: 14),
            TextField(
              controller: titleController,
              style: AppTypography.bodyLarge.copyWith(color: AppColors.textPrimary),
              decoration: InputDecoration(
                hintText: l10n.benchmarkNameHint,
              ),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(ctx).pop(),
            child: Text(l10n.cancel),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.modulePriceCalc,
              foregroundColor: Colors.white,
            ),
            onPressed: () {
              final text = titleController.text.trim();
              if (text.isNotEmpty) {
                cubit.saveCurrentBenchmark(text);
                Navigator.of(ctx).pop();
              }
            },
            child: Text(l10n.done),
          ),
        ],
      ),
    );
  }

  void _showSavedBenchmarksBottomSheet(
    BuildContext context,
    List<SavedBenchmarkEntity> benchmarks,
  ) {
    final cubit = context.read<PriceCalculatorCubit>();
    final l10n = context.l10n;

    showModalBottomSheet(
      context: context,
      backgroundColor: AppColors.surfaceCard,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      builder: (ctx) => Container(
        padding: const EdgeInsets.all(20),
        constraints: BoxConstraints(
          maxHeight: MediaQuery.of(context).size.height * 0.65,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  l10n.savedBenchmarksTitle,
                  style: AppTypography.headlineMedium,
                ),
                IconButton(
                  icon: const Icon(Icons.close_rounded, color: AppColors.textMuted),
                  onPressed: () => Navigator.of(ctx).pop(),
                ),
              ],
            ),
            const SizedBox(height: 12),
            if (benchmarks.isEmpty)
              Expanded(
                child: Center(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(
                        Icons.bookmarks_outlined,
                        size: 48,
                        color: AppColors.textMuted.withAlpha(120),
                      ),
                      const SizedBox(height: 12),
                      Text(
                        l10n.noSavedBenchmarks,
                        style: AppTypography.titleMedium,
                      ),
                      const SizedBox(height: 4),
                      Text(
                        l10n.noSavedBenchmarksDesc,
                        style: AppTypography.bodyMedium.copyWith(color: AppColors.textMuted),
                        textAlign: TextAlign.center,
                      ),
                    ],
                  ),
                ),
              )
            else
              Expanded(
                child: ListView.separated(
                  physics: const BouncingScrollPhysics(),
                  itemCount: benchmarks.length,
                  separatorBuilder: (_, _) => const SizedBox(height: 8),
                  itemBuilder: (context, index) {
                    final item = benchmarks[index];
                    final dateStr = l10n.formatDate(item.createdAt);

                    return GlassCard(
                      borderRadius: 14,
                      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
                      onTap: () {
                        cubit.loadBenchmark(item);
                        Navigator.of(ctx).pop();
                      },
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  item.title,
                                  style: AppTypography.titleMedium.copyWith(
                                    fontWeight: FontWeight.w700,
                                  ),
                                ),
                                const SizedBox(height: 2),
                                Text(
                                  l10n.optionsCompared(item.items.length, dateStr),
                                  style: AppTypography.labelSmall.copyWith(
                                    color: AppColors.textMuted,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          const Icon(
                            Icons.arrow_forward_ios_rounded,
                            size: 14,
                            color: AppColors.textMuted,
                          ),
                        ],
                      ),
                    );
                  },
                ),
              ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final activeCurrency = context.watch<CurrencyCubit>().state;
    final l10n = context.l10n;

    return Scaffold(
      appBar: CustomAppBar(
        title: l10n.priceCalcTitle,
        subtitle: l10n.priceCalcSubtitle,
        accentColor: AppColors.modulePriceCalc,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new_rounded),
          onPressed: () => Navigator.of(context).pop(),
        ),
        actions: [
          BlocBuilder<PriceCalculatorCubit, PriceCalculatorState>(
            builder: (context, state) {
              return IconButton(
                tooltip: l10n.savedBenchmarksTooltip,
                icon: Badge(
                  isLabelVisible: state.savedBenchmarks.isNotEmpty,
                  label: Text(l10n.formatNumber('${state.savedBenchmarks.length}')),
                  child: const Icon(Icons.bookmarks_outlined, color: AppColors.modulePriceCalc),
                ),
                onPressed: () => _showSavedBenchmarksBottomSheet(
                  context,
                  state.savedBenchmarks,
                ),
              );
            },
          ),
          IconButton(
            tooltip: l10n.resetToDefaultTooltip,
            icon: const Icon(Icons.refresh_rounded, color: AppColors.textMuted),
            onPressed: () => context.read<PriceCalculatorCubit>().resetDefaults(),
          ),
          const SizedBox(width: 8),
        ],
      ),
      body: BlocConsumer<PriceCalculatorCubit, PriceCalculatorState>(
        listener: (context, state) {
          if (state.message != null) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(state.message!),
                backgroundColor: AppColors.surfaceElevated,
                behavior: SnackBarBehavior.floating,
                duration: const Duration(seconds: 2),
              ),
            );
          }
        },
        builder: (context, state) {
          final cubit = context.read<PriceCalculatorCubit>();
          final result = state.result;
          final bestDeal = result.bestDeal;

          return CustomScrollView(
            physics: const BouncingScrollPhysics(),
            slivers: [
              // Best Deal Summary Banner
              SliverPadding(
                padding: const EdgeInsets.all(16),
                sliver: SliverToBoxAdapter(
                  child: BestDealBanner(
                    result: result,
                    currencySymbol: activeCurrency.symbol,
                  ),
                ),
              ),

              // Item Comparison Cards List
              SliverPadding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                sliver: SliverList(
                  delegate: SliverChildBuilderDelegate(
                    (context, index) {
                      final item = state.items[index];
                      final isBest = bestDeal != null &&
                          bestDeal.id == item.id &&
                          !result.hasMismatchedCategories;
                      final percentMore = result.getPercentDifferenceFromBest(item);

                      return ComparisonItemCard(
                        key: ValueKey(item.id),
                        item: item,
                        isBestDeal: isBest,
                        percentMoreExpensive: percentMore,
                        canDelete: state.items.length > 2,
                        currencySymbol: activeCurrency.symbol,
                        onLabelChanged: (val) => cubit.updateItemLabel(item.id, val),
                        onPriceChanged: (val) => cubit.updateItemPrice(item.id, val),
                        onQuantityChanged: (val) => cubit.updateItemQuantity(item.id, val),
                        onUnitChanged: (val) => cubit.updateItemUnit(item.id, val),
                        onDelete: () => cubit.removeItem(item.id),
                      );
                    },
                    childCount: state.items.length,
                  ),
                ),
              ),

              // Action Buttons (Add Item & Save Benchmark)
              SliverPadding(
                padding: const EdgeInsets.fromLTRB(16, 8, 16, 40),
                sliver: SliverToBoxAdapter(
                  child: Column(
                    children: [
                      SizedBox(
                        width: double.infinity,
                        child: OutlinedButton.icon(
                          style: OutlinedButton.styleFrom(
                            foregroundColor: AppColors.modulePriceCalc,
                            side: const BorderSide(color: AppColors.modulePriceCalc),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(14),
                            ),
                            padding: const EdgeInsets.symmetric(vertical: 14),
                          ),
                          onPressed: () => cubit.addItem(),
                          icon: const Icon(Icons.add_rounded),
                          label: Text(
                            l10n.addComparisonOption,
                            style: const TextStyle(fontWeight: FontWeight.w600),
                          ),
                        ),
                      ),
                      const SizedBox(height: 10),
                      if (bestDeal != null && bestDeal.price > 0 && bestDeal.quantity > 0)
                        SizedBox(
                          width: double.infinity,
                          child: ElevatedButton.icon(
                            style: ElevatedButton.styleFrom(
                              backgroundColor: AppColors.modulePriceCalc,
                              foregroundColor: Colors.white,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(14),
                              ),
                              padding: const EdgeInsets.symmetric(vertical: 14),
                            ),
                            onPressed: () => _showSaveBenchmarkDialog(context),
                            icon: const Icon(Icons.bookmark_add_rounded, size: 18),
                            label: Text(l10n.saveThisBenchmark),
                          ),
                        ),
                    ],
                  ),
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}
