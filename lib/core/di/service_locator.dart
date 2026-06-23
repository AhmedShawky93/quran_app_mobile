import 'package:get_it/get_it.dart';
import '../network/api_client.dart';
import '../../features/quran/data/datasources/quran_local_data_source.dart';
import '../../features/quran/data/datasources/quran_remote_data_source.dart';
import '../../features/quran/data/repositories/quran_repository_impl.dart';
import '../../features/quran/domain/repositories/quran_repository.dart';
import '../../features/quran/domain/usecases/get_surahs_usecase.dart';
import '../../features/quran/presentation/bloc/surah_cubit.dart';

final sl = GetIt.instance;

Future<void> init() async {
  // Core
  sl.registerLazySingleton(() => ApiClient());

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

  // BLoC/Cubit
  sl.registerFactory(() => SurahCubit(sl()));
}