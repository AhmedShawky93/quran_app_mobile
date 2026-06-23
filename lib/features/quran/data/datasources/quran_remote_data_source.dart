import '../models/surah_model.dart';
import '../../../../core/network/api_client.dart';

abstract class QuranRemoteDataSource {
  Future<List<SurahModel>> getSurahs();
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
}
