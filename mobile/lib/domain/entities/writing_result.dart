import 'package:equatable/equatable.dart';

class Correction extends Equatable {
  final String original;
  final String corrected;
  final String explanation;

  const Correction({required this.original, required this.corrected, required this.explanation});

  @override
  List<Object?> get props => [original, corrected, explanation];
}

class WritingResult extends Equatable {
  final String originalText;
  final String correctedText;
  final List<Correction> corrections;
  final double overallScore;
  final String feedback;

  const WritingResult({
    required this.originalText,
    required this.correctedText,
    required this.corrections,
    required this.overallScore,
    required this.feedback,
  });

  @override
  List<Object?> get props => [originalText, correctedText, corrections, overallScore, feedback];
}
