import 'package:equatable/equatable.dart';
import '../../../domain/entities/challenge.dart';

abstract class ChallengeState extends Equatable {
  const ChallengeState();
  @override
  List<Object?> get props => [];
}

class ChallengeInitial extends ChallengeState {
  const ChallengeInitial();
}

class ChallengeLoading extends ChallengeState {
  const ChallengeLoading();
}

class ChallengeLoaded extends ChallengeState {
  final List<Challenge> challenges;
  final int currentIndex;
  final int xp;
  final int hearts;
  final bool? lastAnswerCorrect;

  const ChallengeLoaded({
    required this.challenges,
    this.currentIndex = 0,
    this.xp = 0,
    this.hearts = 5,
    this.lastAnswerCorrect,
  });

  Challenge get currentChallenge => challenges[currentIndex];
  bool get isLastChallenge => currentIndex >= challenges.length - 1;
  double get progress => challenges.isEmpty ? 0 : (currentIndex + 1) / challenges.length;

  ChallengeLoaded copyWith({
    List<Challenge>? challenges,
    int? currentIndex,
    int? xp,
    int? hearts,
    bool? lastAnswerCorrect,
  }) {
    return ChallengeLoaded(
      challenges: challenges ?? this.challenges,
      currentIndex: currentIndex ?? this.currentIndex,
      xp: xp ?? this.xp,
      hearts: hearts ?? this.hearts,
      lastAnswerCorrect: lastAnswerCorrect,
    );
  }

  @override
  List<Object?> get props => [challenges, currentIndex, xp, hearts, lastAnswerCorrect];
}

class ChallengeCompleted extends ChallengeState {
  final int totalXp;
  final int correctAnswers;
  final int totalChallenges;
  const ChallengeCompleted({required this.totalXp, required this.correctAnswers, required this.totalChallenges});
  @override
  List<Object?> get props => [totalXp, correctAnswers, totalChallenges];
}

class ChallengeError extends ChallengeState {
  final String message;
  const ChallengeError(this.message);
  @override
  List<Object?> get props => [message];
}
