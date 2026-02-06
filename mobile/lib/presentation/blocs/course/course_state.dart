import 'package:equatable/equatable.dart';
import '../../../domain/entities/course.dart';
import '../../../domain/entities/unit.dart';

abstract class CourseState extends Equatable {
  const CourseState();
  @override
  List<Object?> get props => [];
}

class CourseInitial extends CourseState {
  const CourseInitial();
}

class CourseLoading extends CourseState {
  const CourseLoading();
}

class CoursesLoaded extends CourseState {
  final List<Course> courses;
  const CoursesLoaded(this.courses);
  @override
  List<Object?> get props => [courses];
}

class CourseUnitsLoaded extends CourseState {
  final String courseId;
  final List<Unit> units;
  const CourseUnitsLoaded({required this.courseId, required this.units});
  @override
  List<Object?> get props => [courseId, units];
}

class CourseError extends CourseState {
  final String message;
  const CourseError(this.message);
  @override
  List<Object?> get props => [message];
}
