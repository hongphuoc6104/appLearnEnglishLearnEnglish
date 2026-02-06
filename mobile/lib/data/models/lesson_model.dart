import '../../domain/entities/lesson.dart';

class LessonModel extends Lesson {
  const LessonModel({required super.id, required super.unitId, required super.title, required super.order, required super.type, super.xpReward});

  factory LessonModel.fromJson(Map<String, dynamic> json) {
    return LessonModel(
      id: json['id'] ?? json['_id'] ?? '',
      unitId: json['unitId'] ?? '',
      title: json['title'] ?? '',
      order: json['order'] ?? 0,
      type: json['type'] ?? 'reading',
      xpReward: json['xpReward'] ?? 50,
    );
  }
}
