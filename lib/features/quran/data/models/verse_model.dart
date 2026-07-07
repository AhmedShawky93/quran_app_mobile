import '../../domain/entities/verse.dart';

class VerseModel extends Verse {
  const VerseModel({
    required super.id,
    required super.surahId,
    required super.verseNumber,
    required super.textUthmani,
    required super.textSimple,
  });

  factory VerseModel.fromJson(Map<String, dynamic> json) {
    return VerseModel(
      id: json['id'],
      surahId: json['surahId'],
      verseNumber: json['verseNumber'],
      textUthmani: json['textUthmani'],
      textSimple: json['textSimple'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'surahId': surahId,
      'verseNumber': verseNumber,
      'textUthmani': textUthmani,
      'textSimple': textSimple,
    };
  }
}
