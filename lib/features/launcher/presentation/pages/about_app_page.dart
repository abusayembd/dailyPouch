import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:dailypouch/core/localization/app_localizations.dart';
import 'package:dailypouch/core/theme/app_colors.dart';
import 'package:dailypouch/core/theme/app_typography.dart';
import 'package:dailypouch/core/widgets/custom_app_bar.dart';

class AboutAppPage extends StatelessWidget {
  const AboutAppPage({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;

    return Scaffold(
      appBar: CustomAppBar(
        title: l10n.aboutTheApp,
        subtitle: '${l10n.appTitle}: ${l10n.appSubtitle}',
        accentColor: AppColors.modulePriceCalc,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new_rounded),
          onPressed: () => Navigator.of(context).pop(),
        ),
      ),
      body: SingleChildScrollView(
        physics: const BouncingScrollPhysics(),
        padding: const EdgeInsets.fromLTRB(16, 16, 16, 40),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // -------------------------------------------------------------
            // HERO APP BRAND CARD
            // -------------------------------------------------------------
            _buildAppBrandCard(context),
            const SizedBox(height: 20),

            // -------------------------------------------------------------
            // APP CONCEPT & OVERVIEW CARD
            // -------------------------------------------------------------
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: AppColors.surfaceCard,
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: AppColors.cardBorder, width: 1),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      const Icon(Icons.info_outline_rounded, size: 16, color: AppColors.primary),
                      const SizedBox(width: 6),
                      Text(
                        l10n.aboutTheApp,
                        style: AppTypography.badgeText.copyWith(
                          color: AppColors.primary,
                          fontSize: 10.5,
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
                      fontSize: 13.5,
                      color: AppColors.textSecondary,
                      height: 1.5,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 24),

            // -------------------------------------------------------------
            // 6 OFFLINE TOOLS SHOWCASE
            // -------------------------------------------------------------
            Row(
              children: [
                const Icon(Icons.apps_rounded, size: 16, color: AppColors.moduleSubscription),
                const SizedBox(width: 6),
                Text(
                  '6 OFFLINE LIFE TOOLS',
                  style: AppTypography.badgeText.copyWith(
                    color: AppColors.moduleSubscription,
                    fontSize: 11,
                    fontWeight: FontWeight.w800,
                    letterSpacing: 0.8,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),

            _buildFeatureCard(
              icon: Icons.auto_awesome_motion_rounded,
              color: AppColors.moduleSubscription,
              gradient: AppColors.subscriptionGradient,
              tag: l10n.categoryFinance.toUpperCase(),
              title: l10n.subTrackerTitle,
              description:
                  'Track recurring software, streaming, and utility bills. See your total monthly and annual cash burn at a glance, with live countdowns to upcoming renewal dates, paid/unpaid tracking, and instant alerts.',
            ),
            const SizedBox(height: 10),

            _buildFeatureCard(
              icon: Icons.calculate_rounded,
              color: AppColors.modulePriceCalc,
              gradient: AppColors.priceCalcGradient,
              tag: 'GROCERY & SHOPPING',
              title: l10n.priceCalcTitle,
              description:
                  'Spot true grocery savings in supermarket aisles. Compare 2 or more products across mixed units (grams vs. kg, ml vs. liters, or count per pack) to instantly identify the best deal.',
            ),
            const SizedBox(height: 10),

            _buildFeatureCard(
              icon: Icons.inventory_2_rounded,
              color: AppColors.modulePantry,
              gradient: AppColors.pantryGradient,
              tag: 'PANTRY & MEDICINE',
              title: l10n.pantryTitle,
              description:
                  'Prevent food spoilage and manage household medicine safety. Organize items across 4 storage zones (Fridge, Freezer, Pantry, Medicine Cabinet) with automated freshness status badges.',
            ),
            const SizedBox(height: 10),

            _buildFeatureCard(
              icon: Icons.account_balance_wallet_rounded,
              color: AppColors.moduleExpenseTracker,
              gradient: AppColors.expenseTrackerGradient,
              tag: 'EXPENSE & CASH FLOW',
              title: l10n.getModuleTitle('expense_tracker'),
              description:
                  'All-in-one personal money manager. Log daily income and expenses across categories, monitor net cash flow, track your savings rate progress, and analyze spending breakdowns offline.',
            ),
            const SizedBox(height: 10),

            _buildFeatureCard(
              icon: Icons.account_balance_wallet_rounded,
              color: AppColors.moduleBudgeter,
              gradient: AppColors.budgeterGradient,
              tag: 'SAVINGS & BUDGETING',
              title: l10n.budgeterTitle,
              description:
                  'Keep personal spending in check without complicated accounting. Create focused spending envelopes with an automatic daily runway gauge and log expenses on the go.',
            ),
            const SizedBox(height: 10),

            _buildFeatureCard(
              icon: Icons.timer_rounded,
              color: AppColors.moduleTimer,
              gradient: AppColors.timerGradient,
              tag: 'FITNESS & WORKOUT',
              title: l10n.timerTitle,
              description:
                  'Pace your workouts, Tabata, HIIT sets, boxing rounds, and stretching routines. Includes audio chime cues, routine presets, and screen wakelock.',
            ),
            const SizedBox(height: 20),

            // -------------------------------------------------------------
            // PRIVACY POLICY & TRUST BANNER
            // -------------------------------------------------------------
            InkWell(
              borderRadius: BorderRadius.circular(16),
              onTap: () async {
                final uri = Uri.parse('https://abusayembd.github.io/dailyPouch/privacy_policy/');
                if (await canLaunchUrl(uri)) {
                  await launchUrl(uri, mode: LaunchMode.externalApplication);
                }
              },
              child: Container(
                width: double.infinity,
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: AppColors.surfaceCard,
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(color: AppColors.cardBorder, width: 1),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withAlpha(8),
                      blurRadius: 10,
                      offset: const Offset(0, 2),
                    ),
                  ],
                ),
                child: Row(
                  children: [
                    Container(
                      width: 40,
                      height: 40,
                      decoration: BoxDecoration(
                        gradient: AppColors.budgeterGradient,
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: const Icon(Icons.shield_outlined, color: Colors.white, size: 20),
                    ),
                    const SizedBox(width: 14),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            l10n.privacyPolicy,
                            style: AppTypography.headlineMedium.copyWith(
                              fontSize: 14,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                          const SizedBox(height: 2),
                          Text(
                            l10n.privacyPolicySubtitle,
                            style: AppTypography.bodyMedium.copyWith(
                              color: AppColors.textMuted,
                              fontSize: 11.5,
                            ),
                          ),
                        ],
                      ),
                    ),
                    const Icon(
                      Icons.open_in_new_rounded,
                      color: AppColors.textMuted,
                      size: 18,
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildAppBrandCard(BuildContext context) {
    final l10n = context.l10n;

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: AppColors.surfaceCard,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: AppColors.cardBorder, width: 1.2),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withAlpha(15),
            blurRadius: 12,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Row(
        children: [
          Container(
            width: 52,
            height: 52,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(16),
              boxShadow: [
                BoxShadow(
                  color: AppColors.primary.withAlpha(40),
                  blurRadius: 12,
                  offset: const Offset(0, 4),
                ),
              ],
            ),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(16),
              child: Image.asset(
                'assets/icons/daily_pouch.png',
                fit: BoxFit.cover,
              ),
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Text(
                      l10n.appTitle,
                      style: AppTypography.headlineMedium.copyWith(
                        fontSize: 20,
                        fontWeight: FontWeight.w900,
                        letterSpacing: -0.3,
                      ),
                    ),
                    const SizedBox(width: 8),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 7, vertical: 2),
                      decoration: BoxDecoration(
                        color: AppColors.modulePantry.withAlpha(25),
                        borderRadius: BorderRadius.circular(6),
                        border: Border.all(
                          color: AppColors.modulePantry.withAlpha(80),
                          width: 1,
                        ),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Container(
                            width: 5,
                            height: 5,
                            decoration: const BoxDecoration(
                              color: AppColors.modulePantry,
                              shape: BoxShape.circle,
                            ),
                          ),
                          const SizedBox(width: 4),
                          Text(
                            'v1.0.0',
                            style: AppTypography.badgeText.copyWith(
                              color: AppColors.modulePantry,
                              fontSize: 9,
                              fontWeight: FontWeight.w800,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 3),
                Text(
                  l10n.appSubtitle,
                  style: AppTypography.bodyMedium.copyWith(
                    color: AppColors.textSecondary,
                    fontSize: 12.5,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFeatureCard({
    required IconData icon,
    required Color color,
    required LinearGradient gradient,
    required String tag,
    required String title,
    required String description,
  }) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: AppColors.surfaceCard,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(
          color: color.withAlpha(50),
          width: 1,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                width: 28,
                height: 28,
                decoration: BoxDecoration(
                  gradient: gradient,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Icon(icon, color: Colors.white, size: 16),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: Text(
                  title,
                  style: AppTypography.headlineMedium.copyWith(
                    fontSize: 14.5,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                decoration: BoxDecoration(
                  color: color.withAlpha(25),
                  borderRadius: BorderRadius.circular(6),
                ),
                child: Text(
                  tag,
                  style: AppTypography.badgeText.copyWith(
                    color: color,
                    fontSize: 8.5,
                    fontWeight: FontWeight.w800,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Text(
            description,
            style: AppTypography.bodyMedium.copyWith(
              fontSize: 12,
              color: AppColors.textMuted,
              height: 1.4,
            ),
          ),
        ],
      ),
    );
  }
}
