import 'package:flutter/material.dart';
import 'package:uuid/uuid.dart';
import '../../../../core/localization/app_localizations.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_typography.dart';
import '../../domain/entities/pantry_item_entity.dart';

class AddEditPantryItemDialog extends StatefulWidget {
  final PantryItemEntity? initial;

  const AddEditPantryItemDialog({super.key, this.initial});

  @override
  State<AddEditPantryItemDialog> createState() => _AddEditPantryItemDialogState();
}

class _AddEditPantryItemDialogState extends State<AddEditPantryItemDialog> {
  final _formKey = GlobalKey<FormState>();
  late final TextEditingController _nameController;
  late final TextEditingController _barcodeController;
  late final TextEditingController _qtyController;
  late final TextEditingController _unitController;
  late final TextEditingController _notesController;

  late StorageZone _zone;
  late DateTime _expiryDate;
  late bool _isConsumed;

  @override
  void initState() {
    super.initState();
    final item = widget.initial;
    _nameController = TextEditingController(text: item?.name ?? '');
    _barcodeController = TextEditingController(text: item?.barcode ?? '');
    _qtyController = TextEditingController(
      text: item != null ? item.quantity.toStringAsFixed(0) : '1',
    );
    _unitController = TextEditingController(text: item?.unit ?? 'pcs');
    _notesController = TextEditingController(text: item?.notes ?? '');

    _zone = item?.zone ?? StorageZone.pantry;
    _expiryDate = item?.expiryDate ?? DateTime.now().add(const Duration(days: 7));
    _isConsumed = item?.isConsumed ?? false;
  }

  @override
  void dispose() {
    _nameController.dispose();
    _barcodeController.dispose();
    _qtyController.dispose();
    _unitController.dispose();
    _notesController.dispose();
    super.dispose();
  }

  void _applyPreset(String name, StorageZone zone, int daysAhead) {
    setState(() {
      _nameController.text = name;
      _zone = zone;
      _expiryDate = DateTime.now().add(Duration(days: daysAhead));
    });
  }

  Future<void> _pickExpiryDate() async {
    final picked = await showDatePicker(
      context: context,
      initialDate: _expiryDate,
      firstDate: DateTime.now().subtract(const Duration(days: 90)),
      lastDate: DateTime.now().add(const Duration(days: 365 * 10)),
      builder: (context, child) {
        return Theme(
          data: ThemeData.light().copyWith(
            colorScheme: const ColorScheme.light(
              primary: AppColors.modulePantry,
              surface: AppColors.surfaceCard,
            ),
          ),
          child: child!,
        );
      },
    );

    if (picked != null) {
      setState(() {
        _expiryDate = picked;
      });
    }
  }

  void _submit() {
    if (!_formKey.currentState!.validate()) return;

    final normalizedQty = AppLocalizations.normalizeNumber(_qtyController.text.trim());
    final entity = PantryItemEntity(
      id: widget.initial?.id ?? const Uuid().v4(),
      name: _nameController.text.trim(),
      barcode: _barcodeController.text.trim().isEmpty ? null : _barcodeController.text.trim(),
      zone: _zone,
      expiryDate: _expiryDate,
      quantity: double.tryParse(normalizedQty) ?? 1.0,
      unit: _unitController.text.trim().isEmpty ? 'pcs' : _unitController.text.trim(),
      isConsumed: _isConsumed,
      addedDate: widget.initial?.addedDate ?? DateTime.now(),
      notes: _notesController.text.trim().isEmpty ? null : _notesController.text.trim(),
    );

    Navigator.of(context).pop(entity);
  }

  @override
  Widget build(BuildContext context) {
    final isEditing = widget.initial != null;
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
                    Text(
                      isEditing ? l10n.editPantryItem : l10n.addItemMedicine,
                      style: AppTypography.headlineMedium,
                    ),
                    IconButton(
                      icon: const Icon(Icons.close_rounded, color: AppColors.textMuted),
                      onPressed: () => Navigator.of(context).pop(),
                    ),
                  ],
                ),
                const SizedBox(height: 12),

                // Quick Presets Row
                if (!isEditing) ...[
                  Text(l10n.quickPresets, style: AppTypography.labelSmall),
                  const SizedBox(height: 6),
                  SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    child: Row(
                      children: [
                        _buildPresetChip('Milk', StorageZone.fridge, 5, l10n),
                        _buildPresetChip('Eggs', StorageZone.fridge, 21, l10n),
                        _buildPresetChip('Yogurt', StorageZone.fridge, 10, l10n),
                        _buildPresetChip('Bread', StorageZone.pantry, 4, l10n),
                        _buildPresetChip('Medicine', StorageZone.medicine, 365, l10n),
                      ],
                    ),
                  ),
                  const SizedBox(height: 14),
                ],

                // Item Name input
                TextFormField(
                  controller: _nameController,
                  style: AppTypography.bodyLarge.copyWith(color: AppColors.textPrimary),
                  decoration: InputDecoration(
                    labelText: l10n.productNameLabel,
                    floatingLabelBehavior: FloatingLabelBehavior.always,
                    hintText: l10n.productNameHint,
                    prefixIcon: const Icon(Icons.inventory_2_outlined, color: AppColors.modulePantry),
                  ),
                  validator: (val) {
                    if (val == null || val.trim().isEmpty) return l10n.enterItemName;
                    return null;
                  },
                ),
                const SizedBox(height: 12),

                // Storage Zone Dropdown
                DropdownButtonFormField<StorageZone>(
                  initialValue: _zone,
                  dropdownColor: AppColors.surfaceElevated,
                  decoration: InputDecoration(
                    labelText: l10n.storageZoneLabel,
                    floatingLabelBehavior: FloatingLabelBehavior.always,
                    prefixIcon: const Icon(Icons.category_outlined, color: AppColors.modulePantry),
                  ),
                  items: StorageZone.values.where((z) => z != StorageZone.all).map((z) {
                    return DropdownMenuItem(
                      value: z,
                      child: Text(
                        l10n.getStorageZoneName(z),
                        style: AppTypography.bodyMedium.copyWith(color: AppColors.textPrimary),
                      ),
                    );
                  }).toList(),
                  onChanged: (z) {
                    if (z != null) setState(() => _zone = z);
                  },
                ),
                const SizedBox(height: 12),

                // Expiry Date Picker
                InkWell(
                  onTap: _pickExpiryDate,
                  borderRadius: BorderRadius.circular(14),
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
                    decoration: BoxDecoration(
                      color: AppColors.surfaceElevated,
                      borderRadius: BorderRadius.circular(14),
                      border: Border.all(color: AppColors.cardBorder),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Row(
                          children: [
                            const Icon(Icons.event_available_rounded, color: AppColors.modulePantry, size: 20),
                            const SizedBox(width: 12),
                            Text(l10n.expirationDateLabel, style: AppTypography.bodyMedium),
                          ],
                        ),
                        Text(
                          l10n.formatDate(_expiryDate),
                          style: AppTypography.titleMedium.copyWith(color: AppColors.modulePantry),
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 12),

                // Quantity and Unit Row
                Row(
                  children: [
                    Expanded(
                      flex: 3,
                      child: TextFormField(
                        controller: _qtyController,
                        keyboardType: TextInputType.number,
                        style: AppTypography.bodyLarge.copyWith(color: AppColors.textPrimary),
                        decoration: InputDecoration(
                          labelText: l10n.quantityLabel,
                          floatingLabelBehavior: FloatingLabelBehavior.always,
                          hintText: l10n.formatNumber('1'),
                        ),
                      ),
                    ),
                    const SizedBox(width: 10),
                    Expanded(
                      flex: 3,
                      child: TextFormField(
                        controller: _unitController,
                        style: AppTypography.bodyLarge.copyWith(color: AppColors.textPrimary),
                        decoration: InputDecoration(
                          labelText: l10n.unitLabel,
                          floatingLabelBehavior: FloatingLabelBehavior.always,
                          hintText: 'pcs',
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
                      backgroundColor: AppColors.modulePantry,
                      foregroundColor: Colors.white,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(14),
                      ),
                    ),
                    onPressed: _submit,
                    child: Text(
                      isEditing ? l10n.saveChanges : l10n.addItemToZone,
                      style: AppTypography.titleMedium.copyWith(color: Colors.white),
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

  Widget _buildPresetChip(String name, StorageZone zone, int daysAhead, AppLocalizations l10n) {
    final localizedName = l10n.getLocalizedPantryItemName(name);

    return Padding(
      padding: const EdgeInsets.only(right: 6),
      child: ActionChip(
        label: Text(localizedName),
        labelStyle: AppTypography.labelSmall.copyWith(color: AppColors.primaryLight),
        backgroundColor: AppColors.surfaceElevated,
        side: const BorderSide(color: AppColors.cardBorder),
        onPressed: () => _applyPreset(localizedName, zone, daysAhead),
      ),
    );
  }
}
