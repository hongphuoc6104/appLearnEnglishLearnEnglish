import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../domain/usecases/analyze_speech_usecase.dart';
import 'speech_event.dart';
import 'speech_state.dart';

class SpeechBloc extends Bloc<SpeechEvent, SpeechState> {
  final AnalyzeSpeechUseCase analyzeSpeechUseCase;

  SpeechBloc({required this.analyzeSpeechUseCase}) : super(const SpeechInitial()) {
    on<StartRecording>(_onStartRecording);
    on<StopRecording>(_onStopRecording);
    on<AnalyzeSpeech>(_onAnalyzeSpeech);
    on<ResetSpeech>(_onResetSpeech);
  }

  void _onStartRecording(StartRecording event, Emitter<SpeechState> emit) {
    emit(const SpeechRecording());
  }

  void _onStopRecording(StopRecording event, Emitter<SpeechState> emit) {
    emit(const SpeechInitial());
  }

  Future<void> _onAnalyzeSpeech(AnalyzeSpeech event, Emitter<SpeechState> emit) async {
    emit(const SpeechAnalyzing());
    final result = await analyzeSpeechUseCase(event.audioPath, event.targetText);
    result.fold(
      (failure) => emit(SpeechError(failure.message)),
      (speechResult) => emit(SpeechAnalyzed(speechResult)),
    );
  }

  void _onResetSpeech(ResetSpeech event, Emitter<SpeechState> emit) {
    emit(const SpeechInitial());
  }
}
