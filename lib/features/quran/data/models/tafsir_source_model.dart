import 'package:hive/hive.dart';
import '../../domain/entities/tafsir_source.dart';

part 'tafsir_source_model.g.dart';

@HiveType(typeId: 1)
class TafsirSourceModel extends TafsirSource {
  @HiveField(0)
  final int id;
  @HiveField(1)
  final String name;
  @HiveField(2)
  final String author;
  @HiveField(3)
  final String language;

  const TafsirSourceModel({
    required this.id,
    required this.name,
    required this.author,
    required this.language,
  }) : super(
          id: id,
          name: name,
          author: author,
          language: language,
        );

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
