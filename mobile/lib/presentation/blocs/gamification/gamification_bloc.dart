import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../domain/repositories/lesson_repository.dart';
import 'gamification_event.dart';
import 'gamification_state.dart';

class GamificationBloc extends Bloc<GamificationEvent, GamificationState> {
  final LessonRepository lessonRepository;

  GamificationBloc({required this.lessonRepository}) : super(const GamificationInitial()) {
    on<LoadGamificationData>(_onLoadGamificationData);
    on<UpdateXp>(_onUpdateXp);
    on<UpdateHearts>(_onUpdateHearts);
    on<RefillHeartsRequested>(_onRefillHearts);
  }

  void _onLoadGamificationData(LoadGamificationData event, Emitter<GamificationState> emit) {
    emit(GamificationLoaded(
      xp: event.xp,
      hearts: event.hearts,
      streak: event.streak,
      level: event.level,
    ));
  }

  void _onUpdateXp(UpdateXp event, Emitter<GamificationState> emit) {
    final currentState = state;
    if (currentState is GamificationLoaded) {
      final newLevel = (event.xp ~/ 500) + 1;
      emit(currentState.copyWith(xp: event.xp, level: newLevel));
    }
  }

  void _onUpdateHearts(UpdateHearts event, Emitter<GamificationState> emit) {
    final currentState = state;
    if (currentState is GamificationLoaded) {
      emit(currentState.copyWith(hearts: event.hearts));
    }
  }

  Future<void> _onRefillHearts(RefillHeartsRequested event, Emitter<GamificationState> emit) async {
    final currentState = state;
    if (currentState is! GamificationLoaded) return;

    final result = await lessonRepository.refillHearts();
    result.fold(
      (failure) => emit(GamificationError(failure.message)),
      (response) {
        final hearts = response['hearts'] as int? ?? 5;
        final xp = response['xp'] as int? ?? currentState.xp;
        emit(currentState.copyWith(hearts: hearts, xp: xp));
      },
    );
  }
}
