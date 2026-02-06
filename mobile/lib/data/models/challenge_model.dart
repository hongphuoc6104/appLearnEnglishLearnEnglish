import '../../domain/entities/challenge.dart';

class ChallengeModel extends Challenge {
  const ChallengeModel({required super.id, required super.lessonId, required super.type, required super.question, super.options, required super.correctAnswer, super.audioUrl, super.targetText, required super.order});

  factory ChallengeModel.fromJson(Map<String, dynamic> json) {
    return ChallengeModel(
      id: json['id'] ?? json['_id'] ?? '',
      lessonId: json['lessonId'] ?? '',
      type: json['type'] ?? '',
      question: json['question'] ?? '',
      options: json['options'] != null ? List<String>.from(json['options']) : [],
      correctAnswer: json['correctAnswer'] ?? '',
      audioUrl: json['audioUrl'],
      targetText: json['targetText'],
      order: json['order'] ?? 0,
    );
  }
}
