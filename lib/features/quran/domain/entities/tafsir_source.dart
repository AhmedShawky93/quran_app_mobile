import 'package:equatable/equatable.dart';

class TafsirSource extends Equatable {
  final int id;
  final String name;
  final String author;
  final String language;

  const TafsirSource({
    required this.id,
    required this.name,
    required this.author,
    required this.language,
  });

  @override
  List<Object> get props => [id, name, author, language];
}
