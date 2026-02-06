import 'package:equatable/equatable.dart';
import '../../../domain/entities/writing_result.dart';

abstract class WritingState extends Equatable {
  const WritingState();
  @override
  List<Object?> get props => [];
}

class WritingInitial extends WritingState {
  const WritingInitial();
}

class WritingLoading extends WritingState {
  const WritingLoading();
}

class WritingCorrected extends WritingState {
  final WritingResult result;
  const WritingCorrected(this.result);
  @override
  List<Object?> get props => [result];
}

class WritingError extends WritingState {
  final String message;
  const WritingError(this.message);
  @override
  List<Object?> get props => [message];
}
