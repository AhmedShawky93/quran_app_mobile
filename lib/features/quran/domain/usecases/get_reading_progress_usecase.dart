import 'package:quran_app_mobile/features/quran/domain/entities/reading_progress.dart';
import 'package:quran_app_mobile/features/quran/domain/repositories/quran_repository.dart';

class GetReadingProgressUseCase {
  final QuranRepository repository;

  GetReadingProgressUseCase(this.repository);

  Future<ReadingProgress?> call(String userId) async {
    return await repository.getReadingProgress(userId);
  }
}
