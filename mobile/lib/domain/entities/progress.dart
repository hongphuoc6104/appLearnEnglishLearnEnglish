import 'package:equatable/equatable.dart';

class Progress extends Equatable {
  final List<String> completedLessons;
  final List<String> completedUnits;

  const Progress({
    this.completedLessons = const [],
    this.completedUnits = const [],
  });

  @override
  List<Object?> get props => [completedLessons, completedUnits];
}
