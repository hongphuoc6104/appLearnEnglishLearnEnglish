import 'package:dartz/dartz.dart' hide Unit;
import '../../core/errors/exceptions.dart';
import '../../core/errors/failures.dart';
import '../../domain/entities/course.dart';
import '../../domain/entities/unit.dart';
import '../../domain/repositories/course_repository.dart';
import '../datasources/course_remote_datasource.dart';

class CourseRepositoryImpl implements CourseRepository {
  final CourseRemoteDatasource remoteDatasource;
  const CourseRepositoryImpl(this.remoteDatasource);

  @override
  Future<Either<Failure, List<Course>>> getCourses() async {
    try { return Right(await remoteDatasource.getCourses()); }
    on ServerException catch (e) { return Left(ServerFailure(e.message)); }
    catch (e) { return Left(NetworkFailure(e.toString())); }
  }

  @override
  Future<Either<Failure, Course>> getCourseById(String id) async {
    try { return Right(await remoteDatasource.getCourseById(id)); }
    on ServerException catch (e) { return Left(ServerFailure(e.message)); }
    catch (e) { return Left(NetworkFailure(e.toString())); }
  }

  @override
  Future<Either<Failure, List<Unit>>> getCourseUnits(String courseId) async {
    try { return Right(await remoteDatasource.getCourseUnits(courseId)); }
    on ServerException catch (e) { return Left(ServerFailure(e.message)); }
    catch (e) { return Left(NetworkFailure(e.toString())); }
  }
}
