import 'package:quran_app_mobile/features/quran/domain/repositories/quran_repository.dart';

class GetVerseTafsirUseCase {
  final QuranRepository repository;

  GetVerseTafsirUseCase(this.repository);

  Future<String> call(int verseId, int tafsirSourceId) async {
    return await repository.getVerseTafsir(verseId, tafsirSourceId);
  }
}
