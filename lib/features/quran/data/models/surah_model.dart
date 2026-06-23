import 'package:hive/hive.dart';
import '../../domain/entities/surah.dart';

part 'surah_model.g.dart';

@HiveType(typeId: 0)
class SurahModel extends Surah {
  @override
  @HiveField(0)
  final int id;
  @override
  @HiveField(1)
  final String nameAr;
  @override
  @HiveField(2)
  final String nameEn;
  @override
  @HiveField(3)
  final String revelationType;
  @override
  @HiveField(4)
  final int totalVerses;

  const SurahModel({
    required this.id,
    required this.nameAr,
    required this.nameEn,
    required this.revelationType,
    required this.totalVerses,
  }) : super(
         id: id,
         nameAr: nameAr,
         nameEn: nameEn,
         revelationType: revelationType,
         totalVerses: totalVerses,
       );

  factory SurahModel.fromJson(Map<String, dynamic> json) {
    return SurahModel(
      id: json['id'],
      nameAr: json['nameAr'],
      nameEn: json['nameEn'],
      revelationType: json['revelationType'],
      totalVerses: json['totalVerses'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'nameAr': nameAr,
      'nameEn': nameEn,
      'revelationType': revelationType,
      'totalVerses': totalVerses,
    };
  }
}
