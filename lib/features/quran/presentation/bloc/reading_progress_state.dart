import 'package:equatable/equatable.dart';
import 'package:quran_app_mobile/features/quran/domain/entities/reading_progress.dart';

abstract class ReadingProgressState extends Equatable {
  const ReadingProgressState();

  @override
  List<Object?> get props => [];
}

class ReadingProgressInitial extends ReadingProgressState {}

class ReadingProgressLoading extends ReadingProgressState {}

class ReadingProgressLoaded extends ReadingProgressState {
  final ReadingProgress? readingProgress;

  const ReadingProgressLoaded(this.readingProgress);

  @override
  List<Object?> get props => [readingProgress];
}

class ReadingProgressError extends ReadingProgressState {
  final String message;

  const ReadingProgressError(this.message);

  @override
  List<Object?> get props => [message];
}
