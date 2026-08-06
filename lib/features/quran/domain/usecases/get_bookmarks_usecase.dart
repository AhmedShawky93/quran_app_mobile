import 'package:quran_app_mobile/features/quran/domain/entities/bookmark.dart';
import 'package:quran_app_mobile/features/quran/domain/repositories/quran_repository.dart';

class GetBookmarksUseCase {
  final QuranRepository repository;

  GetBookmarksUseCase(this.repository);

  Future<List<Bookmark>> call(String userId) async {
    return await repository.getBookmarks(userId);
  }
}
