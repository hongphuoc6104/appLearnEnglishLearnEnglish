import 'package:equatable/equatable.dart';

class WrongWord extends Equatable {
  final int index;
  final String expected;
  final String actual;

  const WrongWord({required this.index, required this.expected, required this.actual});

  @override
  List<Object?> get props => [index, expected, actual];
}

class SpeechResult extends Equatable {
  final double score;
  final String transcript;
  final String targetText;
  final List<WrongWord> wrongWords;
  final int wordCount;
  final int correctCount;

  const SpeechResult({
    required this.score,
    required this.transcript,
    required this.targetText,
    required this.wrongWords,
    required this.wordCount,
    required this.correctCount,
  });

  @override
  List<Object?> get props => [score, transcript, targetText, wrongWords, wordCount, correctCount];
}
