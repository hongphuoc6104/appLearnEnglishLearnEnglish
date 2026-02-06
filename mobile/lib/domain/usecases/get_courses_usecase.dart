import 'package:dartz/dartz.dart';
import '../../core/errors/failures.dart';
import '../entities/course.dart';
import '../repositories/course_repository.dart';

class GetCoursesUseCase {
  final CourseRepository repository;
  const GetCoursesUseCase(this.repository);

  Future<Either<Failure, List<Course>>> call() {
    return repository.getCourses();
  }
}
