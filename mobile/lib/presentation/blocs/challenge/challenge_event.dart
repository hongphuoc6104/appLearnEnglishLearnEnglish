import 'package:equatable/equatable.dart';

abstract class ChallengeEvent extends Equatable {
  const ChallengeEvent();
  @override
  List<Object?> get props => [];
}

class LoadChallenges extends ChallengeEvent {
  final String lessonId;
  const LoadChallenges(this.lessonId);
  @override
  List<Object?> get props => [lessonId];
}

class SubmitAnswer extends ChallengeEvent {
  final String challengeId;
  final String answer;
  const SubmitAnswer({required this.challengeId, required this.answer});
  @override
  List<Object?> get props => [challengeId, answer];
}

class NextChallenge extends ChallengeEvent {
  const NextChallenge();
}
