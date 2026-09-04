import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../core/localization/app_localizations.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_typography.dart';
import '../../../../core/widgets/custom_app_bar.dart';
import '../../../../core/widgets/glass_card.dart';
import '../bloc/image_compressor_bloc.dart';
import '../bloc/image_compressor_event.dart';
import '../bloc/image_compressor_state.dart';
import '../widgets/compression_preview_card.dart';
import '../widgets/preset_selector_chip_group.dart';

class ImageCompressorPage extends StatelessWidget {
  const ImageCompressorPage({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;

    return Scaffold(
      appBar: CustomAppBar(
        title: l10n.compressorTitle,
        subtitle: l10n.compressorSubtitle,
        accentColor: AppColors.moduleCompressor,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new_rounded),
          onPressed: () => Navigator.of(context).pop(),
        ),
      ),
      body: BlocConsumer<ImageCompressorBloc, ImageCompressorState>(
        listener: (context, state) {
          if (state.successMessage != null) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(state.successMessage!),
                backgroundColor: AppColors.surfaceElevated,
                behavior: SnackBarBehavior.floating,
                duration: const Duration(seconds: 2),
              ),
            );
          } else if (state.errorMessage != null) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(state.errorMessage!),
                backgroundColor: AppColors.error,
                behavior: SnackBarBehavior.floating,
              ),
            );
          }
        },
        builder: (context, state) {
          final bloc = context.read<ImageCompressorBloc>();

          return CustomScrollView(
            physics: const BouncingScrollPhysics(),
            slivers: [
              SliverPadding(
                padding: const EdgeInsets.all(16),
                sliver: SliverToBoxAdapter(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Preset Selector
                      PresetSelectorChipGroup(
                        selectedPreset: state.selectedPreset,
                        onPresetSelected: (p) => bloc.add(SelectPresetEvent(p)),
                      ),
                      const SizedBox(height: 18),

                      // Target Size Slider (KB)
                      GlassCard(
                        borderRadius: 18,
                        padding: const EdgeInsets.all(16),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(l10n.exactTargetSizeLimit, style: AppTypography.titleMedium),
                                Container(
                                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                                  decoration: BoxDecoration(
                                    color: AppColors.moduleCompressor.withAlpha(30),
                                    borderRadius: BorderRadius.circular(10),
                                  ),
                                  child: Text(
                                    '< ${l10n.formatNumber(state.customTargetKb.toString())} KB',
                                    style: AppTypography.titleMedium.copyWith(
                                      color: AppColors.moduleCompressor,
                                      fontWeight: FontWeight.w700,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 8),
                            Slider(
                              value: state.customTargetKb.toDouble(),
                              min: 50,
                              max: 1000,
                              divisions: 19,
                              activeColor: AppColors.moduleCompressor,
                              inactiveColor: AppColors.surfaceElevated,
                              onChanged: (val) {
                                bloc.add(UpdateTargetKbEvent(val.round()));
                              },
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(l10n.ultraTiny, style: AppTypography.labelSmall),
                                Text(l10n.highQuality, style: AppTypography.labelSmall),
                              ],
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 18),

                      // Processing Action Trigger
                      Row(
                        children: [
                          Expanded(
                            child: ElevatedButton.icon(
                              style: ElevatedButton.styleFrom(
                                backgroundColor: AppColors.moduleCompressor,
                                foregroundColor: Colors.white,
                                padding: const EdgeInsets.symmetric(vertical: 14),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(14),
                                ),
                              ),
                              onPressed: state.isProcessing
                                  ? null
                                  : () {
                                      bloc.add(const GenerateSampleImageEvent());
                                    },
                              icon: state.isProcessing
                                  ? const SizedBox(
                                      width: 18,
                                      height: 18,
                                      child: CircularProgressIndicator(
                                        strokeWidth: 2,
                                        color: Colors.white,
                                      ),
                                    )
                                  : const Icon(Icons.photo_filter_rounded),
                              label: Text(
                                state.isProcessing
                                    ? l10n.compressing
                                    : l10n.selectImages,
                                style: const TextStyle(fontWeight: FontWeight.w700),
                              ),
                            ),
                          ),
                          if (state.lastProcessed != null) const SizedBox(width: 10),
                          if (state.lastProcessed != null)
                            IconButton.filled(
                              style: IconButton.styleFrom(
                                backgroundColor: AppColors.surfaceElevated,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(14),
                                  side: const BorderSide(color: AppColors.cardBorder),
                                ),
                                padding: const EdgeInsets.all(14),
                              ),
                              tooltip: l10n.compilePdf,
                              icon: const Icon(Icons.picture_as_pdf_rounded, color: AppColors.moduleCompressor),
                              onPressed: () {
                                bloc.add(CompilePdfEvent([
                                  state.lastProcessed!.processedBytes,
                                ]));
                              },
                            ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),

              // Preview Output Card
              if (state.lastProcessed != null)
                SliverPadding(
                  padding: const EdgeInsets.fromLTRB(16, 0, 16, 40),
                  sliver: SliverToBoxAdapter(
                    child: CompressionPreviewCard(processed: state.lastProcessed!),
                  ),
                )
              else
                SliverFillRemaining(
                  hasScrollBody: false,
                  child: Center(
                    child: Padding(
                      padding: const EdgeInsets.all(24),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(
                            Icons.photo_size_select_small_rounded,
                            size: 64,
                            color: AppColors.textMuted.withAlpha(120),
                          ),
                          const SizedBox(height: 16),
                          Text(l10n.readyToCompress, style: AppTypography.headlineMedium),
                          const SizedBox(height: 6),
                          Text(
                            l10n.readyToCompressDesc,
                            style: AppTypography.bodyMedium,
                            textAlign: TextAlign.center,
                          ),
                        ],
                      ),
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
