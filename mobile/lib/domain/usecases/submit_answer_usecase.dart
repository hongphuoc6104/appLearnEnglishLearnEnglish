import 'package:dartz/dartz.dart';
import '../../core/errors/failures.dart';
import '../repositories/lesson_repository.dart';

class SubmitAnswerUseCase {
  final LessonRepository repository;
  const SubmitAnswerUseCase(this.repository);

  Future<Either<Failure, Map<String, dynamic>>> call(String challengeId, String answer) {
    return repository.submitAnswer(challengeId, answer);
  }
}
