import 'package:equatable/equatable.dart';

class User extends Equatable {
  final String id;
  final String email;
  final String displayName;
  final int xp;
  final int hearts;
  final int streak;
  final int level;

  const User({
    required this.id,
    required this.email,
    required this.displayName,
    this.xp = 0,
    this.hearts = 5,
    this.streak = 0,
    this.level = 1,
  });

  @override
  List<Object?> get props => [id, email, displayName, xp, hearts, streak, level];
}
