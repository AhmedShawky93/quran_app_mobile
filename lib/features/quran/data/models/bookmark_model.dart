import 'package:hive/hive.dart';
import '../../domain/entities/bookmark.dart';

part 'bookmark_model.g.dart';

@HiveType(typeId: 2) // Ensure unique typeId
class BookmarkModel extends Bookmark {
  const BookmarkModel({
    @HiveField(0) required super.id,
    @HiveField(1) required super.userId,
    @HiveField(2) required super.verseId,
    @HiveField(3) required super.createdAt,
  });

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
