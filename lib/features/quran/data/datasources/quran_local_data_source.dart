import 'package:hive/hive.dart';
import '../models/surah_model.dart';

abstract class QuranLocalDataSource {
  Future<List<SurahModel>> getSurahs();
  Future<void> cacheSurahs(List<SurahModel> surahs);
}

class QuranLocalDataSourceImpl implements QuranLocalDataSource {
  static const boxName = 'surahsBox';

  @override
  Future<List<SurahModel>> getSurahs() async {
    final box = await Hive.openBox<SurahModel>(boxName);
    return box.values.toList();
  }

  @override
  Future<void> cacheSurahs(List<SurahModel> surahs) async {
    final box = await Hive.openBox<SurahModel>(boxName);
    await box.clear();
    await box.addAll(surahs);
  }
}
