import '../../domain/entities/surah.dart';
import '../../domain/entities/verse.dart';
import '../../domain/repositories/quran_repository.dart';
import '../../domain/entities/tafsir_source.dart';
import '../../domain/entities/bookmark.dart';
import '../../domain/entities/reading_progress.dart';
import '../models/reading_progress_model.dart';
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

  @override
  Future<List<Verse>> getSurahVerses(int surahId) async {
    try {
      final remoteVerses = await remoteDataSource.getSurahVerses(surahId);
      return remoteVerses;
    } catch (e) {
      throw Exception('Failed to fetch verses: $e');
    }
  }

  @override
  Future<List<TafsirSource>> getTafsirSources() async {
    try {
      final remoteTafsirSources = await remoteDataSource.getTafsirSources();
      await localDataSource.cacheTafsirSources(remoteTafsirSources);
      return remoteTafsirSources;
    } catch (e) {
      final localTafsirSources = await localDataSource.getTafsirSources();
      if (localTafsirSources.isNotEmpty) {
        return localTafsirSources;
      }
      throw Exception('Failed to fetch tafsir sources and no local cache available: $e');
    }
  }

  @override
  Future<String> getVerseTafsir(int verseId, int tafsirSourceId) async {
    try {
      final remoteTafsir = await remoteDataSource.getVerseTafsir(verseId, tafsirSourceId);
      await localDataSource.cacheVerseTafsir(verseId, tafsirSourceId, remoteTafsir);
      return remoteTafsir;
    } catch (e) {
      final localTafsir = await localDataSource.getVerseTafsir(verseId, tafsirSourceId);
      if (localTafsir.isNotEmpty) {
        return localTafsir;
      }
      throw Exception("Failed to fetch verse tafsir and no local cache available: $e");
    }
  }

  @override
  Future<String> addBookmark(String userId, int verseId) async {
    try {
      final bookmarkId = await remoteDataSource.addBookmark(userId, verseId);
      await getBookmarks(userId);
      return bookmarkId;
    } catch (e) {
      throw Exception("Failed to add bookmark: $e");
    }
  }

  @override
  Future<bool> removeBookmark(String userId, int verseId) async {
    try {
      final success = await remoteDataSource.removeBookmark(userId, verseId);
      await getBookmarks(userId);
      return success;
    } catch (e) {
      throw Exception("Failed to remove bookmark: $e");
    }
  }

  @override
  Future<List<Bookmark>> getBookmarks(String userId) async {
    try {
      final remoteBookmarks = await remoteDataSource.getBookmarks(userId);
      await localDataSource.cacheBookmarks(userId, remoteBookmarks);
      return remoteBookmarks;
    } catch (e) {
      final localBookmarks = await localDataSource.getBookmarks(userId);
      if (localBookmarks.isNotEmpty) {
        return localBookmarks;
      }
      throw Exception("Failed to fetch bookmarks and no local cache available: $e");
    }
  }

  @override
  Future<void> saveReadingProgress(String userId, int surahId, int verseId) async {
    try {
      await remoteDataSource.saveReadingProgress(userId, surahId, verseId);
      final readingProgress = ReadingProgressModel(userId: userId, lastSurahId: surahId, lastVerseId: verseId, updatedAt: DateTime.now());
      await localDataSource.cacheReadingProgress(userId, readingProgress);
    } catch (e) {
      throw Exception("Failed to save reading progress: $e");
    }
  }

  @override
  Future<ReadingProgress?> getReadingProgress(String userId) async {
    try {
      final remoteProgress = await remoteDataSource.getReadingProgress(userId);
      if (remoteProgress != null) {
        await localDataSource.cacheReadingProgress(userId, remoteProgress);
        return remoteProgress;
      }
      return null;
    } catch (e) {
      final localProgress = await localDataSource.getReadingProgress(userId);
      return localProgress;
    }
  }
}
