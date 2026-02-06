import 'package:equatable/equatable.dart';

abstract class GamificationState extends Equatable {
  const GamificationState();
  @override
  List<Object?> get props => [];
}

class GamificationInitial extends GamificationState {
  const GamificationInitial();
}

class GamificationLoaded extends GamificationState {
  final int xp;
  final int hearts;
  final int streak;
  final int level;

  const GamificationLoaded({
    this.xp = 0,
    this.hearts = 5,
    this.streak = 0,
    this.level = 1,
  });

  GamificationLoaded copyWith({int? xp, int? hearts, int? streak, int? level}) {
    return GamificationLoaded(
      xp: xp ?? this.xp,
      hearts: hearts ?? this.hearts,
      streak: streak ?? this.streak,
      level: level ?? this.level,
    );
  }

  @override
  List<Object?> get props => [xp, hearts, streak, level];
}

class GamificationError extends GamificationState {
  final String message;
  const GamificationError(this.message);
  @override
  List<Object?> get props => [message];
}
