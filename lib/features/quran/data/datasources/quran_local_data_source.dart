import 'package:hive/hive.dart';
import '../models/surah_model.dart';
import '../models/tafsir_source_model.dart';
import '../models/bookmark_model.dart';
import '../models/reading_progress_model.dart';

abstract class QuranLocalDataSource {
  Future<List<SurahModel>> getSurahs();
  Future<void> cacheSurahs(List<SurahModel> surahs);
  Future<List<TafsirSourceModel>> getTafsirSources();
  Future<void> cacheTafsirSources(List<TafsirSourceModel> tafsirSources);
  Future<String> getVerseTafsir(int verseId, int tafsirSourceId);
  Future<void> cacheVerseTafsir(int verseId, int tafsirSourceId, String tafsirText);
  Future<List<BookmarkModel>> getBookmarks(String userId);
  Future<void> cacheBookmarks(String userId, List<BookmarkModel> bookmarks);
  Future<ReadingProgressModel?> getReadingProgress(String userId);
  Future<void> cacheReadingProgress(String userId, ReadingProgressModel readingProgress);
}

class QuranLocalDataSourceImpl implements QuranLocalDataSource {
  static const surahsBoxName = 'surahsBox';
  static const tafsirSourcesBoxName = 'tafsirSourcesBox';
  static const verseTafsirBoxName = 'verseTafsirBox';
  static const bookmarksBoxName = 'bookmarksBox';
  static const readingProgressBoxName = 'readingProgressBox';

  @override
  Future<List<SurahModel>> getSurahs() async {
    final box = await Hive.openBox<SurahModel>(surahsBoxName);
    return box.values.toList();
  }

  @override
  Future<void> cacheSurahs(List<SurahModel> surahs) async {
    final box = await Hive.openBox<SurahModel>(surahsBoxName);
    await box.clear();
    await box.addAll(surahs);
  }

  @override
  Future<List<TafsirSourceModel>> getTafsirSources() async {
    final box = await Hive.openBox<TafsirSourceModel>(tafsirSourcesBoxName);
    return box.values.toList();
  }

  @override
  Future<void> cacheTafsirSources(List<TafsirSourceModel> tafsirSources) async {
    final box = await Hive.openBox<TafsirSourceModel>(tafsirSourcesBoxName);
    await box.clear();
    await box.addAll(tafsirSources);
  }

  @override
  Future<String> getVerseTafsir(int verseId, int tafsirSourceId) async {
    final box = await Hive.openBox<String>(verseTafsirBoxName);
    return box.get('tafsir_${verseId}_$tafsirSourceId') ?? '';
  }

  @override
  Future<void> cacheVerseTafsir(int verseId, int tafsirSourceId, String tafsirText) async {
    final box = await Hive.openBox<String>(verseTafsirBoxName);
    await box.put('tafsir_${verseId}_$tafsirSourceId', tafsirText);
  }

  @override
  Future<List<BookmarkModel>> getBookmarks(String userId) async {
    final box = await Hive.openBox<BookmarkModel>(bookmarksBoxName);
    return box.values.where((b) => b.userId == userId).toList();
  }

  @override
  Future<void> cacheBookmarks(String userId, List<BookmarkModel> bookmarks) async {
    final box = await Hive.openBox<BookmarkModel>(bookmarksBoxName);
    await box.clear(); // Clear existing bookmarks for this user
    await box.addAll(bookmarks);
  }

  @override
  Future<ReadingProgressModel?> getReadingProgress(String userId) async {
    final box = await Hive.openBox<ReadingProgressModel>(readingProgressBoxName);
    return box.get(userId);
  }

  @override
  Future<void> cacheReadingProgress(String userId, ReadingProgressModel readingProgress) async {
    final box = await Hive.openBox<ReadingProgressModel>(readingProgressBoxName);
    await box.put(userId, readingProgress);
  }
}
