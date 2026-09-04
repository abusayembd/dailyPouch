import 'dart:convert';
import 'dart:io';
import 'package:path_provider/path_provider.dart';
import '../../../../core/error/exceptions.dart';
import '../models/saved_benchmark_model.dart';

abstract class PriceCalculatorLocalDataSource {
  Future<List<SavedBenchmarkModel>> getSavedBenchmarks();
  Future<void> saveBenchmark(SavedBenchmarkModel model);
  Future<void> deleteBenchmark(String id);
}

class PriceCalculatorLocalDataSourceImpl implements PriceCalculatorLocalDataSource {
  static const String _fileName = 'price_benchmarks_store.json';
  File? _cachedFile;

  Future<File> _getFile() async {
    if (_cachedFile != null) return _cachedFile!;
    final dir = await getApplicationDocumentsDirectory();
    _cachedFile = File('${dir.path}/$_fileName');
    return _cachedFile!;
  }

  @override
  Future<List<SavedBenchmarkModel>> getSavedBenchmarks() async {
    try {
      final file = await _getFile();
      if (!await file.exists()) {
        return [];
      }
      final content = await file.readAsString();
      if (content.trim().isEmpty) return [];

      final List<dynamic> jsonList = jsonDecode(content) as List<dynamic>;
      return jsonList
          .map((e) => SavedBenchmarkModel.fromJson(e as Map<String, dynamic>))
          .toList();
    } catch (e) {
      throw DatabaseException('Failed to read price benchmarks: $e');
    }
  }

  @override
  Future<void> saveBenchmark(SavedBenchmarkModel model) async {
    try {
      final items = await getSavedBenchmarks();
      final index = items.indexWhere((i) => i.id == model.id);
      if (index >= 0) {
        items[index] = model;
      } else {
        items.add(model);
      }
      await _persist(items);
    } catch (e) {
      throw DatabaseException('Failed to save benchmark: $e');
    }
  }

  @override
  Future<void> deleteBenchmark(String id) async {
    try {
      final items = await getSavedBenchmarks();
      items.removeWhere((i) => i.id == id);
      await _persist(items);
    } catch (e) {
      throw DatabaseException('Failed to delete benchmark: $e');
    }
  }

  Future<void> _persist(List<SavedBenchmarkModel> items) async {
    final file = await _getFile();
    final jsonString = jsonEncode(items.map((e) => e.toJson()).toList());
    await file.writeAsString(jsonString);
  }
}
