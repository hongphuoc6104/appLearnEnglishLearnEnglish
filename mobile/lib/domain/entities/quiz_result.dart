import 'package:equatable/equatable.dart';

class QuizQuestion extends Equatable {
  final String question;
  final List<String> options;
  final String correctAnswer;
  final String explanation;

  const QuizQuestion({
    required this.question,
    required this.options,
    required this.correctAnswer,
    required this.explanation,
  });

  @override
  List<Object?> get props => [question, options, correctAnswer, explanation];
}

class QuizResult extends Equatable {
  final String topic;
  final String difficulty;
  final List<QuizQuestion> questions;

  const QuizResult({required this.topic, required this.difficulty, required this.questions});

  @override
  List<Object?> get props => [topic, difficulty, questions];
}
