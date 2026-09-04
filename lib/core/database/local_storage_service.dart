import 'dart:io';
import 'package:path_provider/path_provider.dart';

/// Single-instance manager for the local file and cache storage.
class LocalStorageService {
  /// Returns the application documents directory path.
  Future<String> get storagePath async {
    final dir = await getApplicationDocumentsDirectory();
    return dir.path;
  }

  /// Clears all stored JSON cache files (useful for dev resets).
  Future<void> clearAllCache() async {
    final dir = await getApplicationDocumentsDirectory();
    final files = dir.listSync();
    for (final entity in files) {
      if (entity is File && entity.path.endsWith('_store.json')) {
        try {
          entity.deleteSync();
        } catch (_) {}
      }
    }
  }
}
