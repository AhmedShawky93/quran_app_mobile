import '../models/surah_model.dart';
import '../../../../core/network/api_client.dart';
import '../models/tafsir_source_model.dart';
import '../models/bookmark_model.dart';
import '../models/reading_progress_model.dart';

import '../models/verse_model.dart';

abstract class QuranRemoteDataSource {
  Future<List<SurahModel>> getSurahs();
  Future<List<VerseModel>> getSurahVerses(int surahId);
  Future<List<TafsirSourceModel>> getTafsirSources();
  Future<String> getVerseTafsir(int verseId, int tafsirSourceId);
  Future<String> addBookmark(String userId, int verseId);
  Future<bool> removeBookmark(String userId, int verseId);
  Future<List<BookmarkModel>> getBookmarks(String userId);
  Future<void> saveReadingProgress(String userId, int surahId, int verseId);
  Future<ReadingProgressModel?> getReadingProgress(String userId);
}

class QuranRemoteDataSourceImpl implements QuranRemoteDataSource {
  final ApiClient apiClient;

  QuranRemoteDataSourceImpl(this.apiClient);

  @override
  Future<List<SurahModel>> getSurahs() async {
    final response = await apiClient.dio.get('quran/surahs');
    if (response.statusCode == 200) {
      return (response.data as List)
          .map((json) => SurahModel.fromJson(json))
          .toList();
    } else {
      throw Exception('Failed to load surahs');
    }
  }

  @override
  Future<List<VerseModel>> getSurahVerses(int surahId) async {
    final response = await apiClient.dio.get('quran/surahs/$surahId/verses');
    if (response.statusCode == 200) {
      return (response.data as List)
          .map((json) => VerseModel.fromJson(json))
          .toList();
    } else {
      throw Exception('Failed to load verses');
    }
  }

  @override
  Future<List<TafsirSourceModel>> getTafsirSources() async {
    final response = await apiClient.dio.get('quran/tafsir-sources');
    if (response.statusCode == 200) {
      return (response.data as List)
          .map((json) => TafsirSourceModel.fromJson(json))
          .toList();
    } else {
      throw Exception('Failed to load tafsir sources');
    }
  }

  @override
  Future<String> getVerseTafsir(int verseId, int tafsirSourceId) async {
    final response = await apiClient.dio.get('quran/verses/$verseId/tafsir', queryParameters: {'sourceId': tafsirSourceId});
    if (response.statusCode == 200) {
      return response.data['text'];
    } else {
      throw Exception('Failed to load verse tafsir');
    }
  }

  @override
  Future<String> addBookmark(String userId, int verseId) async {
    final response = await apiClient.dio.post('bookmarks', data: {'userId': userId, 'verseId': verseId});
    if (response.statusCode == 200) {
      return response.data['id'];
    } else {
      throw Exception('Failed to add bookmark');
    }
  }

  @override
  Future<bool> removeBookmark(String userId, int verseId) async {
    final response = await apiClient.dio.delete('bookmarks', data: {'userId': userId, 'verseId': verseId});
    if (response.statusCode == 200) {
      return response.data;
    } else {
      throw Exception('Failed to remove bookmark');
    }
  }

  @override
  Future<List<BookmarkModel>> getBookmarks(String userId) async {
    final response = await apiClient.dio.get('bookmarks', queryParameters: {'userId': userId});
    if (response.statusCode == 200) {
      return (response.data as List)
          .map((json) => BookmarkModel.fromJson(json))
          .toList();
    } else {
      throw Exception('Failed to get bookmarks');
    }
  }

  @override
  Future<void> saveReadingProgress(String userId, int surahId, int verseId) async {
    final response = await apiClient.dio.post('readingprogress', data: {'userId': userId, 'lastSurahId': surahId, 'lastVerseId': verseId});
    if (response.statusCode != 204) {
      throw Exception('Failed to save reading progress');
    }
  }

  @override
  Future<ReadingProgressModel?> getReadingProgress(String userId) async {
    final response = await apiClient.dio.get('readingprogress', queryParameters: {'userId': userId});
    if (response.statusCode == 200) {
      return ReadingProgressModel.fromJson(response.data);
    } else if (response.statusCode == 404) {
      return null;
    } else {
      throw Exception('Failed to get reading progress');
    }
  }
}
