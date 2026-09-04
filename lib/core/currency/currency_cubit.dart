import 'dart:convert';
import 'dart:io';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:path_provider/path_provider.dart';
import 'currency_entity.dart';

class CurrencyCubit extends Cubit<AppCurrency> {
  static const String _settingsFile = 'settings_store.json';

  CurrencyCubit([AppCurrency? initial]) : super(initial ?? kSupportedCurrencies.first) {
    _loadSavedCurrency();
  }

  Future<void> _loadSavedCurrency() async {
    try {
      final dir = await getApplicationDocumentsDirectory();
      final file = File('${dir.path}/$_settingsFile');
      if (await file.exists()) {
        final content = await file.readAsString();
        if (content.isNotEmpty) {
          final data = jsonDecode(content) as Map<String, dynamic>;
          final code = data['currency_code'] as String?;
          if (code != null) {
            final found = findCurrency(code);
            emit(found);
          }
        }
      }
    } catch (_) {
      // Graceful fallback to default currency
    }
  }

  Future<void> setCurrency(AppCurrency currency) async {
    emit(currency);
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
      data['currency_code'] = currency.code;
      await file.writeAsString(jsonEncode(data));
    } catch (_) {
      // Memory state is maintained even if disk write fails
    }
  }
}
