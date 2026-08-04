import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:quran_app_mobile/features/quran/domain/usecases/get_surahs_usecase.dart';
import 'surah_state.dart';

class SurahCubit extends Cubit<SurahState> {
  final GetSurahsUseCase getSurahsUseCase;

  SurahCubit(this.getSurahsUseCase) : super(SurahInitial());

  Future<void> fetchSurahs() async {
    emit(SurahLoading());
    try {
      final surahs = await getSurahsUseCase();
      if (surahs.isEmpty) {
        emit(const SurahError("No surahs found."));
      } else {
        emit(SurahLoaded(surahs));
      }
    } catch (e) {
      emit(SurahError(e.toString()));
    }
  }
}
