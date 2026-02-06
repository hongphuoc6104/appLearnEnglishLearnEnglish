import '../../domain/entities/unit.dart';
import 'lesson_model.dart';

class UnitModel extends Unit {
  const UnitModel({required super.id, required super.courseId, required super.title, required super.description, required super.order, super.lessons});

  factory UnitModel.fromJson(Map<String, dynamic> json) {
    return UnitModel(
      id: json['id'] ?? json['_id'] ?? '',
      courseId: json['courseId'] ?? '',
      title: json['title'] ?? '',
      description: json['description'] ?? '',
      order: json['order'] ?? 0,
      lessons: json['lessons'] != null ? (json['lessons'] as List).map((l) => LessonModel.fromJson(l)).toList() : [],
    );
  }
}
