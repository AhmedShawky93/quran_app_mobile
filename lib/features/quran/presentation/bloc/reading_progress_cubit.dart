import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:quran_app_mobile/features/quran/domain/usecases/save_reading_progress_usecase.dart';
import 'package:quran_app_mobile/features/quran/domain/usecases/get_reading_progress_usecase.dart';
import 'reading_progress_state.dart';

class ReadingProgressCubit extends Cubit<ReadingProgressState> {
  final SaveReadingProgressUseCase saveReadingProgressUseCase;
  final GetReadingProgressUseCase getReadingProgressUseCase;

  ReadingProgressCubit(this.saveReadingProgressUseCase, this.getReadingProgressUseCase) : super(ReadingProgressInitial());

  Future<void> loadReadingProgress(String userId) async {
    emit(ReadingProgressLoading());
    try {
      final progress = await getReadingProgressUseCase(userId);
      emit(ReadingProgressLoaded(progress));
    } catch (e) {
      emit(ReadingProgressError(e.toString()));
    }
  }

  Future<void> saveReadingProgress(String userId, int surahId, int verseId) async {
    try {
      await saveReadingProgressUseCase(userId, surahId, verseId);
      emit(ReadingProgressLoaded(state is ReadingProgressLoaded ? (state as ReadingProgressLoaded).readingProgress : null)); // Optionally update state with new progress
    } catch (e) {
      emit(ReadingProgressError(e.toString()));
    }
  }
}
