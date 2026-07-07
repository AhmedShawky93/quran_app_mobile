import 'package:equatable/equatable.dart';
import '../../domain/entities/verse.dart';

abstract class VerseState extends Equatable {
  const VerseState();

  @override
  List<Object> get props => [];
}

class VerseInitial extends VerseState {}

class VerseLoading extends VerseState {}

class VerseLoaded extends VerseState {
  final List<Verse> verses;
  const VerseLoaded(this.verses);

  @override
  List<Object> get props => [verses];
}

class VerseError extends VerseState {
  final String message;
  const VerseError(this.message);

  @override
  List<Object> get props => [message];
}
