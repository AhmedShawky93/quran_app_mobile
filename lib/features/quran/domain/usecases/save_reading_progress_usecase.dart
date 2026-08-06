import 'package:quran_app_mobile/features/quran/domain/repositories/quran_repository.dart';

class SaveReadingProgressUseCase {
  final QuranRepository repository;

  SaveReadingProgressUseCase(this.repository);

  Future<void> call(String userId, int surahId, int verseId) async {
    await repository.saveReadingProgress(userId, surahId, verseId);
  }
}
