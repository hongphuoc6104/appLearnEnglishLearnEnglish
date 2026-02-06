import 'package:dartz/dartz.dart';
import '../../core/errors/failures.dart';
import '../entities/writing_result.dart';
import '../repositories/ai_repository.dart';

class CorrectWritingUseCase {
  final AiRepository repository;
  const CorrectWritingUseCase(this.repository);

  Future<Either<Failure, WritingResult>> call(String text, {String? context}) {
    return repository.correctWriting(text, context: context);
  }
}
