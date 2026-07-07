import 'package:flutter_bloc/flutter_bloc.dart';
import '../../domain/usecases/get_surah_verses_usecase.dart';
import 'verse_state.dart';

class VerseCubit extends Cubit<VerseState> {
  final GetSurahVersesUseCase getSurahVersesUseCase;

  VerseCubit(this.getSurahVersesUseCase) : super(VerseInitial());

  Future<void> fetchVerses(int surahId) async {
    emit(VerseLoading());
    try {
      final verses = await getSurahVersesUseCase(surahId);
      if (verses.isEmpty) {
        emit(const VerseError("No verses found for this surah."));
      } else {
        emit(VerseLoaded(verses));
      }
    } catch (e) {
      emit(VerseError(e.toString()));
    }
  }
}
