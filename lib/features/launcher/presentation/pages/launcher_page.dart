import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:dailypouch/core/di/injection_container.dart' as di;
import 'package:dailypouch/core/localization/app_localizations.dart';
import 'package:dailypouch/core/theme/app_colors.dart';
import 'package:dailypouch/core/theme/app_typography.dart';
import 'package:dailypouch/core/widgets/custom_app_bar.dart';
import 'package:dailypouch/core/widgets/responsive_layout.dart';
import 'package:dailypouch/features/expense_tracker/presentation/bloc/expense_bloc.dart';
import 'package:dailypouch/features/expense_tracker/presentation/pages/expense_tracker_page.dart';
import 'package:dailypouch/features/interval_timer/presentation/bloc/interval_timer_bloc.dart';
import 'package:dailypouch/features/interval_timer/presentation/pages/interval_timer_page.dart';
import 'package:dailypouch/features/launcher/domain/entities/utility_module.dart';
import 'package:dailypouch/features/launcher/presentation/cubit/launcher_cubit.dart';
import 'package:dailypouch/features/launcher/presentation/cubit/launcher_state.dart';
import 'package:dailypouch/features/launcher/presentation/widgets/arcade_module_card.dart';
import 'package:dailypouch/features/launcher/presentation/widgets/search_filter_bar.dart';
import 'package:dailypouch/features/micro_budgeter/presentation/bloc/budget_bloc.dart';
import 'package:dailypouch/features/micro_budgeter/presentation/pages/micro_budgeter_page.dart';
import 'package:dailypouch/features/pantry_expiry/presentation/bloc/pantry_bloc.dart';
import 'package:dailypouch/features/pantry_expiry/presentation/pages/pantry_expiry_page.dart';
import 'package:dailypouch/features/price_calculator/presentation/cubit/price_calculator_cubit.dart';
import 'package:dailypouch/features/price_calculator/presentation/pages/price_calculator_page.dart';
import 'package:dailypouch/features/subscription_tracker/presentation/bloc/subscription_bloc.dart';
import 'package:dailypouch/features/subscription_tracker/presentation/pages/subscription_page.dart';
import 'package:dailypouch/features/launcher/presentation/widgets/curved_notch_bottom_nav_bar.dart';
import 'settings_page.dart';

class LauncherPage extends StatefulWidget {
  const LauncherPage({super.key});

  @override
  State<LauncherPage> createState() => _LauncherPageState();
}

class _LauncherPageState extends State<LauncherPage> {
  late final TextEditingController _searchController;
  int _currentTabIndex = 0;

  @override
  void initState() {
    super.initState();
    _searchController = TextEditingController();
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  void _navigateToModule(BuildContext context, UtilityModule module) {
    Widget destinationPage;
    switch (module.id) {
      case 'subscription_tracker':
        destinationPage = BlocProvider<SubscriptionBloc>(
          create: (_) => di.sl<SubscriptionBloc>(),
          child: const SubscriptionPage(),
        );
        break;
      case 'price_calculator':
        destinationPage = BlocProvider<PriceCalculatorCubit>(
          create: (_) => di.sl<PriceCalculatorCubit>(),
          child: const PriceCalculatorPage(),
        );
        break;
      case 'pantry_expiry':
        destinationPage = BlocProvider<PantryBloc>(
          create: (_) => di.sl<PantryBloc>(),
          child: const PantryExpiryPage(),
        );
        break;
      case 'expense_tracker':
      case 'image_compressor':
        destinationPage = BlocProvider<ExpenseBloc>(
          create: (_) => di.sl<ExpenseBloc>(),
          child: const ExpenseTrackerPage(),
        );
        break;
      case 'micro_budgeter':
        destinationPage = BlocProvider<BudgetBloc>(
          create: (_) => di.sl<BudgetBloc>(),
          child: const MicroBudgeterPage(),
        );
        break;
      case 'interval_timer':
        destinationPage = BlocProvider<IntervalTimerBloc>(
          create: (_) => di.sl<IntervalTimerBloc>(),
          child: const IntervalTimerPage(),
        );
        break;
      default:
        destinationPage = BlocProvider<SubscriptionBloc>(
          create: (_) => di.sl<SubscriptionBloc>(),
          child: const SubscriptionPage(),
        );
    }

    Navigator.of(context).push(
      MaterialPageRoute(builder: (_) => destinationPage),
    );
  }

  void _showModuleInfoDialog(BuildContext context, UtilityModule module) {
    final l10n = context.l10n;
    final title = l10n.getModuleTitle(module.id);
    final desc = l10n.getModuleDescription(module.id);

    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        backgroundColor: AppColors.surfaceCard,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(24),
          side: const BorderSide(color: AppColors.cardBorder),
        ),
        titlePadding: const EdgeInsets.fromLTRB(22, 20, 22, 10),
        contentPadding: const EdgeInsets.symmetric(horizontal: 22, vertical: 10),
        actionsPadding: const EdgeInsets.fromLTRB(22, 12, 22, 20),
        title: Row(
          children: [
            Container(
              width: 38,
              height: 38,
              decoration: BoxDecoration(
                color: module.accentColor.withAlpha(30),
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: module.accentColor.withAlpha(80)),
              ),
              child: Icon(module.icon, color: module.accentColor, size: 20),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Text(
                title.isNotEmpty ? title : module.title,
                style: AppTypography.headlineMedium.copyWith(fontSize: 18),
              ),
            ),
          ],
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              desc.isNotEmpty ? desc : module.description,
              style: AppTypography.bodyMedium.copyWith(
                color: AppColors.textSecondary,
                fontSize: 13.5,
                height: 1.45,
              ),
            ),
          ],
        ),
        actions: [
          Row(
            children: [
              Expanded(
                child: TextButton(
                  onPressed: () => Navigator.of(ctx).pop(),
                  child: Text(l10n.cancel, style: const TextStyle(color: AppColors.textMuted)),
                ),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: module.accentColor,
                    foregroundColor: Colors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  onPressed: () {
                    Navigator.of(ctx).pop();
                    _navigateToModule(context, module);
                  },
                  child: Text(l10n.open),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: IndexedStack(
        index: _currentTabIndex,
        children: [
          _buildHomeDashboard(context),
          const SettingsPage(),
        ],
      ),
      bottomNavigationBar: SafeArea(
        top: false,
        child: CurvedNotchBottomNavBar(
          currentIndex: _currentTabIndex,
          onTap: (index) {
            setState(() {
              _currentTabIndex = index;
            });
          },
          items: const [
            CurvedNavItem(
              icon: Icons.home_outlined,
              selectedIcon: Icons.home_rounded,
            ),
            CurvedNavItem(
              icon: Icons.settings_outlined,
              selectedIcon: Icons.settings_rounded,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildHomeDashboard(BuildContext context) {
    final l10n = context.l10n;

    return Scaffold(
      appBar: CustomAppBar(
        title: l10n.appTitle,
        subtitle: l10n.appSubtitle,
        accentColor: AppColors.primary,
      ),
      body: BlocBuilder<LauncherCubit, LauncherState>(
        builder: (context, state) {
          final cubit = context.read<LauncherCubit>();

          return CustomScrollView(
            physics: const BouncingScrollPhysics(),
            slivers: [
              SliverPadding(
                padding: const EdgeInsets.fromLTRB(16, 12, 16, 6),
                sliver: SliverToBoxAdapter(
                  child: SearchFilterBar(
                    controller: _searchController,
                    searchQuery: state.searchQuery,
                    selectedCategory: state.selectedCategory,
                    onSearchChanged: cubit.updateSearchQuery,
                    onCategorySelected: cubit.selectCategory,
                  ),
                ),
              ),
              if (state.filteredModules.isEmpty)
                SliverFillRemaining(
                  hasScrollBody: false,
                  child: Center(
                    child: Padding(
                      padding: const EdgeInsets.all(24),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(
                            Icons.search_off_rounded,
                            size: 64,
                            color: AppColors.textMuted.withAlpha(120),
                          ),
                          const SizedBox(height: 16),
                          Text(
                            l10n.noUtilityFound,
                            style: AppTypography.headlineMedium,
                          ),
                          const SizedBox(height: 6),
                          Text(
                            l10n.searchHint,
                            style: AppTypography.bodyMedium.copyWith(color: AppColors.textMuted),
                            textAlign: TextAlign.center,
                          ),
                          const SizedBox(height: 16),
                          ElevatedButton.icon(
                            style: ElevatedButton.styleFrom(
                              backgroundColor: AppColors.primary,
                              foregroundColor: Colors.white,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12),
                              ),
                            ),
                            onPressed: () {
                              _searchController.clear();
                              cubit.resetFilters();
                            },
                            icon: const Icon(Icons.refresh_rounded, size: 18),
                            label: Text(l10n.resetFilters),
                          ),
                        ],
                      ),
                    ),
                  ),
                )
              else
                SliverPadding(
                  padding: const EdgeInsets.fromLTRB(16, 4, 16, 24),
                  sliver: SliverToBoxAdapter(
                    child: ResponsiveLayout(
                      builder: (context, crossAxisCount) {
                        return GridView.builder(
                          shrinkWrap: true,
                          physics: const NeverScrollableScrollPhysics(),
                          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                            crossAxisCount: crossAxisCount,
                            crossAxisSpacing: 10,
                            mainAxisSpacing: 10,
                            childAspectRatio: crossAxisCount == 2 ? 1.38 : 1.62,
                          ),
                          itemCount: state.filteredModules.length,
                          itemBuilder: (context, index) {
                            final module = state.filteredModules[index];
                            return ArcadeModuleCard(
                              module: module,
                              onTap: () => _navigateToModule(context, module),
                              onInfoTap: () => _showModuleInfoDialog(context, module),
                            );
                          },
                        );
                      },
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
