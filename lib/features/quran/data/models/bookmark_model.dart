import 'package:hive/hive.dart';
import '../../domain/entities/bookmark.dart';

part 'bookmark_model.g.dart';

@HiveType(typeId: 2)
class BookmarkModel extends Bookmark {
  @HiveField(0)
  final String id;
  @HiveField(1)
  final String userId;
  @HiveField(2)
  final int verseId;
  @HiveField(3)
  final DateTime createdAt;

  const BookmarkModel({
    required this.id,
    required this.userId,
    required this.verseId,
    required this.createdAt,
  }) : super(
          id: id,
          userId: userId,
          verseId: verseId,
          createdAt: createdAt,
        );

  factory BookmarkModel.fromJson(Map<String, dynamic> json) {
    return BookmarkModel(
      id: json['id'] as String,
      userId: json['userId'] as String,
      verseId: json['verseId'] as int,
      createdAt: DateTime.parse(json['createdAt'] as String),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'userId': userId,
      'verseId': verseId,
      'createdAt': createdAt.toIso8601String(),
    };
  }
}
