import 'package:equatable/equatable.dart';

abstract class SpeechEvent extends Equatable {
  const SpeechEvent();
  @override
  List<Object?> get props => [];
}

class StartRecording extends SpeechEvent {
  const StartRecording();
}

class StopRecording extends SpeechEvent {
  const StopRecording();
}

class AnalyzeSpeech extends SpeechEvent {
  final String audioPath;
  final String targetText;
  const AnalyzeSpeech({required this.audioPath, required this.targetText});
  @override
  List<Object?> get props => [audioPath, targetText];
}

class ResetSpeech extends SpeechEvent {
  const ResetSpeech();
}
