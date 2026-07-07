import 'package:hive/hive.dart';
import '../../domain/entities/surah.dart';

part 'surah_model.g.dart';

@HiveType(typeId: 0)
class SurahModel extends Surah {
  const SurahModel({
    @HiveField(0) required super.id,
    @HiveField(1) required super.nameAr,
    @HiveField(2) required super.nameEn,
    @HiveField(3) required super.revelationType,
    @HiveField(4) required super.totalVerses,
  });

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
