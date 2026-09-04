import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:dailypouch/core/currency/currency_cubit.dart';
import 'package:dailypouch/core/currency/currency_entity.dart';
import 'package:dailypouch/core/currency/searchable_currency_picker.dart';
import 'package:dailypouch/core/di/injection_container.dart' as di;
import 'package:dailypouch/core/localization/app_language.dart';
import 'package:dailypouch/core/localization/app_localizations.dart';
import 'package:dailypouch/core/localization/locale_cubit.dart';
import 'package:dailypouch/core/localization/searchable_language_picker.dart';
import 'package:dailypouch/core/theme/app_colors.dart';
import 'package:dailypouch/core/theme/app_typography.dart';
import 'package:dailypouch/core/widgets/custom_app_bar.dart';
import 'package:dailypouch/core/widgets/responsive_layout.dart';
import 'package:dailypouch/features/image_compressor/presentation/bloc/image_compressor_bloc.dart';
import 'package:dailypouch/features/image_compressor/presentation/pages/image_compressor_page.dart';
import 'package:dailypouch/features/interval_timer/presentation/bloc/interval_timer_bloc.dart';
import 'package:dailypouch/features/interval_timer/presentation/pages/interval_timer_page.dart';
import 'package:dailypouch/features/micro_budgeter/presentation/bloc/budget_bloc.dart';
import 'package:dailypouch/features/micro_budgeter/presentation/pages/micro_budgeter_page.dart';
import 'package:dailypouch/features/pantry_expiry/presentation/bloc/pantry_bloc.dart';
import 'package:dailypouch/features/pantry_expiry/presentation/pages/pantry_expiry_page.dart';
import 'package:dailypouch/features/price_calculator/presentation/cubit/price_calculator_cubit.dart';
import 'package:dailypouch/features/price_calculator/presentation/pages/price_calculator_page.dart';
import 'package:dailypouch/features/subscription_tracker/presentation/bloc/subscription_bloc.dart';
import 'package:dailypouch/features/subscription_tracker/presentation/pages/subscription_page.dart';
import '../../domain/entities/utility_module.dart';
import '../cubit/launcher_cubit.dart';
import '../cubit/launcher_state.dart';
import '../widgets/arcade_module_card.dart';
import '../widgets/search_filter_bar.dart';

class LauncherPage extends StatefulWidget {
  const LauncherPage({super.key});

  @override
  State<LauncherPage> createState() => _LauncherPageState();
}

class _LauncherPageState extends State<LauncherPage> {
  late final TextEditingController _searchController;

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
      case 'image_compressor':
        destinationPage = BlocProvider<ImageCompressorBloc>(
          create: (_) => di.sl<ImageCompressorBloc>(),
          child: const ImageCompressorPage(),
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
    final l10n = context.l10n;

    return Scaffold(
      appBar: CustomAppBar(
        title: l10n.appTitle,
        subtitle: l10n.appSubtitle,
        accentColor: AppColors.primary,
        actions: [
          IconButton(
            tooltip: l10n.settingsAndAbout,
            icon: const Icon(Icons.settings_outlined, color: AppColors.textSecondary),
            onPressed: () => _showSettingsDialog(context),
          ),
          const SizedBox(width: 8),
        ],
      ),
      body: BlocBuilder<LauncherCubit, LauncherState>(
        builder: (context, state) {
          final cubit = context.read<LauncherCubit>();

          return CustomScrollView(
            physics: const BouncingScrollPhysics(),
            slivers: [
              SliverPadding(
                padding: const EdgeInsets.fromLTRB(16, 16, 16, 8),
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
                  padding: const EdgeInsets.fromLTRB(16, 8, 16, 32),
                  sliver: SliverToBoxAdapter(
                    child: ResponsiveLayout(
                      builder: (context, crossAxisCount) {
                        return GridView.builder(
                          shrinkWrap: true,
                          physics: const NeverScrollableScrollPhysics(),
                          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                            crossAxisCount: crossAxisCount,
                            crossAxisSpacing: 12,
                            mainAxisSpacing: 12,
                            childAspectRatio: crossAxisCount == 2 ? 0.76 : 1.05,
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

  void _showSettingsDialog(BuildContext context) {
    final l10n = context.l10n;

    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        backgroundColor: AppColors.surfaceCard,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(24),
          side: const BorderSide(color: AppColors.cardBorder, width: 1),
        ),
        titlePadding: const EdgeInsets.fromLTRB(22, 20, 22, 10),
        contentPadding: const EdgeInsets.symmetric(horizontal: 22, vertical: 10),
        actionsPadding: const EdgeInsets.fromLTRB(22, 12, 22, 20),
        title: Row(
          children: [
            Container(
              width: 42,
              height: 42,
              decoration: BoxDecoration(
                gradient: AppColors.primaryGradient,
                borderRadius: BorderRadius.circular(13),
                boxShadow: [
                  BoxShadow(
                    color: AppColors.primary.withAlpha(80),
                    blurRadius: 12,
                    offset: const Offset(0, 3),
                  ),
                ],
              ),
              child: const Icon(Icons.settings_rounded, color: Colors.white, size: 22),
            ),
            const SizedBox(width: 14),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    l10n.settingsAndAbout,
                    style: AppTypography.headlineMedium.copyWith(
                      fontSize: 19,
                      fontWeight: FontWeight.w800,
                    ),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    l10n.preferences,
                    style: AppTypography.labelSmall.copyWith(
                      color: AppColors.primary,
                      fontWeight: FontWeight.w600,
                      letterSpacing: 0.2,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
        content: SizedBox(
          width: double.maxFinite,
          child: SingleChildScrollView(
            physics: const BouncingScrollPhysics(),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // -------------------------------------------------------------
                // SECTION 1: CENTRAL CURRENCY SETTING
                // -------------------------------------------------------------
                Row(
                  children: [
                    const Icon(Icons.payments_outlined, size: 16, color: AppColors.primaryLight),
                    const SizedBox(width: 6),
                    Text(
                      l10n.centralCurrency,
                      style: AppTypography.badgeText.copyWith(
                        color: AppColors.primaryLight,
                        fontSize: 10,
                        fontWeight: FontWeight.w800,
                        letterSpacing: 0.8,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 6),
                Text(
                  l10n.centralCurrencyDesc,
                  style: AppTypography.bodyMedium.copyWith(
                    color: AppColors.textMuted,
                    fontSize: 12,
                    height: 1.4,
                  ),
                ),
                const SizedBox(height: 10),

                // Searchable Currency Picker Dropdown Field
                BlocBuilder<CurrencyCubit, AppCurrency>(
                  bloc: di.sl<CurrencyCubit>(),
                  builder: (context, currentCurrency) {
                    return CurrencyPickerField(
                      selected: currentCurrency,
                      onSelected: (picked) {
                        di.sl<CurrencyCubit>().setCurrency(picked);
                      },
                    );
                  },
                ),

                const SizedBox(height: 20),

                // -------------------------------------------------------------
                // SECTION 2: APP LANGUAGE SETTING
                // -------------------------------------------------------------
                Row(
                  children: [
                    const Icon(Icons.language_rounded, size: 16, color: AppColors.moduleCompressor),
                    const SizedBox(width: 6),
                    Text(
                      l10n.appLanguageLabel,
                      style: AppTypography.badgeText.copyWith(
                        color: AppColors.moduleCompressor,
                        fontSize: 10,
                        fontWeight: FontWeight.w800,
                        letterSpacing: 0.8,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 6),
                Text(
                  l10n.appLanguageDesc,
                  style: AppTypography.bodyMedium.copyWith(
                    color: AppColors.textMuted,
                    fontSize: 12,
                    height: 1.4,
                  ),
                ),
                const SizedBox(height: 10),

                // Searchable Language Picker Dropdown Field
                BlocBuilder<LocaleCubit, AppLanguage>(
                  bloc: di.sl<LocaleCubit>(),
                  builder: (context, currentLang) {
                    return LanguagePickerField(
                      selected: currentLang,
                      onSelected: (picked) {
                        di.sl<LocaleCubit>().setLanguage(picked);
                      },
                    );
                  },
                ),

                const SizedBox(height: 24),
                const Divider(color: AppColors.cardBorder, height: 1),
                const SizedBox(height: 20),

                // -------------------------------------------------------------
                // SECTION 3: ABOUT THE APP & FEATURES
                // -------------------------------------------------------------
                Row(
                  children: [
                    const Icon(Icons.info_outline_rounded, size: 16, color: AppColors.primary),
                    const SizedBox(width: 6),
                    Text(
                      l10n.aboutTheApp,
                      style: AppTypography.badgeText.copyWith(
                        color: AppColors.primary,
                        fontSize: 10,
                        fontWeight: FontWeight.w800,
                        letterSpacing: 0.8,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                Text(
                  l10n.aboutAppDesc,
                  style: AppTypography.bodyMedium.copyWith(
                    fontSize: 13,
                    color: AppColors.textSecondary,
                    height: 1.45,
                  ),
                ),
                const SizedBox(height: 16),

                _buildInfoFeatureCard(
                  icon: Icons.auto_awesome_motion_rounded,
                  color: AppColors.moduleSubscription,
                  gradient: AppColors.subscriptionGradient,
                  tag: l10n.categoryFinance.toUpperCase(),
                  title: l10n.subTrackerTitle,
                  description:
                      'Track recurring software, streaming, and utility bills. See your total monthly and annual cash burn at a glance, with live countdowns to upcoming renewal dates, paid/unpaid tracking, and instant alerts.',
                ),
                const SizedBox(height: 12),
                _buildInfoFeatureCard(
                  icon: Icons.calculate_rounded,
                  color: AppColors.modulePriceCalc,
                  gradient: AppColors.priceCalcGradient,
                  tag: 'GROCERY & SHOPPING',
                  title: l10n.priceCalcTitle,
                  description:
                      'Spot true grocery savings in supermarket aisles. Compare 2 or more products across mixed units (grams vs. kg, ml vs. liters, or count per pack) to instantly identify the best deal.',
                ),
                const SizedBox(height: 12),
                _buildInfoFeatureCard(
                  icon: Icons.inventory_2_rounded,
                  color: AppColors.modulePantry,
                  gradient: AppColors.pantryGradient,
                  tag: 'PANTRY & MEDICINE',
                  title: l10n.pantryTitle,
                  description:
                      'Prevent food spoilage and manage household medicine safety. Organize items across 4 storage zones (Fridge, Freezer, Pantry, Medicine Cabinet) with automated freshness status badges.',
                ),
                const SizedBox(height: 12),
                _buildInfoFeatureCard(
                  icon: Icons.photo_size_select_small_rounded,
                  color: AppColors.moduleCompressor,
                  gradient: AppColors.compressorGradient,
                  tag: 'IMAGE & PDF TOOLS',
                  title: l10n.compressorTitle,
                  description:
                      'Quickly prepare uploads for strict portal limits. Compress photos down to exact target KB sizes, auto-crop standard 2x2 passport/ID photos, and compile multiple images into PDF.',
                ),
                const SizedBox(height: 12),
                _buildInfoFeatureCard(
                  icon: Icons.account_balance_wallet_rounded,
                  color: AppColors.moduleBudgeter,
                  gradient: AppColors.budgeterGradient,
                  tag: 'SAVINGS & BUDGETING',
                  title: l10n.budgeterTitle,
                  description:
                      'Keep personal spending in check without complicated accounting. Create focused spending envelopes with an automatic daily runway gauge and log expenses on the go.',
                ),
                const SizedBox(height: 12),
                _buildInfoFeatureCard(
                  icon: Icons.timer_rounded,
                  color: AppColors.moduleTimer,
                  gradient: AppColors.timerGradient,
                  tag: 'FITNESS & WORKOUT',
                  title: l10n.timerTitle,
                  description:
                      'Pace your workouts, Tabata, HIIT sets, boxing rounds, and stretching routines. Includes audio chime cues, routine presets, and screen wakelock.',
                ),
              ],
            ),
          ),
        ),
        actions: [
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.primary,
                foregroundColor: Colors.white,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(14),
                ),
                padding: const EdgeInsets.symmetric(vertical: 14),
                elevation: 0,
              ),
              onPressed: () => Navigator.of(ctx).pop(),
              child: Text(
                l10n.done,
                style: const TextStyle(
                  fontWeight: FontWeight.w700,
                  fontSize: 14.5,
                  letterSpacing: 0.3,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildInfoFeatureCard({
    required IconData icon,
    required Color color,
    required LinearGradient gradient,
    required String tag,
    required String title,
    required String description,
  }) {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: AppColors.surfaceElevated,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: color.withAlpha(45), width: 1),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                width: 36,
                height: 36,
                decoration: BoxDecoration(
                  gradient: gradient,
                  borderRadius: BorderRadius.circular(10),
                  boxShadow: [
                    BoxShadow(
                      color: color.withAlpha(60),
                      blurRadius: 8,
                      offset: const Offset(0, 2),
                    ),
                  ],
                ),
                child: Icon(icon, color: Colors.white, size: 18),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      tag,
                      style: AppTypography.badgeText.copyWith(
                        color: color,
                        fontSize: 9,
                        fontWeight: FontWeight.w800,
                        letterSpacing: 0.7,
                      ),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      title,
                      style: AppTypography.titleMedium.copyWith(
                        fontSize: 14,
                        fontWeight: FontWeight.w700,
                        color: AppColors.textPrimary,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 10),
          Text(
            description,
            style: AppTypography.bodyMedium.copyWith(
              fontSize: 12,
              color: AppColors.textMuted,
              height: 1.42,
            ),
          ),
        ],
      ),
    );
  }
}
