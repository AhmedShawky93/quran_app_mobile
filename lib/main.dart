import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'core/theme/app_theme.dart';
import 'core/di/service_locator.dart' as di;
import 'features/quran/presentation/screens/home_screen.dart';
import 'features/quran/presentation/bloc/surah_cubit.dart';
import 'features/quran/data/models/surah_model.dart';
import 'features/auth/presentation/screens/auth_screen.dart';
import 'features/auth/presentation/bloc/auth_cubit.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  
  await Hive.initFlutter();
  Hive.registerAdapter(SurahModelAdapter());
  Hive.registerAdapter(TafsirSourceModelAdapter());
  
  await di.init();
  runApp(const QuranApp());
}

class QuranApp extends StatelessWidget {
  const QuranApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(create: (_) => di.sl<AuthCubit>()),
      ],
      child: MaterialApp(
        title: 'Quran App',
        theme: AppTheme.lightTheme,
        darkTheme: AppTheme.darkTheme,
        themeMode: ThemeMode.system,
        localizationsDelegates: const [
          GlobalMaterialLocalizations.delegate,
          GlobalWidgetsLocalizations.delegate,
          GlobalCupertinoLocalizations.delegate,
        ],
        supportedLocales: const [
          Locale('ar', 'SA'),
          Locale('en', 'US'),
        ],
        locale: const Locale('ar', 'SA'),
        home: const AuthScreen(),
      ),
    );
  }
}

class QuranAppMain extends StatelessWidget {
  const QuranAppMain({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => di.sl<SurahCubit>()..fetchSurahs(),
      child: const HomeScreen(),
    );
  }
}