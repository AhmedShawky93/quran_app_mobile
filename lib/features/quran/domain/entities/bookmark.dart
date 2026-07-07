import 'package:equatable/equatable.dart';

class Bookmark extends Equatable {
  final String id;
  final String userId;
  final int verseId;
  final DateTime createdAt;

  const Bookmark({
    required this.id,
    required this.userId,
    required this.verseId,
    required this.createdAt,
  });

  @override
  List<Object> get props => [id, userId, verseId, createdAt];
}
