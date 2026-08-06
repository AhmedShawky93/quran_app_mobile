import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:hive_flutter/hive_flutter.dart';

import 'core/di/service_locator.dart' as di;

import 'features/quran/presentation/screens/home_screen.dart';
import 'features/quran/presentation/bloc/surah_cubit.dart';
import 'features/quran/presentation/bloc/reading_progress_cubit.dart';

import 'features/quran/data/models/surah_model.dart';
import 'features/quran/data/models/tafsir_source_model.dart';
import 'features/quran/data/models/bookmark_model.dart';
import 'features/quran/data/models/reading_progress_model.dart';

import 'features/auth/presentation/screens/auth_screen.dart';
import 'features/auth/presentation/bloc/auth_cubit.dart';
import 'features/auth/presentation/bloc/auth_state.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Hive.initFlutter();

  Hive.registerAdapter(SurahModelAdapter());
  Hive.registerAdapter(TafsirSourceModelAdapter());
  Hive.registerAdapter(BookmarkModelAdapter());
  Hive.registerAdapter(ReadingProgressModelAdapter());

  await di.init();

  runApp(const QuranApp());
}

class QuranApp extends StatelessWidget {
  const QuranApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (_) => di.sl<AuthCubit>(),
        ),
        BlocProvider(
          create: (_) => di.sl<SurahCubit>()..fetchSurahs(),
        ),
        BlocProvider(
          create: (_) => di.sl<ReadingProgressCubit>(),
        ),
      ],
      child: MaterialApp(
        title: 'Quran App',
        theme: ThemeData(
          primarySwatch: Colors.green,
          useMaterial3: true,
        ),
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
        home: BlocBuilder<AuthCubit, AuthState>(
          builder: (context, state) {
            if (state is Authenticated || state is GuestMode) {
              return const HomeScreen();
            }

            return const AuthScreen();
          },
        ),
      ),
    );
  }
}
