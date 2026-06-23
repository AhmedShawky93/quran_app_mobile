import 'package:equatable/equatable.dart';

class Surah extends Equatable {
  final int id;
  final String nameAr;
  final String nameEn;
  final String revelationType;
  final int totalVerses;

  const Surah({
    required this.id,
    required this.nameAr,
    required this.nameEn,
    required this.revelationType,
    required this.totalVerses,
  });

  @override
  List<Object> get props => [id, nameAr, nameEn, revelationType, totalVerses];
}
