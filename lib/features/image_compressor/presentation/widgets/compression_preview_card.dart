import 'package:flutter/material.dart';
import '../../../../core/localization/app_localizations.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_typography.dart';
import '../../../../core/widgets/glass_card.dart';
import '../../domain/entities/compression_preset.dart';

class CompressionPreviewCard extends StatelessWidget {
  final ProcessedFileEntity processed;

  const CompressionPreviewCard({super.key, required this.processed});

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;

    final savingsStr = l10n.formatNumber(processed.savingsPercentage.toStringAsFixed(0));
    final origKbStr = l10n.formatNumber(processed.originalKb.toStringAsFixed(1));
    final origWStr = l10n.formatNumber(processed.originalWidth.toString());
    final origHStr = l10n.formatNumber(processed.originalHeight.toString());
    final procKbStr = l10n.formatNumber(processed.processedKb.toStringAsFixed(1));
    final procWStr = l10n.formatNumber(processed.processedWidth.toString());
    final procHStr = l10n.formatNumber(processed.processedHeight.toString());

    return GlassCard(
      gradient: AppColors.heroCardGradient,
      borderColor: AppColors.moduleCompressor.withAlpha(80),
      borderRadius: 20,
      padding: const EdgeInsets.all(18),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                l10n.compressionResults,
                style: AppTypography.badgeText.copyWith(color: AppColors.moduleCompressor),
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                decoration: BoxDecoration(
                  color: AppColors.success.withAlpha(30),
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(color: AppColors.success.withAlpha(90)),
                ),
                child: Text(
                  '-$savingsStr% ${l10n.reduced}',
                  style: AppTypography.badgeText.copyWith(color: AppColors.success),
                ),
              ),
            ],
          ),
          const SizedBox(height: 14),

          // Side by Side size comparison
          Row(
            children: [
              Expanded(
                child: Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: AppColors.surfaceElevated,
                    borderRadius: BorderRadius.circular(14),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(l10n.originalSize, style: AppTypography.labelSmall),
                      const SizedBox(height: 4),
                      Text(
                        '$origKbStr KB',
                        style: AppTypography.titleMedium.copyWith(color: AppColors.textMuted),
                      ),
                      Text(
                        '$origWStr x $origHStr px',
                        style: AppTypography.labelSmall.copyWith(fontSize: 10),
                      ),
                    ],
                  ),
                ),
              ),
              const Padding(
                padding: EdgeInsets.symmetric(horizontal: 10),
                child: Icon(Icons.arrow_forward_rounded, color: AppColors.moduleCompressor),
              ),
              Expanded(
                child: Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: AppColors.moduleCompressor.withAlpha(20),
                    borderRadius: BorderRadius.circular(14),
                    border: Border.all(color: AppColors.moduleCompressor.withAlpha(60)),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        l10n.compressedOutput,
                        style: AppTypography.labelSmall.copyWith(color: AppColors.moduleCompressor),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        '$procKbStr KB',
                        style: AppTypography.titleMedium.copyWith(color: Colors.white, fontWeight: FontWeight.w700),
                      ),
                      Text(
                        '$procWStr x $procHStr px (${processed.format})',
                        style: AppTypography.labelSmall.copyWith(fontSize: 10, color: AppColors.primaryLight),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),

          const SizedBox(height: 16),

          // Compressed Image Preview
          ClipRRect(
            borderRadius: BorderRadius.circular(14),
            child: Container(
              height: 200,
              width: double.infinity,
              color: Colors.black,
              child: Image.memory(
                processed.processedBytes,
                fit: BoxFit.contain,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
