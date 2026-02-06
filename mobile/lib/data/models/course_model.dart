import '../../domain/entities/course.dart';

class CourseModel extends Course {
  const CourseModel({required super.id, required super.title, required super.description, required super.language, required super.difficulty, super.imageUrl});

  factory CourseModel.fromJson(Map<String, dynamic> json) {
    return CourseModel(
      id: json['id'] ?? json['_id'] ?? '',
      title: json['title'] ?? '',
      description: json['description'] ?? '',
      language: json['language'] ?? '',
      difficulty: json['difficulty'] ?? '',
      imageUrl: json['imageUrl'],
    );
  }
}
