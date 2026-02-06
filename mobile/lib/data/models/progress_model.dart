import '../../domain/entities/progress.dart';

class ProgressModel extends Progress {
  const ProgressModel({super.completedLessons, super.completedUnits});

  factory ProgressModel.fromJson(Map<String, dynamic> json) {
    return ProgressModel(
      completedLessons: json['completedLessons'] != null ? List<String>.from(json['completedLessons'].map((l) => l.toString())) : [],
      completedUnits: json['completedUnits'] != null ? List<String>.from(json['completedUnits'].map((u) => u.toString())) : [],
    );
  }
}
