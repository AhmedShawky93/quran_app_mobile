import 'package:equatable/equatable.dart';

class Surah extends Equatable {
  final int id;
  final String nameAr;
  final String nameEn;
  final String revelationType;
  final int totalVerses;

  const Surah({
    this.id = 0,
    this.nameAr = '',
    this.nameEn = '',
    this.revelationType = '',
    this.totalVerses = 0,
  });

  @override
  List<Object> get props => [id, nameAr, nameEn, revelationType, totalVerses];
}
