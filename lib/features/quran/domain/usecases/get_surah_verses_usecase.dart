import '../entities/verse.dart';
import '../repositories/quran_repository.dart';

class GetSurahVersesUseCase {
  final QuranRepository repository;

  GetSurahVersesUseCase(this.repository);

  Future<List<Verse>> call(int surahId) async {
    return await repository.getSurahVerses(surahId);
  }
}
