import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:quran_app_mobile/features/quran/domain/entities/tafsir_source.dart';
import 'package:quran_app_mobile/features/quran/domain/usecases/get_tafsir_sources_usecase.dart';
import 'package:quran_app_mobile/features/quran/domain/usecases/get_verse_tafsir_usecase.dart';
import 'tafsir_state.dart';

class TafsirCubit extends Cubit<TafsirState> {
  final GetTafsirSourcesUseCase getTafsirSourcesUseCase;
  final GetVerseTafsirUseCase getVerseTafsirUseCase;

  TafsirSource? _selectedSource;
  List<TafsirSource> _tafsirSources = [];

  TafsirCubit(this.getTafsirSourcesUseCase, this.getVerseTafsirUseCase) : super(TafsirInitial());

  Future<void> fetchTafsirSources() async {
    emit(TafsirLoading());
    try {
      _tafsirSources = await getTafsirSourcesUseCase();
      if (_tafsirSources.isNotEmpty) {
        _selectedSource = _tafsirSources.first;
        emit(TafsirSourcesLoaded(_tafsirSources, selectedSource: _selectedSource));
      } else {
        emit(const TafsirError('No Tafsir sources found.'));
      }
    } catch (e) {
      emit(TafsirError(e.toString()));
    }
  }

  Future<void> getVerseTafsir(int verseId) async {
    if (_selectedSource == null) {
      emit(const TafsirError('No Tafsir source selected.'));
      return;
    }
    emit(TafsirLoading());
    try {
      final tafsirText = await getVerseTafsirUseCase(verseId, _selectedSource!.id);
      emit(VerseTafsirLoaded(tafsirText, _selectedSource!, _tafsirSources));
    } catch (e) {
      emit(TafsirError(e.toString()));
    }
  }

  void selectTafsirSource(TafsirSource source) {
    _selectedSource = source;
    emit(TafsirSourcesLoaded(_tafsirSources, selectedSource: _selectedSource));
  }
}
