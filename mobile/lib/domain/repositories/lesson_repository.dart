import 'package:dartz/dartz.dart';
import '../../core/errors/failures.dart';
import '../entities/challenge.dart';
import '../entities/progress.dart';

abstract class LessonRepository {
  Future<Either<Failure, List<Challenge>>> getLessonChallenges(String lessonId);
  Future<Either<Failure, Map<String, dynamic>>> submitAnswer(String challengeId, String answer);
  Future<Either<Failure, Progress>> getCourseProgress(String courseId);
  Future<Either<Failure, Map<String, dynamic>>> refillHearts();
}
