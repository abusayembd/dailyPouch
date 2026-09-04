import 'package:flutter/material.dart';
import '../../../../core/localization/app_localizations.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_typography.dart';
import '../bloc/interval_timer_state.dart';

class TimerCountdownGauge extends StatelessWidget {
  final IntervalTimerState state;

  const TimerCountdownGauge({super.key, required this.state});

  Color _getPhaseColor(TimerPhase phase) {
    switch (phase) {
      case TimerPhase.prepare:
        return AppColors.warning;
      case TimerPhase.work:
        return AppColors.moduleTimer; // Laser Lime
      case TimerPhase.rest:
        return AppColors.primary;     // Neon Cyan
      case TimerPhase.cooldown:
        return AppColors.modulePriceCalc; // Purple
      case TimerPhase.completed:
        return AppColors.success;
      case TimerPhase.idle:
        return AppColors.moduleTimer;
    }
  }

  String _getPhaseTitle(TimerPhase phase, AppLocalizations l10n) {
    switch (phase) {
      case TimerPhase.prepare:
        return l10n.phaseGetReady;
      case TimerPhase.work:
        return l10n.phaseWorkHard;
      case TimerPhase.rest:
        return l10n.phaseRestAndBreathe;
      case TimerPhase.cooldown:
        return l10n.phaseCoolDown;
      case TimerPhase.completed:
        return l10n.phaseWorkoutCompleted;
      case TimerPhase.idle:
        return l10n.phaseReady;
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final phaseColor = _getPhaseColor(state.currentPhase);
    final phaseTitle = _getPhaseTitle(state.currentPhase, l10n);
    final progress = state.progressRatio;

    final elapsedMins = state.totalElapsedSeconds ~/ 60;
    final elapsedSecs = state.totalElapsedSeconds % 60;
    final minsStr = l10n.formatNumber(elapsedMins.toString().padLeft(2, '0'));
    final secsStr = l10n.formatNumber(elapsedSecs.toString().padLeft(2, '0'));
    final elapsedStr = '$minsStr:$secsStr';

    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // Circular Countdown Gauge
          Stack(
            alignment: Alignment.center,
            children: [
              // Background track
              SizedBox(
                width: 260,
                height: 260,
                child: const CircularProgressIndicator(
                  value: 1.0,
                  strokeWidth: 16,
                  color: AppColors.surfaceElevated,
                ),
              ),
              // Active Progress Ring
              SizedBox(
                width: 260,
                height: 260,
                child: CircularProgressIndicator(
                  value: progress,
                  strokeWidth: 16,
                  strokeCap: StrokeCap.round,
                  color: phaseColor,
                ),
              ),
              // Inner Center Content
              Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  // Phase Badge
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                    decoration: BoxDecoration(
                      color: phaseColor.withAlpha(30),
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(color: phaseColor.withAlpha(80)),
                    ),
                    child: Text(
                      phaseTitle,
                      style: AppTypography.badgeText.copyWith(
                        color: phaseColor,
                        letterSpacing: 1.0,
                      ),
                    ),
                  ),
                  const SizedBox(height: 8),

                  // Large Countdown Seconds
                  Text(
                    l10n.formatNumber('${state.currentSecondsRemaining}'),
                    style: AppTypography.displayLarge.copyWith(
                      fontSize: 64,
                      fontWeight: FontWeight.w800,
                      color: Colors.white,
                    ),
                  ),

                  // Set Counter
                  Text(
                    l10n.setOfTotal(state.currentSet, state.selectedPreset.totalSets),
                    style: AppTypography.titleMedium.copyWith(
                      color: AppColors.textMuted,
                      letterSpacing: 0.5,
                    ),
                  ),
                ],
              ),
            ],
          ),

          const SizedBox(height: 24),

          // Total Elapsed Workout Clock
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            decoration: BoxDecoration(
              color: AppColors.surfaceElevated,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: AppColors.cardBorder),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Icon(Icons.timer_outlined, size: 16, color: AppColors.textMuted),
                const SizedBox(width: 8),
                Text(
                  l10n.totalElapsed(elapsedStr),
                  style: AppTypography.bodyMedium.copyWith(color: AppColors.textSecondary),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
