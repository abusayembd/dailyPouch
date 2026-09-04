import 'dart:convert';
import 'dart:io';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:path_provider/path_provider.dart';
import 'app_language.dart';

class LocaleCubit extends Cubit<AppLanguage> {
  static const String _settingsFile = 'settings_store.json';

  LocaleCubit([AppLanguage? initial]) : super(initial ?? kSupportedLanguages.first) {
    _loadSavedLanguage();
  }

  Future<void> _loadSavedLanguage() async {
    try {
      final dir = await getApplicationDocumentsDirectory();
      final file = File('${dir.path}/$_settingsFile');
      if (await file.exists()) {
        final content = await file.readAsString();
        if (content.isNotEmpty) {
          final data = jsonDecode(content) as Map<String, dynamic>;
          final code = data['language_code'] as String?;
          if (code != null) {
            final found = findLanguage(code);
            emit(found);
          }
        }
      }
    } catch (_) {
      // Graceful fallback to default language
    }
  }

  Future<void> setLanguage(AppLanguage language) async {
    emit(language);
    try {
      final dir = await getApplicationDocumentsDirectory();
      final file = File('${dir.path}/$_settingsFile');
      Map<String, dynamic> data = {};
      if (await file.exists()) {
        final content = await file.readAsString();
        if (content.isNotEmpty) {
          data = jsonDecode(content) as Map<String, dynamic>;
        }
      }
      data['language_code'] = language.code;
      await file.writeAsString(jsonEncode(data));
    } catch (_) {
      // Memory state persists even if disk write fails
    }
  }
}
