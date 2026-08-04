import 'package:equatable/equatable.dart';
import 'package:quran_app_mobile/features/quran/domain/entities/tafsir_source.dart';

abstract class TafsirState extends Equatable {
  const TafsirState();

  @override
  List<Object?> get props => [];
}

class TafsirInitial extends TafsirState {}

class TafsirLoading extends TafsirState {}

class TafsirSourcesLoaded extends TafsirState {
  final List<TafsirSource> sources;
  final TafsirSource? selectedSource;

  const TafsirSourcesLoaded(this.sources, {this.selectedSource});

  @override
  List<Object?> get props => [sources, selectedSource];
}

class VerseTafsirLoaded extends TafsirState {
  final String tafsirText;
  final TafsirSource selectedSource;
  final List<TafsirSource> sources;

  const VerseTafsirLoaded(this.tafsirText, this.selectedSource, this.sources);

  @override
  List<Object?> get props => [tafsirText, selectedSource, sources];
}

class TafsirError extends TafsirState {
  final String message;

  const TafsirError(this.message);

  @override
  List<Object?> get props => [message];
}
