import 'package:dartz/dartz.dart';
import '../../core/errors/failures.dart';
import '../entities/speech_result.dart';
import '../repositories/ai_repository.dart';

class AnalyzeSpeechUseCase {
  final AiRepository repository;
  const AnalyzeSpeechUseCase(this.repository);

  Future<Either<Failure, SpeechResult>> call(String audioPath, String targetText) {
    return repository.analyzeSpeech(audioPath, targetText);
  }
}
