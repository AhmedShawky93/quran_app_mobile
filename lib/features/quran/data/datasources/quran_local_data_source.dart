import 'package:hive/hive.dart';
import '../models/surah_model.dart';
import '../models/tafsir_source_model.dart';

abstract class QuranLocalDataSource {
  Future<List<SurahModel>> getSurahs();
  Future<void> cacheSurahs(List<SurahModel> surahs);
  Future<List<TafsirSourceModel>> getTafsirSources();
  Future<void> cacheTafsirSources(List<TafsirSourceModel> tafsirSources);
  Future<String> getVerseTafsir(int verseId, int tafsirSourceId);
  Future<void> cacheVerseTafsir(int verseId, int tafsirSourceId, String tafsirText);
}

class QuranLocalDataSourceImpl implements QuranLocalDataSource {
  static const surahsBoxName = 'surahsBox';
  static const tafsirSourcesBoxName = 'tafsirSourcesBox';
  static const verseTafsirBoxName = 'verseTafsirBox';

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
}
