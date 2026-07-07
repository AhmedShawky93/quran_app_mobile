import 'package:quran_app_mobile/features/quran/domain/repositories/quran_repository.dart';

class RemoveBookmarkUseCase {
  final QuranRepository repository;

  RemoveBookmarkUseCase(this.repository);

  Future<bool> call(String userId, int verseId) async {
    return await repository.removeBookmark(userId, verseId);
  }
}
