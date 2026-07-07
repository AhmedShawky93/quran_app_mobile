import 'package:equatable/equatable.dart';

class Verse extends Equatable {
  final int id;
  final int surahId;
  final int verseNumber;
  final String textUthmani;
  final String textSimple;

  const Verse({
    required this.id,
    required this.surahId,
    required this.verseNumber,
    required this.textUthmani,
    required this.textSimple,
  });

  @override
  List<Object> get props => [id, surahId, verseNumber, textUthmani, textSimple];
}
