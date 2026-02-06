import '../../domain/entities/user.dart';

class UserModel extends User {
  const UserModel({required super.id, required super.email, required super.displayName, super.xp, super.hearts, super.streak, super.level});

  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      id: json['id'] ?? json['_id'] ?? '',
      email: json['email'] ?? '',
      displayName: json['displayName'] ?? '',
      xp: json['xp'] ?? 0,
      hearts: json['hearts'] ?? 5,
      streak: json['streak'] ?? 0,
      level: json['level'] ?? 1,
    );
  }

  Map<String, dynamic> toJson() => {'id': id, 'email': email, 'displayName': displayName, 'xp': xp, 'hearts': hearts, 'streak': streak, 'level': level};
}
