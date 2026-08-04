import 'package:equatable/equatable.dart';
import 'package:quran_app_mobile/features/quran/domain/entities/bookmark.dart';

abstract class BookmarkState extends Equatable {
  const BookmarkState();

  @override
  List<Object?> get props => [];
}

class BookmarkInitial extends BookmarkState {}

class BookmarkLoading extends BookmarkState {}

class BookmarksLoaded extends BookmarkState {
  final List<Bookmark> bookmarks;

  const BookmarksLoaded(this.bookmarks);

  @override
  List<Object?> get props => [bookmarks];
}

class BookmarkActionSuccess extends BookmarkState {
  final String message;

  const BookmarkActionSuccess(this.message);

  @override
  List<Object?> get props => [message];
}

class BookmarkError extends BookmarkState {
  final String message;

  const BookmarkError(this.message);

  @override
  List<Object?> get props => [message];
}
