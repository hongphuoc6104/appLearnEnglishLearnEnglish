import 'package:dartz/dartz.dart' hide Unit;
import '../../core/errors/failures.dart';
import '../entities/course.dart';
import '../entities/unit.dart';

abstract class CourseRepository {
  Future<Either<Failure, List<Course>>> getCourses();
  Future<Either<Failure, Course>> getCourseById(String id);
  Future<Either<Failure, List<Unit>>> getCourseUnits(String courseId);
}
