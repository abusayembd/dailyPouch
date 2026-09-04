import 'package:flutter/material.dart';
import '../../../../core/theme/app_colors.dart';
import '../bloc/interval_timer_state.dart';

class IntervalControlsBar extends StatelessWidget {
  final IntervalTimerState state;
  final VoidCallback onStart;
  final VoidCallback onPause;
  final VoidCallback onResume;
  final VoidCallback onReset;
  final VoidCallback onSkip;

  const IntervalControlsBar({
    super.key,
    required this.state,
    required this.onStart,
    required this.onPause,
    required this.onResume,
    required this.onReset,
    required this.onSkip,
  });

  @override
  Widget build(BuildContext context) {
    final isRunning = state.isRunning;
    final isPaused = state.isPaused;
    final isIdle = state.currentPhase == TimerPhase.idle;

    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        // Reset Button
        IconButton.filled(
          style: IconButton.styleFrom(
            backgroundColor: AppColors.surfaceElevated,
            foregroundColor: AppColors.textSecondary,
            padding: const EdgeInsets.all(16),
            shape: const CircleBorder(side: BorderSide(color: AppColors.cardBorder)),
          ),
          icon: const Icon(Icons.replay_rounded, size: 24),
          tooltip: 'Reset Session',
          onPressed: isIdle ? null : onReset,
        ),
        const SizedBox(width: 24),

        // Main Start / Pause / Resume Button
        GestureDetector(
          onTap: () {
            if (isIdle) {
              onStart();
            } else if (isRunning) {
              onPause();
            } else if (isPaused) {
              onResume();
            } else {
              onStart();
            }
          },
          child: Container(
            width: 76,
            height: 76,
            decoration: BoxDecoration(
              gradient: AppColors.timerGradient,
              shape: BoxShape.circle,
              boxShadow: [
                BoxShadow(
                  color: AppColors.moduleTimer.withAlpha(120),
                  blurRadius: 18,
                  offset: const Offset(0, 4),
                ),
              ],
            ),
            child: Icon(
              isRunning ? Icons.pause_rounded : Icons.play_arrow_rounded,
              color: Colors.black,
              size: 40,
            ),
          ),
        ),
        const SizedBox(width: 24),

        // Skip Button
        IconButton.filled(
          style: IconButton.styleFrom(
            backgroundColor: AppColors.surfaceElevated,
            foregroundColor: AppColors.textSecondary,
            padding: const EdgeInsets.all(16),
            shape: const CircleBorder(side: BorderSide(color: AppColors.cardBorder)),
          ),
          icon: const Icon(Icons.skip_next_rounded, size: 24),
          tooltip: 'Skip Interval',
          onPressed: isIdle ? null : onSkip,
        ),
      ],
    );
  }
}
