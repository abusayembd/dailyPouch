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
import 'about_app_page.dart';

class SettingsPage extends StatelessWidget {
  const SettingsPage({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;

    return Scaffold(
      appBar: CustomAppBar(
        title: l10n.tabSettings,
        accentColor: AppColors.primary,
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
            const SizedBox(height: 16),

            // -------------------------------------------------------------
            // PREFERENCES (CURRENCY & LANGUAGE)
            // -------------------------------------------------------------
            _buildPreferenceCard(
              icon: Icons.payments_outlined,
              iconColor: AppColors.primaryLight,
              title: l10n.centralCurrency,
              description: l10n.centralCurrencyDesc,
              child: BlocBuilder<CurrencyCubit, AppCurrency>(
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
            ),
            const SizedBox(height: 12),

            _buildPreferenceCard(
              icon: Icons.language_rounded,
              iconColor: AppColors.moduleCompressor,
              title: l10n.appLanguageLabel,
              description: l10n.appLanguageDesc,
              child: BlocBuilder<LocaleCubit, AppLanguage>(
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
            ),
            const SizedBox(height: 14),

            // -------------------------------------------------------------
            // DEDICATED ABOUT APP NAVIGATION TILE
            // -------------------------------------------------------------
            _buildNavigationTile(
              context: context,
              icon: Icons.auto_stories_rounded,
              iconColor: AppColors.modulePriceCalc,
              iconGradient: AppColors.priceCalcGradient,
              title: l10n.aboutTheApp,
              subtitle: l10n.aboutAppSubtitle,
              onTap: () {
                Navigator.of(context).push(
                  MaterialPageRoute(builder: (_) => const AboutAppPage()),
                );
              },
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
              gradient: AppColors.primaryGradient,
              borderRadius: BorderRadius.circular(16),
              boxShadow: [
                BoxShadow(
                  color: AppColors.primary.withAlpha(90),
                  blurRadius: 14,
                  offset: const Offset(0, 4),
                ),
              ],
            ),
            child: const Icon(
              Icons.all_inbox_rounded,
              color: Colors.white,
              size: 28,
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

  Widget _buildPreferenceCard({
    required IconData icon,
    required Color iconColor,
    required String title,
    required String description,
    required Widget child,
  }) {
    return Container(
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
              Icon(icon, size: 15, color: iconColor),
              const SizedBox(width: 6),
              Text(
                title,
                style: AppTypography.badgeText.copyWith(
                  color: iconColor,
                  fontSize: 10,
                  fontWeight: FontWeight.w800,
                  letterSpacing: 0.6,
                ),
              ),
            ],
          ),
          const SizedBox(height: 6),
          Text(
            description,
            style: AppTypography.bodyMedium.copyWith(
              color: AppColors.textMuted,
              fontSize: 12,
              height: 1.35,
            ),
          ),
          const SizedBox(height: 12),
          child,
        ],
      ),
    );
  }

  Widget _buildNavigationTile({
    required BuildContext context,
    required IconData icon,
    required Color iconColor,
    required LinearGradient iconGradient,
    required String title,
    required String subtitle,
    required VoidCallback onTap,
  }) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(16),
        child: Container(
          width: double.infinity,
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: AppColors.surfaceCard,
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: AppColors.cardBorder, width: 1),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withAlpha(10),
                blurRadius: 8,
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
                  gradient: iconGradient,
                  borderRadius: BorderRadius.circular(12),
                  boxShadow: [
                    BoxShadow(
                      color: iconColor.withAlpha(60),
                      blurRadius: 8,
                      offset: const Offset(0, 2),
                    ),
                  ],
                ),
                child: Icon(icon, color: Colors.white, size: 20),
              ),
              const SizedBox(width: 14),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: AppTypography.headlineMedium.copyWith(
                        fontSize: 14.5,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      subtitle,
                      style: AppTypography.bodyMedium.copyWith(
                        color: AppColors.textMuted,
                        fontSize: 12,
                      ),
                    ),
                  ],
                ),
              ),
              const Icon(
                Icons.chevron_right_rounded,
                color: AppColors.textMuted,
                size: 22,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
