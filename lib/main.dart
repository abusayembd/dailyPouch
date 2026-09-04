import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'core/currency/currency_cubit.dart';
import 'core/di/injection_container.dart' as di;
import 'core/localization/app_language.dart';
import 'core/localization/app_localizations.dart';
import 'core/localization/locale_cubit.dart';
import 'core/theme/app_theme.dart';
import 'features/launcher/presentation/cubit/launcher_cubit.dart';
import 'features/launcher/presentation/pages/launcher_page.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Initialize service locator dependency injection graph
  await di.initInjection();

  runApp(const DailyPouchApp());
}

class DailyPouchApp extends StatelessWidget {
  const DailyPouchApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider<LauncherCubit>(create: (_) => di.sl<LauncherCubit>()),
        BlocProvider<CurrencyCubit>(create: (_) => di.sl<CurrencyCubit>()),
        BlocProvider<LocaleCubit>(create: (_) => di.sl<LocaleCubit>()),
      ],
      child: BlocBuilder<LocaleCubit, AppLanguage>(
        builder: (context, currentLanguage) {
          return MaterialApp(
            title: 'DailyPouch: Offline Life Tools',
            debugShowCheckedModeBanner: false,
            theme: AppTheme.darkTheme,
            locale: currentLanguage.locale,
            localizationsDelegates: const [
              AppLocalizations.delegate,
              GlobalMaterialLocalizations.delegate,
              GlobalWidgetsLocalizations.delegate,
              GlobalCupertinoLocalizations.delegate,
            ],
            supportedLocales: kSupportedLanguages.map((l) => l.locale).toList(),
            home: const LauncherPage(),
          );
        },
      ),
    );
  }
}
