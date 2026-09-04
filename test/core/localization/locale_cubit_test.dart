import 'package:flutter_test/flutter_test.dart';
import 'package:dailypouch/core/localization/app_language.dart';
import 'package:dailypouch/core/localization/locale_cubit.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  group('LocaleCubit & AppLanguage', () {
    test('initial state defaults to English', () {
      final cubit = LocaleCubit();
      expect(cubit.state.code, 'en');
      expect(cubit.state.name, 'English');
    });

    test('findLanguage returns correct language by code or fallback to English', () {
      expect(findLanguage('bn').nativeName, 'বাংলা');
      expect(findLanguage('es').nativeName, 'Español');
      expect(findLanguage('de').nativeName, 'Deutsch');
      expect(findLanguage('unknown').code, 'en');
    });

    test('setLanguage emits new language state', () async {
      final cubit = LocaleCubit();
      final spanish = findLanguage('es');

      cubit.setLanguage(spanish);
      expect(cubit.state, spanish);
      expect(cubit.state.code, 'es');
    });
  });
}
