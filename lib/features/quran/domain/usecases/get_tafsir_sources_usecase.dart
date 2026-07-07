import 'package:quran_app_mobile/features/quran/domain/entities/tafsir_source.dart';
import 'package:quran_app_mobile/features/quran/domain/repositories/quran_repository.dart';

class GetTafsirSourcesUseCase {
  final QuranRepository repository;

  GetTafsirSourcesUseCase(this.repository);

  Future<List<TafsirSource>> call() async {
    return await repository.getTafsirSources();
  }
}
