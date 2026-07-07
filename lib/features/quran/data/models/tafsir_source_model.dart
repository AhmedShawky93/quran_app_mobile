import 'package:hive/hive.dart';
import '../../domain/entities/tafsir_source.dart';

part 'tafsir_source_model.g.dart';

@HiveType(typeId: 1) // Ensure unique typeId
class TafsirSourceModel extends TafsirSource {
  const TafsirSourceModel({
    @HiveField(0) required super.id,
    @HiveField(1) required super.name,
    @HiveField(2) required super.author,
    @HiveField(3) required super.language,
  });

  factory TafsirSourceModel.fromJson(Map<String, dynamic> json) {
    return TafsirSourceModel(
      id: json["id"],
      name: json["name"],
      author: json["author"],
      language: json["language"],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      "id": id,
      "name": name,
      "author": author,
      "language": language,
    };
  }
}
