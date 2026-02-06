import '../../domain/entities/writing_result.dart';

class CorrectionModel extends Correction {
  const CorrectionModel({required super.original, required super.corrected, required super.explanation});

  factory CorrectionModel.fromJson(Map<String, dynamic> json) {
    return CorrectionModel(original: json['original'] ?? '', corrected: json['corrected'] ?? '', explanation: json['explanation'] ?? '');
  }
}

class WritingResultModel extends WritingResult {
  const WritingResultModel({required super.originalText, required super.correctedText, required super.corrections, required super.overallScore, required super.feedback});

  factory WritingResultModel.fromJson(Map<String, dynamic> json) {
    return WritingResultModel(
      originalText: json['original_text'] ?? '',
      correctedText: json['corrected_text'] ?? '',
      corrections: json['corrections'] != null ? (json['corrections'] as List).map((c) => CorrectionModel.fromJson(c)).toList() : [],
      overallScore: (json['overall_score'] ?? 0).toDouble(),
      feedback: json['feedback'] ?? '',
    );
  }
}
