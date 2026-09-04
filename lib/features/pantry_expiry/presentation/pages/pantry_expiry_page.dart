import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../core/localization/app_localizations.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_typography.dart';
import '../../../../core/widgets/custom_app_bar.dart';
import '../../../../core/widgets/glass_card.dart';
import '../../domain/entities/pantry_item_entity.dart';
import '../bloc/pantry_bloc.dart';
import '../bloc/pantry_event.dart';
import '../bloc/pantry_state.dart';
import '../widgets/add_edit_pantry_item_dialog.dart';
import '../widgets/pantry_item_tile.dart';

class PantryExpiryPage extends StatefulWidget {
  const PantryExpiryPage({super.key});

  @override
  State<PantryExpiryPage> createState() => _PantryExpiryPageState();
}

class _PantryExpiryPageState extends State<PantryExpiryPage> {
  late final TextEditingController _searchController;

  @override
  void initState() {
    super.initState();
    _searchController = TextEditingController();
    context.read<PantryBloc>().add(const LoadPantryItemsEvent());
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  void _openAddDialog(BuildContext context) async {
    final bloc = context.read<PantryBloc>();
    final result = await showDialog<PantryItemEntity>(
      context: context,
      builder: (_) => const AddEditPantryItemDialog(),
    );

    if (result != null) {
      bloc.add(AddPantryItemEvent(result));
    }
  }

  void _openEditDialog(BuildContext context, PantryItemEntity item) async {
    final bloc = context.read<PantryBloc>();
    final result = await showDialog<PantryItemEntity>(
      context: context,
      builder: (_) => AddEditPantryItemDialog(initial: item),
    );

    if (result != null) {
      bloc.add(UpdatePantryItemEvent(result));
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;

    return Scaffold(
      appBar: CustomAppBar(
        title: l10n.pantryTitle,
        subtitle: l10n.pantrySubtitle,
        accentColor: AppColors.modulePantry,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new_rounded),
          onPressed: () => Navigator.of(context).pop(),
        ),
        actions: [
          IconButton(
            tooltip: l10n.addItemMedicine,
            icon: const Icon(Icons.add_circle_outline_rounded, color: AppColors.modulePantry),
            onPressed: () => _openAddDialog(context),
          ),
          const SizedBox(width: 8),
        ],
      ),
      floatingActionButton: FloatingActionButton.extended(
        backgroundColor: AppColors.modulePantry,
        foregroundColor: Colors.white,
        icon: const Icon(Icons.add_rounded),
        label: Text(l10n.addItemMedicine),
        onPressed: () => _openAddDialog(context),
      ),
      body: BlocConsumer<PantryBloc, PantryState>(
        listener: (context, state) {
          if (state is PantryLoaded && state.message != null) {
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
          if (state is PantryLoading) {
            return const Center(
              child: CircularProgressIndicator(color: AppColors.modulePantry),
            );
          }

          if (state is PantryLoaded) {
            final cubit = context.read<PantryBloc>();
            final items = state.filteredItems;

            return CustomScrollView(
              physics: const BouncingScrollPhysics(),
              slivers: [
                // Top Summary & Zone Filter Header
                SliverPadding(
                  padding: const EdgeInsets.fromLTRB(16, 16, 16, 8),
                  sliver: SliverToBoxAdapter(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Freshness Overview Card
                        GlassCard(
                          gradient: AppColors.pantryGradient,
                          borderRadius: 20,
                          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceAround,
                            children: [
                              _buildStatusStat(l10n.statusFresh.toUpperCase(), state.freshCount, AppColors.success, l10n),
                              Container(width: 1, height: 40, color: Colors.white24),
                              _buildStatusStat(l10n.statusWarning.toUpperCase(), state.warningCount, AppColors.warning, l10n),
                              Container(width: 1, height: 40, color: Colors.white24),
                              _buildStatusStat(l10n.statusExpired.toUpperCase(), state.expiredCount, AppColors.error, l10n),
                            ],
                          ),
                        ),
                        const SizedBox(height: 14),

                        // Search Input
                        TextField(
                          controller: _searchController,
                          onChanged: (q) => cubit.add(SearchPantryEvent(q)),
                          style: AppTypography.bodyLarge.copyWith(color: AppColors.textPrimary),
                          decoration: InputDecoration(
                            hintText: l10n.searchPantryHint,
                            prefixIcon: const Icon(Icons.search_rounded, color: AppColors.textMuted, size: 20),
                            suffixIcon: state.searchQuery.isNotEmpty
                                ? IconButton(
                                    icon: const Icon(Icons.close_rounded, size: 18),
                                    onPressed: () {
                                      _searchController.clear();
                                      cubit.add(const SearchPantryEvent(''));
                                    },
                                  )
                                : null,
                          ),
                        ),
                        const SizedBox(height: 12),

                        // Zone Filter Chips
                        SingleChildScrollView(
                          scrollDirection: Axis.horizontal,
                          child: Row(
                            children: StorageZone.values.map((z) {
                              final isSelected = state.selectedZone == z;
                              String label;
                              switch (z) {
                                case StorageZone.all:
                                  label = l10n.allZones;
                                  break;
                                case StorageZone.fridge:
                                  label = l10n.zoneFridge;
                                  break;
                                case StorageZone.freezer:
                                  label = l10n.zoneFreezer;
                                  break;
                                case StorageZone.pantry:
                                  label = l10n.zonePantry;
                                  break;
                                case StorageZone.medicine:
                                  label = l10n.zoneMedicine;
                                  break;
                              }

                              return Padding(
                                padding: const EdgeInsets.only(right: 8),
                                child: FilterChip(
                                  selected: isSelected,
                                  label: Text(label),
                                  labelStyle: AppTypography.labelSmall.copyWith(
                                    color: isSelected ? Colors.white : AppColors.textSecondary,
                                    fontWeight: isSelected ? FontWeight.w700 : FontWeight.w500,
                                  ),
                                  backgroundColor: AppColors.surfaceElevated,
                                  selectedColor: AppColors.modulePantry,
                                  side: BorderSide(
                                    color: isSelected ? AppColors.modulePantry : AppColors.cardBorder,
                                  ),
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(12),
                                  ),
                                  onSelected: (_) => cubit.add(FilterZoneEvent(z)),
                                ),
                              );
                            }).toList(),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),

                // Items List or Empty State
                if (items.isEmpty)
                  SliverFillRemaining(
                    hasScrollBody: false,
                    child: Center(
                      child: Padding(
                        padding: const EdgeInsets.all(24),
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Icon(
                              Icons.inventory_2_outlined,
                              size: 64,
                              color: AppColors.textMuted.withAlpha(120),
                            ),
                            const SizedBox(height: 16),
                            Text(l10n.noPantryItemsTitle, style: AppTypography.headlineMedium),
                            const SizedBox(height: 6),
                            Text(
                              l10n.noPantryItemsDesc,
                              style: AppTypography.bodyMedium.copyWith(color: AppColors.textMuted),
                              textAlign: TextAlign.center,
                            ),
                            const SizedBox(height: 20),
                            ElevatedButton.icon(
                              style: ElevatedButton.styleFrom(
                                backgroundColor: AppColors.modulePantry,
                                foregroundColor: Colors.white,
                                padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(12),
                                ),
                              ),
                              onPressed: () => _openAddDialog(context),
                              icon: const Icon(Icons.add_rounded, size: 18),
                              label: Text(l10n.addItemMedicine),
                            ),
                          ],
                        ),
                      ),
                    ),
                  )
                else
                  SliverPadding(
                    padding: const EdgeInsets.fromLTRB(16, 0, 16, 80),
                    sliver: SliverList(
                      delegate: SliverChildBuilderDelegate(
                        (context, index) {
                          final item = items[index];
                          return PantryItemTile(
                            item: item,
                            onToggleConsumed: () => cubit.add(ToggleConsumedItemEvent(item.id)),
                            onEdit: () => _openEditDialog(context, item),
                            onDelete: () => cubit.add(DeletePantryItemEvent(item.id)),
                          );
                        },
                        childCount: items.length,
                      ),
                    ),
                  ),
              ],
            );
          }

          return const SizedBox.shrink();
        },
      ),
    );
  }

  Widget _buildStatusStat(String label, int count, Color accent, AppLocalizations l10n) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Text(
          l10n.formatNumber(count.toString()),
          style: AppTypography.displayLarge.copyWith(
            color: Colors.white,
            fontSize: 26,
            fontWeight: FontWeight.w800,
          ),
        ),
        const SizedBox(height: 2),
        Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 6,
              height: 6,
              decoration: BoxDecoration(color: accent, shape: BoxShape.circle),
            ),
            const SizedBox(width: 5),
            Text(
              label,
              style: AppTypography.labelSmall.copyWith(
                color: Colors.white70,
                fontSize: 10,
                fontWeight: FontWeight.w700,
              ),
            ),
          ],
        ),
      ],
    );
  }
}
