import 'package:hive/hive.dart';
import '../../domain/entities/reading_progress.dart';

part 'reading_progress_model.g.dart';

@HiveType(typeId: 3)
class ReadingProgressModel extends ReadingProgress {
  @HiveField(0)
  final String userId;
  @HiveField(1)
  final int lastSurahId;
  @HiveField(2)
  final int lastVerseId;
  @HiveField(3)
  final DateTime updatedAt;

  const ReadingProgressModel({
    required this.userId,
    required this.lastSurahId,
    required this.lastVerseId,
    required this.updatedAt,
  }) : super(
          userId: userId,
          lastSurahId: lastSurahId,
          lastVerseId: lastVerseId,
          updatedAt: updatedAt,
        );

  factory ReadingProgressModel.fromJson(Map<String, dynamic> json) {
    return ReadingProgressModel(
      userId: json['userId'] as String,
      lastSurahId: json['lastSurahId'] as int,
      lastVerseId: json['lastVerseId'] as int,
      updatedAt: DateTime.parse(json['updatedAt'] as String),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'userId': userId,
      'lastSurahId': lastSurahId,
      'lastVerseId': lastVerseId,
      'updatedAt': updatedAt.toIso8601String(),
    };
  }
}
