import '../models/surah_model.dart';
import '../../../../core/network/api_client.dart';
import '../models/tafsir_source_model.dart';

import '../models/verse_model.dart';

abstract class QuranRemoteDataSource {
  Future<List<SurahModel>> getSurahs();
  Future<List<VerseModel>> getSurahVerses(int surahId);
  Future<List<TafsirSourceModel>> getTafsirSources();
  Future<String> getVerseTafsir(int verseId, int tafsirSourceId);
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
    final response = await apiClient.dio.get('quran/verses/$verseId/tafsir/$tafsirSourceId');
    if (response.statusCode == 200) {
      return response.data['text'];
    } else {
      throw Exception('Failed to load verse tafsir');
    }
  }
}
