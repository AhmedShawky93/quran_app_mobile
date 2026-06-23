import '../../domain/entities/surah.dart';
import '../../domain/repositories/quran_repository.dart';
import '../datasources/quran_local_data_source.dart';
import '../datasources/quran_remote_data_source.dart';

class QuranRepositoryImpl implements QuranRepository {
  final QuranRemoteDataSource remoteDataSource;
  final QuranLocalDataSource localDataSource;

  QuranRepositoryImpl({
    required this.remoteDataSource,
    required this.localDataSource,
  });

  @override
  Future<List<Surah>> getSurahs() async {
    try {
      final remoteSurahs = await remoteDataSource.getSurahs();
      await localDataSource.cacheSurahs(remoteSurahs);
      return remoteSurahs;
    } catch (e) {
      final localSurahs = await localDataSource.getSurahs();
      if (localSurahs.isNotEmpty) {
        return localSurahs;
      }
      throw Exception('Failed to fetch surahs and no local cache available: $e');
    }
  }
}
