import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../core/currency/currency_cubit.dart';
import '../../../../core/localization/app_localizations.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_typography.dart';
import '../../../../core/widgets/custom_app_bar.dart';
import '../../../../core/widgets/glass_card.dart';
import '../../domain/entities/budget_envelope_entity.dart';
import '../bloc/budget_bloc.dart';
import '../bloc/budget_event.dart';
import '../bloc/budget_state.dart';
import '../widgets/add_edit_envelope_dialog.dart';
import '../widgets/quick_log_modal.dart';
import '../widgets/runway_gauge_card.dart';

class MicroBudgeterPage extends StatefulWidget {
  const MicroBudgeterPage({super.key});

  @override
  State<MicroBudgeterPage> createState() => _MicroBudgeterPageState();
}

class _MicroBudgeterPageState extends State<MicroBudgeterPage> {
  @override
  void initState() {
    super.initState();
    context.read<BudgetBloc>().add(const LoadEnvelopesEvent());
  }

  void _openAddEnvelopeDialog(BuildContext context) async {
    final bloc = context.read<BudgetBloc>();
    final result = await showDialog<BudgetEnvelopeEntity>(
      context: context,
      builder: (_) => const AddEditEnvelopeDialog(),
    );

    if (result != null) {
      bloc.add(AddEnvelopeEvent(result));
    }
  }

  void _openQuickLogModal(
    BuildContext context,
    BudgetEnvelopeEntity envelope,
    String currencySymbol,
  ) async {
    final bloc = context.read<BudgetBloc>();
    final result = await showModalBottomSheet<ExpenseTransactionEntity>(
      context: context,
      backgroundColor: AppColors.surfaceCard,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      builder: (_) =>
          QuickLogModal(envelopeId: envelope.id, currency: currencySymbol),
    );

    if (result != null) {
      bloc.add(AddTransactionEvent(result));
    }
  }

  @override
  Widget build(BuildContext context) {
    final activeCurrency = context.watch<CurrencyCubit>().state;
    final l10n = context.l10n;

    return Scaffold(
      appBar: CustomAppBar(
        title: l10n.budgeterTitle,
        subtitle: l10n.budgeterSubtitle,
        accentColor: AppColors.moduleBudgeter,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new_rounded),
          onPressed: () => Navigator.of(context).pop(),
        ),
        actions: [
          IconButton(
            tooltip: l10n.newGoalEnvelope,
            icon: const Icon(
              Icons.add_circle_outline_rounded,
              color: AppColors.moduleBudgeter,
            ),
            onPressed: () => _openAddEnvelopeDialog(context),
          ),
          const SizedBox(width: 8),
        ],
      ),
      floatingActionButton: BlocBuilder<BudgetBloc, BudgetState>(
        builder: (context, state) {
          if (state is BudgetLoaded && state.selectedEnvelope != null) {
            return FloatingActionButton.extended(
              backgroundColor: AppColors.moduleBudgeter,
              foregroundColor: Colors.white,
              icon: const Icon(Icons.add_rounded),
              label: Text(l10n.logSpend),
              onPressed: () =>
                  _openQuickLogModal(context, state.selectedEnvelope!, activeCurrency.symbol),
            );
          }
          return const SizedBox.shrink();
        },
      ),
      body: BlocConsumer<BudgetBloc, BudgetState>(
        listener: (context, state) {
          if (state is BudgetLoaded && state.message != null) {
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
          if (state is BudgetLoading) {
            return const Center(
              child: CircularProgressIndicator(color: AppColors.moduleBudgeter),
            );
          }

          if (state is BudgetLoaded) {
            final cubit = context.read<BudgetBloc>();
            final envelopes = state.envelopes;
            final selected = state.selectedEnvelope;

            if (envelopes.isEmpty) {
              return Center(
                child: Padding(
                  padding: const EdgeInsets.all(24),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(
                        Icons.account_balance_wallet_outlined,
                        size: 64,
                        color: AppColors.textMuted.withAlpha(120),
                      ),
                      const SizedBox(height: 16),
                      Text(l10n.newGoalEnvelope, style: AppTypography.headlineMedium),
                      const SizedBox(height: 6),
                      Text(
                        l10n.noBudgetEnvelopesDesc,
                        style: AppTypography.bodyMedium.copyWith(color: AppColors.textMuted),
                        textAlign: TextAlign.center,
                      ),
                      const SizedBox(height: 20),
                      ElevatedButton.icon(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: AppColors.moduleBudgeter,
                          foregroundColor: Colors.white,
                          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                        onPressed: () => _openAddEnvelopeDialog(context),
                        icon: const Icon(Icons.add_rounded, size: 18),
                        label: Text(l10n.createBudgetEnvelope),
                      ),
                    ],
                  ),
                ),
              );
            }

            final transactions = state.transactions;
            final displayCurr = activeCurrency.symbol;

            return CustomScrollView(
              physics: const BouncingScrollPhysics(),
              slivers: [
                // Envelope Selector Horizontal Carousel
                SliverPadding(
                  padding: const EdgeInsets.fromLTRB(16, 16, 16, 8),
                  sliver: SliverToBoxAdapter(
                    child: SingleChildScrollView(
                      scrollDirection: Axis.horizontal,
                      child: Row(
                        children: envelopes.map((env) {
                          final isSelected = selected?.id == env.id;
                          final localizedEnvelopeName = l10n.getLocalizedEnvelopeName(env.name);

                          return Padding(
                            padding: const EdgeInsets.only(right: 8),
                            child: FilterChip(
                              selected: isSelected,
                              label: Text(localizedEnvelopeName),
                              labelStyle: AppTypography.labelSmall.copyWith(
                                color: isSelected ? Colors.white : AppColors.textSecondary,
                                fontWeight: isSelected ? FontWeight.w700 : FontWeight.w500,
                              ),
                              backgroundColor: AppColors.surfaceElevated,
                              selectedColor: AppColors.moduleBudgeter,
                              side: BorderSide(
                                color: isSelected ? AppColors.moduleBudgeter : AppColors.cardBorder,
                              ),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12),
                              ),
                              onSelected: (_) => cubit.add(SelectEnvelopeEvent(env.id)),
                            ),
                          );
                        }).toList(),
                      ),
                    ),
                  ),
                ),

                // Active Runway Gauge Card
                if (selected != null)
                  SliverPadding(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    sliver: SliverToBoxAdapter(
                      child: RunwayGaugeCard(
                        envelope: selected,
                        currencySymbol: displayCurr,
                      ),
                    ),
                  ),

                // Transactions Header
                SliverPadding(
                  padding: const EdgeInsets.fromLTRB(16, 16, 16, 8),
                  sliver: SliverToBoxAdapter(
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(l10n.recentLogs, style: AppTypography.headlineMedium.copyWith(fontSize: 16)),
                        Text(
                          l10n.entriesCount(transactions.length),
                          style: AppTypography.labelSmall.copyWith(color: AppColors.textMuted),
                        ),
                      ],
                    ),
                  ),
                ),

                // Transaction Logs List
                if (transactions.isEmpty)
                  SliverToBoxAdapter(
                    child: Padding(
                      padding: const EdgeInsets.all(24),
                      child: Center(
                        child: Text(
                          l10n.noSpendLogged,
                          style: AppTypography.bodyMedium.copyWith(color: AppColors.textMuted),
                        ),
                      ),
                    ),
                  )
                else
                  SliverPadding(
                    padding: const EdgeInsets.fromLTRB(16, 0, 16, 80),
                    sliver: SliverList(
                      delegate: SliverChildBuilderDelegate((context, index) {
                        final tx = transactions[index];
                        final timeStr = l10n.formatDateTime(tx.timestamp);
                        final localizedCategory = l10n.getLocalizedCategoryTag(tx.categoryTag);
                        final amountStr = l10n.formatNumber(tx.amount.toStringAsFixed(2));

                        return GlassCard(
                          margin: const EdgeInsets.only(bottom: 8),
                          borderRadius: 14,
                          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
                          child: Row(
                            children: [
                              Container(
                                padding: const EdgeInsets.all(8),
                                decoration: BoxDecoration(
                                  color: AppColors.moduleBudgeter.withAlpha(25),
                                  borderRadius: BorderRadius.circular(10),
                                ),
                                child: const Icon(
                                  Icons.receipt_long_rounded,
                                  color: AppColors.moduleBudgeter,
                                  size: 18,
                                ),
                              ),
                              const SizedBox(width: 12),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      tx.title,
                                      style: AppTypography.titleMedium.copyWith(
                                        fontSize: 14,
                                        fontWeight: FontWeight.w600,
                                      ),
                                    ),
                                    Text(
                                      '$localizedCategory • $timeStr',
                                      style: AppTypography.labelSmall.copyWith(
                                        color: AppColors.textMuted,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              Text(
                                '-$displayCurr$amountStr',
                                style: AppTypography.titleMedium.copyWith(
                                  color: AppColors.error,
                                  fontWeight: FontWeight.w700,
                                  fontSize: 14,
                                ),
                              ),
                            ],
                          ),
                        );
                      }, childCount: transactions.length),
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
}
