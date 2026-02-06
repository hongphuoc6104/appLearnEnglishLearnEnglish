import 'package:equatable/equatable.dart';
import 'lesson.dart';

class Unit extends Equatable {
  final String id;
  final String courseId;
  final String title;
  final String description;
  final int order;
  final List<Lesson> lessons;

  const Unit({
    required this.id,
    required this.courseId,
    required this.title,
    required this.description,
    required this.order,
    this.lessons = const [],
  });

  @override
  List<Object?> get props => [id, courseId, title, description, order, lessons];
}
