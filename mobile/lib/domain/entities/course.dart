import 'package:equatable/equatable.dart';

class Course extends Equatable {
  final String id;
  final String title;
  final String description;
  final String language;
  final String difficulty;
  final String? imageUrl;

  const Course({
    required this.id,
    required this.title,
    required this.description,
    required this.language,
    required this.difficulty,
    this.imageUrl,
  });

  @override
  List<Object?> get props => [id, title, description, language, difficulty, imageUrl];
}
