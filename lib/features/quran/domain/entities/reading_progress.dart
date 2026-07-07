import 'package:equatable/equatable.dart';

class ReadingProgress extends Equatable {
  final String userId;
  final int lastSurahId;
  final int lastVerseId;
  final DateTime updatedAt;

  const ReadingProgress({
    required this.userId,
    required this.lastSurahId,
    required this.lastVerseId,
    required this.updatedAt,
  });

  @override
  List<Object> get props => [userId, lastSurahId, lastVerseId, updatedAt];
}
