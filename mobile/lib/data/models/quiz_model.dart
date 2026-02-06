import '../../domain/entities/quiz_result.dart';

class QuizQuestionModel extends QuizQuestion {
  const QuizQuestionModel({required super.question, required super.options, required super.correctAnswer, required super.explanation});

  factory QuizQuestionModel.fromJson(Map<String, dynamic> json) {
    return QuizQuestionModel(
      question: json['question'] ?? '',
      options: json['options'] != null ? List<String>.from(json['options']) : [],
      correctAnswer: json['correct_answer'] ?? json['correctAnswer'] ?? '',
      explanation: json['explanation'] ?? '',
    );
  }
}

class QuizResultModel extends QuizResult {
  const QuizResultModel({required super.topic, required super.difficulty, required super.questions});

  factory QuizResultModel.fromJson(Map<String, dynamic> json) {
    return QuizResultModel(
      topic: json['topic'] ?? '',
      difficulty: json['difficulty'] ?? '',
      questions: json['questions'] != null ? (json['questions'] as List).map((q) => QuizQuestionModel.fromJson(q)).toList() : [],
    );
  }
}
