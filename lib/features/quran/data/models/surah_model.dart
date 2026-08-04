import 'package:hive/hive.dart';
import '../../domain/entities/surah.dart';

part 'surah_model.g.dart';

@HiveType(typeId: 0)
class SurahModel extends Surah {
  @HiveField(0)
  final int id;
  @HiveField(1)
  final String nameAr;
  @HiveField(2)
  final String nameEn;
  @HiveField(3)
  final String revelationType;
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
      id: json['id'] ?? 0,
      nameAr: json['nameAr'] ?? '',
      nameEn: json['nameEn'] ?? '',
      revelationType: json['revelationType'] ?? '',
      totalVerses: json['totalVerses'] ?? 0,
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
