import 'package:equatable/equatable.dart';

class Lesson extends Equatable {
  final String id;
  final String unitId;
  final String title;
  final int order;
  final String type;
  final int xpReward;

  const Lesson({
    required this.id,
    required this.unitId,
    required this.title,
    required this.order,
    required this.type,
    this.xpReward = 50,
  });

  @override
  List<Object?> get props => [id, unitId, title, order, type, xpReward];
}
