import 'package:equatable/equatable.dart';

abstract class CourseEvent extends Equatable {
  const CourseEvent();
  @override
  List<Object?> get props => [];
}

class LoadCourses extends CourseEvent {
  const LoadCourses();
}

class LoadCourseUnits extends CourseEvent {
  final String courseId;
  const LoadCourseUnits(this.courseId);
  @override
  List<Object?> get props => [courseId];
}
