import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:quran_app_mobile/features/quran/domain/usecases/add_bookmark_usecase.dart';
import 'package:quran_app_mobile/features/quran/domain/usecases/remove_bookmark_usecase.dart';
import 'package:quran_app_mobile/features/quran/domain/usecases/get_bookmarks_usecase.dart';
import 'bookmark_state.dart';

class BookmarkCubit extends Cubit<BookmarkState> {
  final AddBookmarkUseCase addBookmarkUseCase;
  final RemoveBookmarkUseCase removeBookmarkUseCase;
  final GetBookmarksUseCase getBookmarksUseCase;

  BookmarkCubit(this.addBookmarkUseCase, this.removeBookmarkUseCase, this.getBookmarksUseCase) : super(BookmarkInitial());

  Future<void> fetchBookmarks(String userId) async {
    emit(BookmarkLoading());
    try {
      final bookmarks = await getBookmarksUseCase(userId);
      emit(BookmarksLoaded(bookmarks));
    } catch (e) {
      emit(BookmarkError(e.toString()));
    }
  }

  Future<void> addBookmark(String userId, int verseId) async {
    try {
      await addBookmarkUseCase(userId, verseId);
      await fetchBookmarks(userId); // Refresh bookmarks after adding
      emit(const BookmarkActionSuccess('Bookmark added successfully!'));
    } catch (e) {
      emit(BookmarkError(e.toString()));
    }
  }

  Future<void> removeBookmark(String userId, int verseId) async {
    try {
      await removeBookmarkUseCase(userId, verseId);
      await fetchBookmarks(userId); // Refresh bookmarks after removing
      emit(const BookmarkActionSuccess('Bookmark removed successfully!'));
    } catch (e) {
      emit(BookmarkError(e.toString()));
    }
  }

  bool isBookmarked(int verseId) {
    if (state is BookmarksLoaded) {
      return (state as BookmarksLoaded).bookmarks.any((b) => b.verseId == verseId);
    }
    return false;
  }
}
