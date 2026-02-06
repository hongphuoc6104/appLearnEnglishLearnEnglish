import '../../domain/entities/speech_result.dart';

class WrongWordModel extends WrongWord {
  const WrongWordModel({required super.index, required super.expected, required super.actual});

  factory WrongWordModel.fromJson(Map<String, dynamic> json) {
    return WrongWordModel(index: json['index'] ?? 0, expected: json['expected'] ?? '', actual: json['actual'] ?? '');
  }
}

class SpeechResultModel extends SpeechResult {
  const SpeechResultModel({required super.score, required super.transcript, required super.targetText, required super.wrongWords, required super.wordCount, required super.correctCount});

  factory SpeechResultModel.fromJson(Map<String, dynamic> json) {
    return SpeechResultModel(
      score: (json['score'] ?? 0).toDouble(),
      transcript: json['transcript'] ?? '',
      targetText: json['target_text'] ?? '',
      wrongWords: json['wrong_words'] != null ? (json['wrong_words'] as List).map((w) => WrongWordModel.fromJson(w)).toList() : [],
      wordCount: json['word_count'] ?? 0,
      correctCount: json['correct_count'] ?? 0,
    );
  }
}
