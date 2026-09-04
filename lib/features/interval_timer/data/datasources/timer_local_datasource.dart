import 'dart:convert';
import 'dart:io';
import 'package:path_provider/path_provider.dart';
import '../../../../core/error/exceptions.dart';
import '../../domain/entities/interval_preset_entity.dart';
import '../models/interval_preset_model.dart';

abstract class TimerLocalDataSource {
  Future<List<IntervalPresetModel>> getPresets();
  Future<void> savePreset(IntervalPresetModel model);
  Future<void> deletePreset(String id);
}

class TimerLocalDataSourceImpl implements TimerLocalDataSource {
  static const String _fileName = 'timer_presets_store.json';
  File? _cachedFile;

  Future<File> _getFile() async {
    if (_cachedFile != null) return _cachedFile!;
    final dir = await getApplicationDocumentsDirectory();
    _cachedFile = File('${dir.path}/$_fileName');
    return _cachedFile!;
  }

  @override
  Future<List<IntervalPresetModel>> getPresets() async {
    try {
      final file = await _getFile();
      if (!await file.exists()) {
        // Return default presets if file does not exist yet
        return IntervalPresetEntity.defaultPresets
            .map((e) => IntervalPresetModel.fromEntity(e))
            .toList();
      }
      final content = await file.readAsString();
      if (content.trim().isEmpty) {
        return IntervalPresetEntity.defaultPresets
            .map((e) => IntervalPresetModel.fromEntity(e))
            .toList();
      }

      final List<dynamic> jsonList = jsonDecode(content) as List<dynamic>;
      return jsonList
          .map((e) => IntervalPresetModel.fromJson(e as Map<String, dynamic>))
          .toList();
    } catch (e) {
      throw DatabaseException('Failed to read timer presets: $e');
    }
  }

  @override
  Future<void> savePreset(IntervalPresetModel model) async {
    try {
      final items = await getPresets();
      final index = items.indexWhere((p) => p.id == model.id);
      if (index >= 0) {
        items[index] = model;
      } else {
        items.add(model);
      }
      final file = await _getFile();
      await file.writeAsString(jsonEncode(items.map((e) => e.toJson()).toList()));
    } catch (e) {
      throw DatabaseException('Failed to save timer preset: $e');
    }
  }

  @override
  Future<void> deletePreset(String id) async {
    try {
      final items = await getPresets();
      items.removeWhere((p) => p.id == id);
      final file = await _getFile();
      await file.writeAsString(jsonEncode(items.map((e) => e.toJson()).toList()));
    } catch (e) {
      throw DatabaseException('Failed to delete timer preset: $e');
    }
  }
}
