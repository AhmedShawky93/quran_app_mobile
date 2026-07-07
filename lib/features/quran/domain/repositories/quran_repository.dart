import '../entities/surah.dart';

import '../entities/verse.dart';

abstract class QuranRepository {
  Future<List<Surah>> getSurahs();
  Future<List<Verse>> getSurahVerses(int surahId);
  Future<List<TafsirSource>> getTafsirSources();
  Future<String> getVerseTafsir(int verseId, int tafsirSourceId);
  Future<String> addBookmark(String userId, int verseId);
  Future<bool> removeBookmark(String userId, int verseId);
  Future<List<Bookmark>> getBookmarks(String userId);
  Future<void> saveReadingProgress(String userId, int surahId, int verseId);
  Future<ReadingProgress?> getReadingProgress(String userId);
}
