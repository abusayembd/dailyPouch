import 'package:flutter/material.dart';
import 'package:uuid/uuid.dart';
import '../../../../core/localization/app_localizations.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_typography.dart';
import '../../domain/entities/interval_preset_entity.dart';

class EditPresetDialog extends StatefulWidget {
  final IntervalPresetEntity? initial;

  const EditPresetDialog({super.key, this.initial});

  @override
  State<EditPresetDialog> createState() => _EditPresetDialogState();
}

class _EditPresetDialogState extends State<EditPresetDialog> {
  final _formKey = GlobalKey<FormState>();
  late final TextEditingController _nameController;
  late final TextEditingController _prepController;
  late final TextEditingController _workController;
  late final TextEditingController _restController;
  late final TextEditingController _setsController;
  late final TextEditingController _cooldownController;

  @override
  void initState() {
    super.initState();
    final p = widget.initial;
    _nameController = TextEditingController(text: p?.name ?? 'HIIT Routine');
    _prepController = TextEditingController(text: '${p?.prepSeconds ?? 5}');
    _workController = TextEditingController(text: '${p?.workSeconds ?? 30}');
    _restController = TextEditingController(text: '${p?.restSeconds ?? 15}');
    _setsController = TextEditingController(text: '${p?.totalSets ?? 8}');
    _cooldownController = TextEditingController(text: '${p?.cooldownSeconds ?? 30}');
  }

  @override
  void dispose() {
    _nameController.dispose();
    _prepController.dispose();
    _workController.dispose();
    _restController.dispose();
    _setsController.dispose();
    _cooldownController.dispose();
    super.dispose();
  }

  void _submit() {
    if (!_formKey.currentState!.validate()) return;

    final prep = int.tryParse(AppLocalizations.normalizeNumber(_prepController.text.trim())) ?? 5;
    final work = int.tryParse(AppLocalizations.normalizeNumber(_workController.text.trim())) ?? 30;
    final rest = int.tryParse(AppLocalizations.normalizeNumber(_restController.text.trim())) ?? 15;
    final sets = int.tryParse(AppLocalizations.normalizeNumber(_setsController.text.trim())) ?? 8;
    final cooldown = int.tryParse(AppLocalizations.normalizeNumber(_cooldownController.text.trim())) ?? 0;

    final preset = IntervalPresetEntity(
      id: widget.initial?.id ?? const Uuid().v4(),
      name: _nameController.text.trim(),
      prepSeconds: prep,
      workSeconds: work,
      restSeconds: rest,
      totalSets: sets,
      cooldownSeconds: cooldown,
    );

    Navigator.of(context).pop(preset);
  }

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;

    return Dialog(
      backgroundColor: AppColors.surfaceCard,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20),
        side: const BorderSide(color: AppColors.cardBorder),
      ),
      child: ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: 480),
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(20),
          child: Form(
            key: _formKey,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(l10n.customTimerRoutine, style: AppTypography.headlineMedium),
                    IconButton(
                      icon: const Icon(Icons.close_rounded, color: AppColors.textMuted),
                      onPressed: () => Navigator.of(context).pop(),
                    ),
                  ],
                ),
                const SizedBox(height: 16),

                // Routine Name
                TextFormField(
                  controller: _nameController,
                  style: AppTypography.bodyLarge.copyWith(color: AppColors.textPrimary),
                  decoration: InputDecoration(
                    labelText: l10n.routineNameLabel,
                    floatingLabelBehavior: FloatingLabelBehavior.always,
                    hintText: l10n.routineNameHint,
                    prefixIcon: const Icon(Icons.fitness_center_rounded, color: AppColors.moduleTimer),
                  ),
                  validator: (val) {
                    if (val == null || val.trim().isEmpty) return l10n.enterRoutineName;
                    return null;
                  },
                ),
                const SizedBox(height: 14),

                // Work & Rest Row
                Row(
                  children: [
                    Expanded(
                      child: TextFormField(
                        controller: _workController,
                        keyboardType: TextInputType.number,
                        style: AppTypography.bodyLarge.copyWith(color: AppColors.textPrimary),
                        decoration: InputDecoration(
                          labelText: l10n.workSec,
                          floatingLabelBehavior: FloatingLabelBehavior.always,
                          hintText: l10n.formatNumber('30'),
                        ),
                        validator: (val) {
                          final n = int.tryParse(AppLocalizations.normalizeNumber(val ?? ''));
                          if (n == null || n <= 0) return l10n.mustBeGreaterThanZero;
                          return null;
                        },
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: TextFormField(
                        controller: _restController,
                        keyboardType: TextInputType.number,
                        style: AppTypography.bodyLarge.copyWith(color: AppColors.textPrimary),
                        decoration: InputDecoration(
                          labelText: l10n.restSec,
                          floatingLabelBehavior: FloatingLabelBehavior.always,
                          hintText: l10n.formatNumber('15'),
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 14),

                // Sets & Prep Row
                Row(
                  children: [
                    Expanded(
                      child: TextFormField(
                        controller: _setsController,
                        keyboardType: TextInputType.number,
                        style: AppTypography.bodyLarge.copyWith(color: AppColors.textPrimary),
                        decoration: InputDecoration(
                          labelText: l10n.totalSetsRounds,
                          floatingLabelBehavior: FloatingLabelBehavior.always,
                          hintText: l10n.formatNumber('8'),
                        ),
                        validator: (val) {
                          final n = int.tryParse(AppLocalizations.normalizeNumber(val ?? ''));
                          if (n == null || n <= 0) return l10n.mustBeGreaterThanZero;
                          return null;
                        },
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: TextFormField(
                        controller: _prepController,
                        keyboardType: TextInputType.number,
                        style: AppTypography.bodyLarge.copyWith(color: AppColors.textPrimary),
                        decoration: InputDecoration(
                          labelText: l10n.prepCountdownSec,
                          floatingLabelBehavior: FloatingLabelBehavior.always,
                          hintText: l10n.formatNumber('5'),
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 20),

                // Submit Button
                SizedBox(
                  width: double.infinity,
                  height: 48,
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.moduleTimer,
                      foregroundColor: Colors.black,
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
                    ),
                    onPressed: _submit,
                    child: Text(
                      l10n.saveRoutine,
                      style: AppTypography.titleMedium.copyWith(color: Colors.black, fontWeight: FontWeight.w700),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
