import 'package:equatable/equatable.dart';
import '../../../domain/entities/speech_result.dart';

abstract class SpeechState extends Equatable {
  const SpeechState();
  @override
  List<Object?> get props => [];
}

class SpeechInitial extends SpeechState {
  const SpeechInitial();
}

class SpeechRecording extends SpeechState {
  const SpeechRecording();
}

class SpeechAnalyzing extends SpeechState {
  const SpeechAnalyzing();
}

class SpeechAnalyzed extends SpeechState {
  final SpeechResult result;
  const SpeechAnalyzed(this.result);
  @override
  List<Object?> get props => [result];
}

class SpeechError extends SpeechState {
  final String message;
  const SpeechError(this.message);
  @override
  List<Object?> get props => [message];
}
