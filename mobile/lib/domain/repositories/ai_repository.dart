import 'package:dartz/dartz.dart';
import '../../core/errors/failures.dart';
import '../entities/speech_result.dart';
import '../entities/writing_result.dart';
import '../entities/quiz_result.dart';

abstract class AiRepository {
  Future<Either<Failure, SpeechResult>> analyzeSpeech(String audioPath, String targetText);
  Future<Either<Failure, WritingResult>> correctWriting(String text, {String? context});
  Future<Either<Failure, QuizResult>> generateQuiz(String topic, {String type, int count, String difficulty});
}
