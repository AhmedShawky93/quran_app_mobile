import 'package:get_it/get_it.dart';
import 'package:quran_app_mobile/core/network/api_client.dart';
import 'package:quran_app_mobile/core/network/audio_player_service.dart';
import 'package:quran_app_mobile/features/quran/data/datasources/quran_local_data_source.dart';
import 'package:quran_app_mobile/features/quran/data/datasources/quran_remote_data_source.dart';
import 'package:quran_app_mobile/features/quran/data/repositories/quran_repository_impl.dart';
import 'package:quran_app_mobile/features/quran/domain/repositories/quran_repository.dart';
import 'package:quran_app_mobile/features/quran/domain/usecases/get_surahs_usecase.dart';
import 'package:quran_app_mobile/features/quran/domain/usecases/get_surah_verses_usecase.dart';
import 'package:quran_app_mobile/features/quran/domain/usecases/get_tafsir_sources_usecase.dart';
import 'package:quran_app_mobile/features/quran/domain/usecases/get_verse_tafsir_usecase.dart';
import 'package:quran_app_mobile/features/quran/domain/usecases/add_bookmark_usecase.dart';
import 'package:quran_app_mobile/features/quran/domain/usecases/remove_bookmark_usecase.dart';
import 'package:quran_app_mobile/features/quran/domain/usecases/get_bookmarks_usecase.dart';
import 'package:quran_app_mobile/features/quran/domain/usecases/save_reading_progress_usecase.dart';
import 'package:quran_app_mobile/features/quran/domain/usecases/get_reading_progress_usecase.dart';
import 'package:quran_app_mobile/features/quran/presentation/bloc/surah_cubit.dart';
import 'package:quran_app_mobile/features/quran/presentation/bloc/verse_cubit.dart';
import 'package:quran_app_mobile/features/quran/presentation/bloc/tafsir_cubit.dart';
import 'package:quran_app_mobile/features/quran/presentation/bloc/bookmark_cubit.dart';
import 'package:quran_app_mobile/features/quran/presentation/bloc/reading_progress_cubit.dart';
import 'package:quran_app_mobile/features/auth/presentation/bloc/auth_cubit.dart';

final sl = GetIt.instance;

Future<void> init() async {
  // Core
  sl.registerLazySingleton(() => ApiClient());
  sl.registerLazySingleton(() => AudioPlayerService());

  // Data Sources
  sl.registerLazySingleton<QuranRemoteDataSource>(() => QuranRemoteDataSourceImpl(sl()));
  sl.registerLazySingleton<QuranLocalDataSource>(() => QuranLocalDataSourceImpl());

  // Repository
  sl.registerLazySingleton<QuranRepository>(() => QuranRepositoryImpl(
    remoteDataSource: sl(),
    localDataSource: sl(),
  ));

  // UseCases
  sl.registerLazySingleton(() => GetSurahsUseCase(sl()));
  sl.registerLazySingleton(() => GetSurahVersesUseCase(sl()));
  sl.registerLazySingleton(() => GetTafsirSourcesUseCase(sl()));
  sl.registerLazySingleton(() => GetVerseTafsirUseCase(sl()));
  sl.registerLazySingleton(() => AddBookmarkUseCase(sl()));
  sl.registerLazySingleton(() => RemoveBookmarkUseCase(sl()));
  sl.registerLazySingleton(() => GetBookmarksUseCase(sl()));
  sl.registerLazySingleton(() => SaveReadingProgressUseCase(sl()));
  sl.registerLazySingleton(() => GetReadingProgressUseCase(sl()));

  // BLoC/Cubit
  sl.registerFactory(() => SurahCubit(sl()));
  sl.registerFactory(() => VerseCubit(sl()));
  sl.registerFactory(() => TafsirCubit(sl(), sl()));
  sl.registerFactory(() => BookmarkCubit(sl(), sl(), sl()));
  sl.registerFactory(() => ReadingProgressCubit(sl(), sl()));
  sl.registerFactory(() => AuthCubit(sl()));
}
