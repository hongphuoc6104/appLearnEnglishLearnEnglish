import 'package:dartz/dartz.dart';
import '../../core/errors/failures.dart';
import '../entities/quiz_result.dart';
import '../repositories/ai_repository.dart';

class GenerateQuizUseCase {
  final AiRepository repository;
  const GenerateQuizUseCase(this.repository);

  Future<Either<Failure, QuizResult>> call(String topic, {String type = 'mcq', int count = 5, String difficulty = 'intermediate'}) {
    return repository.generateQuiz(topic, type: type, count: count, difficulty: difficulty);
  }
}
