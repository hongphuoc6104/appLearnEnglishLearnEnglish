import 'package:dartz/dartz.dart';
import '../../core/errors/exceptions.dart';
import '../../core/errors/failures.dart';
import '../../domain/entities/challenge.dart';
import '../../domain/entities/progress.dart';
import '../../domain/repositories/lesson_repository.dart';
import '../datasources/lesson_remote_datasource.dart';

class LessonRepositoryImpl implements LessonRepository {
  final LessonRemoteDatasource remoteDatasource;
  const LessonRepositoryImpl(this.remoteDatasource);

  @override
  Future<Either<Failure, List<Challenge>>> getLessonChallenges(String lessonId) async {
    try { return Right(await remoteDatasource.getLessonChallenges(lessonId)); }
    on ServerException catch (e) { return Left(ServerFailure(e.message)); }
    catch (e) { return Left(NetworkFailure(e.toString())); }
  }

  @override
  Future<Either<Failure, Map<String, dynamic>>> submitAnswer(String challengeId, String answer) async {
    try { return Right(await remoteDatasource.submitAnswer(challengeId, answer)); }
    on ServerException catch (e) { return Left(ServerFailure(e.message)); }
    catch (e) { return Left(NetworkFailure(e.toString())); }
  }

  @override
  Future<Either<Failure, Progress>> getCourseProgress(String courseId) async {
    try { return Right(await remoteDatasource.getCourseProgress(courseId)); }
    on ServerException catch (e) { return Left(ServerFailure(e.message)); }
    catch (e) { return Left(NetworkFailure(e.toString())); }
  }

  @override
  Future<Either<Failure, Map<String, dynamic>>> refillHearts() async {
    try { return Right(await remoteDatasource.refillHearts()); }
    on ServerException catch (e) { return Left(ServerFailure(e.message)); }
    catch (e) { return Left(NetworkFailure(e.toString())); }
  }
}
