import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../core/currency/currency_cubit.dart';
import '../../../../core/localization/app_localizations.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_typography.dart';
import '../../../../core/widgets/custom_app_bar.dart';
import '../../domain/entities/subscription_entity.dart';
import '../bloc/subscription_bloc.dart';
import '../bloc/subscription_event.dart';
import '../bloc/subscription_state.dart';
import '../widgets/add_edit_subscription_dialog.dart';
import '../widgets/burn_rate_card.dart';
import '../widgets/subscription_tile.dart';

class SubscriptionPage extends StatefulWidget {
  const SubscriptionPage({super.key});

  @override
  State<SubscriptionPage> createState() => _SubscriptionPageState();
}

class _SubscriptionPageState extends State<SubscriptionPage> {
  @override
  void initState() {
    super.initState();
    context.read<SubscriptionBloc>().add(const LoadSubscriptionsEvent());
  }

  void _openAddSubscriptionDialog(BuildContext context) async {
    final bloc = context.read<SubscriptionBloc>();
    final result = await showDialog<SubscriptionEntity>(
      context: context,
      builder: (_) => const AddEditSubscriptionDialog(),
    );

    if (result != null) {
      bloc.add(AddSubscriptionEvent(result));
    }
  }

  void _openEditSubscriptionDialog(
    BuildContext context,
    SubscriptionEntity item,
  ) async {
    final bloc = context.read<SubscriptionBloc>();
    final result = await showDialog<SubscriptionEntity>(
      context: context,
      builder: (_) => AddEditSubscriptionDialog(initial: item),
    );

    if (result != null) {
      bloc.add(UpdateSubscriptionEvent(result));
    }
  }

  @override
  Widget build(BuildContext context) {
    final activeCurrency = context.watch<CurrencyCubit>().state;
    final l10n = context.l10n;

    return Scaffold(
      appBar: CustomAppBar(
        title: l10n.subTrackerTitle,
        subtitle: l10n.subTrackerSubtitle,
        accentColor: AppColors.moduleSubscription,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new_rounded),
          onPressed: () => Navigator.of(context).pop(),
        ),
        actions: [
          IconButton(
            tooltip: l10n.addSubscription,
            icon: const Icon(
              Icons.add_circle_outline_rounded,
              color: AppColors.moduleSubscription,
            ),
            onPressed: () => _openAddSubscriptionDialog(context),
          ),
          const SizedBox(width: 8),
        ],
      ),
      floatingActionButton: FloatingActionButton.extended(
        backgroundColor: AppColors.moduleSubscription,
        foregroundColor: Colors.white,
        icon: const Icon(Icons.add_rounded),
        label: Text(l10n.addBill),
        onPressed: () => _openAddSubscriptionDialog(context),
      ),
      body: BlocConsumer<SubscriptionBloc, SubscriptionState>(
        listener: (context, state) {
          if (state is SubscriptionLoaded && state.message != null) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(state.message!),
                backgroundColor: AppColors.surfaceElevated,
                behavior: SnackBarBehavior.floating,
                duration: const Duration(seconds: 2),
              ),
            );
          } else if (state is SubscriptionError) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(state.message),
                backgroundColor: AppColors.error,
                behavior: SnackBarBehavior.floating,
              ),
            );
          }
        },
        builder: (context, state) {
          if (state is SubscriptionLoading) {
            return const Center(
              child: CircularProgressIndicator(
                color: AppColors.moduleSubscription,
              ),
            );
          }

          if (state is SubscriptionLoaded) {
            final subscriptions = state.subscriptions;

            return CustomScrollView(
              physics: const BouncingScrollPhysics(),
              slivers: [
                SliverPadding(
                  padding: const EdgeInsets.all(16),
                  sliver: SliverToBoxAdapter(
                    child: BurnRateCard(
                      currencySymbol: activeCurrency.symbol,
                      monthlyBurn: state.totalMonthlyBurn,
                      yearlyBurn: state.totalYearlyBurn,
                      activeCount: state.activeCount,
                      totalCount: subscriptions.length,
                    ),
                  ),
                ),
                if (subscriptions.isEmpty)
                  SliverFillRemaining(
                    hasScrollBody: false,
                    child: Center(
                      child: Padding(
                        padding: const EdgeInsets.all(24),
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Icon(
                              Icons.receipt_long_rounded,
                              size: 64,
                              color: AppColors.textMuted.withAlpha(120),
                            ),
                            const SizedBox(height: 16),
                            Text(
                              l10n.noSubscriptionsYet,
                              style: AppTypography.headlineMedium,
                            ),
                            const SizedBox(height: 6),
                            Text(
                              l10n.subscriptionEmptySubtitle,
                              style: AppTypography.bodyMedium,
                              textAlign: TextAlign.center,
                            ),
                            const SizedBox(height: 20),
                            ElevatedButton.icon(
                              style: ElevatedButton.styleFrom(
                                backgroundColor: AppColors.moduleSubscription,
                                foregroundColor: Colors.white,
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 20,
                                  vertical: 12,
                                ),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(12),
                                ),
                              ),
                              onPressed: () =>
                                  _openAddSubscriptionDialog(context),
                              icon: const Icon(Icons.add_rounded, size: 18),
                              label: Text(l10n.addSubscription),
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
                      delegate: SliverChildBuilderDelegate((context, index) {
                        final item = subscriptions[index];
                        return SubscriptionTile(
                          subscription: item,
                          currencySymbol: activeCurrency.symbol,
                          onToggle: () {
                            context.read<SubscriptionBloc>().add(
                              ToggleSubscriptionStatusEvent(item.id),
                            );
                          },
                          onTogglePaid: () {
                            context.read<SubscriptionBloc>().add(
                              ToggleSubscriptionPaidEvent(item.id),
                            );
                          },
                          onEdit: () =>
                              _openEditSubscriptionDialog(context, item),
                          onDelete: () {
                            context.read<SubscriptionBloc>().add(
                              DeleteSubscriptionEvent(item.id),
                            );
                          },
                        );
                      }, childCount: subscriptions.length),
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
