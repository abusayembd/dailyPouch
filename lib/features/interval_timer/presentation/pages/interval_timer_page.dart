import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../core/localization/app_localizations.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/widgets/custom_app_bar.dart';
import '../../domain/entities/interval_preset_entity.dart';
import '../bloc/interval_timer_bloc.dart';
import '../bloc/interval_timer_event.dart';
import '../bloc/interval_timer_state.dart';
import '../widgets/edit_preset_dialog.dart';
import '../widgets/interval_controls_bar.dart';
import '../widgets/preset_selector_carousel.dart';
import '../widgets/timer_countdown_gauge.dart';

class IntervalTimerPage extends StatefulWidget {
  const IntervalTimerPage({super.key});

  @override
  State<IntervalTimerPage> createState() => _IntervalTimerPageState();
}

class _IntervalTimerPageState extends State<IntervalTimerPage> {
  @override
  void initState() {
    super.initState();
    context.read<IntervalTimerBloc>().add(const LoadPresetsEvent());
  }

  void _openCustomPresetDialog(BuildContext context) async {
    final bloc = context.read<IntervalTimerBloc>();
    final result = await showDialog<IntervalPresetEntity>(
      context: context,
      builder: (_) => const EditPresetDialog(),
    );

    if (result != null) {
      bloc.add(SaveCustomPresetEvent(result));
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;

    return Scaffold(
      appBar: CustomAppBar(
        title: l10n.timerTitle,
        subtitle: l10n.timerSubtitle,
        accentColor: AppColors.moduleTimer,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new_rounded),
          onPressed: () => Navigator.of(context).pop(),
        ),
      ),
      body: BlocConsumer<IntervalTimerBloc, IntervalTimerState>(
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
          final bloc = context.read<IntervalTimerBloc>();

          return SafeArea(
            child: CustomScrollView(
              physics: const BouncingScrollPhysics(),
              slivers: [
                SliverPadding(
                  padding: const EdgeInsets.all(16),
                  sliver: SliverToBoxAdapter(
                    child: Column(
                      children: [
                        // Preset Carousel
                        PresetSelectorCarousel(
                          presets: state.presets,
                          selectedPreset: state.selectedPreset,
                          onPresetSelected: (p) => bloc.add(SelectPresetTimerEvent(p)),
                          onCustomPreset: () => _openCustomPresetDialog(context),
                        ),
                        const SizedBox(height: 28),

                        // Center Countdown Gauge
                        TimerCountdownGauge(state: state),
                        const SizedBox(height: 32),

                        // Interval Control Bar
                        IntervalControlsBar(
                          state: state,
                          onStart: () => bloc.add(const StartTimerEvent()),
                          onPause: () => bloc.add(const PauseTimerEvent()),
                          onResume: () => bloc.add(const ResumeTimerEvent()),
                          onReset: () => bloc.add(const ResetTimerEvent()),
                          onSkip: () => bloc.add(const SkipIntervalEvent()),
                        ),
                        const SizedBox(height: 24),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
