import '../../domain/entities/surah.dart';
import '../../domain/entities/verse.dart';
import '../../domain/entities/bookmark.dart';
import '../../domain/entities/reading_progress.dart';
import '../../domain/repositories/quran_repository.dart';
import '../../domain/entities/tafsir_source.dart';
import '../models/tafsir_source_model.dart';
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
      throw Exception(
        'Failed to fetch surahs and no local cache available: $e',
      );
    }
  }

  @override
  Future<List<Verse>> getSurahVerses(int surahId) async {
    try {
      final remoteVerses = await remoteDataSource.getSurahVerses(surahId);
      // Local caching for verses could be added here if needed
      return remoteVerses;
    } catch (e) {
      // For now, return empty or handle offline if verses are cached
      throw Exception('Failed to fetch verses: $e');
    }
  }

  @override
  Future<List<TafsirSource>> getTafsirSources() async {
    try {
      final remoteTafsirSources = await remoteDataSource.getTafsirSources();
      // Cache tafsir sources locally
      await localDataSource.cacheTafsirSources(remoteTafsirSources);
      return remoteTafsirSources;
    } catch (e) {
      final localTafsirSources = await localDataSource.getTafsirSources();
      if (localTafsirSources.isNotEmpty) {
        return localTafsirSources;
      }
      throw Exception(
        'Failed to fetch tafsir sources and no local cache available: $e',
      );
    }
  }

  @override
  Future<String> getVerseTafsir(int verseId, int tafsirSourceId) async {
    try {
      final remoteTafsir = await remoteDataSource.getVerseTafsir(
        verseId,
        tafsirSourceId,
      );
      // Cache verse tafsir locally
      await localDataSource.cacheVerseTafsir(
        verseId,
        tafsirSourceId,
        remoteTafsir,
      );
      return remoteTafsir;
    } catch (e) {
      final localTafsir = await localDataSource.getVerseTafsir(
        verseId,
        tafsirSourceId,
      );
      if (localTafsir.isNotEmpty) {
        return localTafsir;
      }
      throw Exception(
        'Failed to fetch verse tafsir and no local cache available: $e',
      );
    }
  }
}
