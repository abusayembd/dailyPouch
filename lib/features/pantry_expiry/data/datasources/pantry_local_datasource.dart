import 'dart:convert';
import 'dart:io';
import 'package:path_provider/path_provider.dart';
import '../../../../core/error/exceptions.dart';
import '../models/pantry_item_model.dart';

abstract class PantryLocalDataSource {
  Future<List<PantryItemModel>> getPantryItems();
  Future<void> savePantryItem(PantryItemModel model);
  Future<void> deletePantryItem(String id);
  Future<void> toggleConsumedStatus(String id);
}

class PantryLocalDataSourceImpl implements PantryLocalDataSource {
  static const String _fileName = 'pantry_items_store.json';
  File? _cachedFile;

  Future<File> _getFile() async {
    if (_cachedFile != null) return _cachedFile!;
    final dir = await getApplicationDocumentsDirectory();
    _cachedFile = File('${dir.path}/$_fileName');
    return _cachedFile!;
  }

  @override
  Future<List<PantryItemModel>> getPantryItems() async {
    try {
      final file = await _getFile();
      if (!await file.exists()) {
        return [];
      }
      final content = await file.readAsString();
      if (content.trim().isEmpty) return [];

      final List<dynamic> jsonList = jsonDecode(content) as List<dynamic>;
      return jsonList
          .map((e) => PantryItemModel.fromJson(e as Map<String, dynamic>))
          .toList();
    } catch (e) {
      throw DatabaseException('Failed to read pantry items: $e');
    }
  }

  @override
  Future<void> savePantryItem(PantryItemModel model) async {
    try {
      final items = await getPantryItems();
      final index = items.indexWhere((i) => i.id == model.id);
      if (index >= 0) {
        items[index] = model;
      } else {
        items.add(model);
      }
      await _persist(items);
    } catch (e) {
      throw DatabaseException('Failed to save pantry item: $e');
    }
  }

  @override
  Future<void> deletePantryItem(String id) async {
    try {
      final items = await getPantryItems();
      items.removeWhere((i) => i.id == id);
      await _persist(items);
    } catch (e) {
      throw DatabaseException('Failed to delete pantry item: $e');
    }
  }

  @override
  Future<void> toggleConsumedStatus(String id) async {
    try {
      final items = await getPantryItems();
      final index = items.indexWhere((i) => i.id == id);
      if (index >= 0) {
        final current = items[index];
        items[index] = PantryItemModel(
          id: current.id,
          name: current.name,
          barcode: current.barcode,
          zone: current.zone,
          expiryDate: current.expiryDate,
          quantity: current.quantity,
          unit: current.unit,
          isConsumed: !current.isConsumed,
          addedDate: current.addedDate,
          notes: current.notes,
        );
        await _persist(items);
      }
    } catch (e) {
      throw DatabaseException('Failed to toggle consumed status: $e');
    }
  }

  Future<void> _persist(List<PantryItemModel> items) async {
    final file = await _getFile();
    final jsonString = jsonEncode(items.map((e) => e.toJson()).toList());
    await file.writeAsString(jsonString);
  }
}
