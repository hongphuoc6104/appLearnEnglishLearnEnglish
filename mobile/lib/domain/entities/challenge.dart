import 'package:equatable/equatable.dart';

class Challenge extends Equatable {
  final String id;
  final String lessonId;
  final String type;
  final String question;
  final List<String> options;
  final String correctAnswer;
  final String? audioUrl;
  final String? targetText;
  final int order;

  const Challenge({
    required this.id,
    required this.lessonId,
    required this.type,
    required this.question,
    this.options = const [],
    required this.correctAnswer,
    this.audioUrl,
    this.targetText,
    required this.order,
  });

  @override
  List<Object?> get props => [id, lessonId, type, question, options, correctAnswer, order];
}
