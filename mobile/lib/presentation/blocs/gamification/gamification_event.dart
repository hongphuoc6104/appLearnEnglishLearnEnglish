import 'package:equatable/equatable.dart';

abstract class GamificationEvent extends Equatable {
  const GamificationEvent();
  @override
  List<Object?> get props => [];
}

class LoadGamificationData extends GamificationEvent {
  final int xp;
  final int hearts;
  final int streak;
  final int level;
  const LoadGamificationData({required this.xp, required this.hearts, required this.streak, required this.level});
  @override
  List<Object?> get props => [xp, hearts, streak, level];
}

class UpdateXp extends GamificationEvent {
  final int xp;
  const UpdateXp(this.xp);
  @override
  List<Object?> get props => [xp];
}

class UpdateHearts extends GamificationEvent {
  final int hearts;
  const UpdateHearts(this.hearts);
  @override
  List<Object?> get props => [hearts];
}

class RefillHeartsRequested extends GamificationEvent {
  const RefillHeartsRequested();
}
