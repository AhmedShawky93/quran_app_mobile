import 'package:quran_app_mobile/features/quran/domain/repositories/quran_repository.dart';

class AddBookmarkUseCase {
  final QuranRepository repository;

  AddBookmarkUseCase(this.repository);

  Future<String> call(String userId, int verseId) async {
    return await repository.addBookmark(userId, verseId);
  }
}
