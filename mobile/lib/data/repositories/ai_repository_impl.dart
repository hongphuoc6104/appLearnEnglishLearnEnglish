import 'package:dartz/dartz.dart';
import '../../core/errors/exceptions.dart';
import '../../core/errors/failures.dart';
import '../../domain/entities/speech_result.dart';
import '../../domain/entities/writing_result.dart';
import '../../domain/entities/quiz_result.dart';
import '../../domain/repositories/ai_repository.dart';
import '../datasources/ai_remote_datasource.dart';

class AiRepositoryImpl implements AiRepository {
  final AiRemoteDatasource remoteDatasource;
  const AiRepositoryImpl(this.remoteDatasource);

  @override
  Future<Either<Failure, SpeechResult>> analyzeSpeech(String audioPath, String targetText) async {
    try { return Right(await remoteDatasource.analyzeSpeech(audioPath, targetText)); }
    on ServerException catch (e) { return Left(ServerFailure(e.message)); }
    catch (e) { return Left(NetworkFailure(e.toString())); }
  }

  @override
  Future<Either<Failure, WritingResult>> correctWriting(String text, {String? context}) async {
    try { return Right(await remoteDatasource.correctWriting(text, context: context)); }
    on ServerException catch (e) { return Left(ServerFailure(e.message)); }
    catch (e) { return Left(NetworkFailure(e.toString())); }
  }

  @override
  Future<Either<Failure, QuizResult>> generateQuiz(String topic, {String type = 'mcq', int count = 5, String difficulty = 'intermediate'}) async {
    try { return Right(await remoteDatasource.generateQuiz(topic, type: type, count: count, difficulty: difficulty)); }
    on ServerException catch (e) { return Left(ServerFailure(e.message)); }
    catch (e) { return Left(NetworkFailure(e.toString())); }
  }
}
