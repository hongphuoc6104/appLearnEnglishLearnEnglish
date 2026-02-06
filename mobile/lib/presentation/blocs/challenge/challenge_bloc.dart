import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../domain/usecases/submit_answer_usecase.dart';
import '../../../domain/repositories/lesson_repository.dart';
import 'challenge_event.dart';
import 'challenge_state.dart';

class ChallengeBloc extends Bloc<ChallengeEvent, ChallengeState> {
  final LessonRepository lessonRepository;
  final SubmitAnswerUseCase submitAnswerUseCase;
  int _correctAnswers = 0;

  ChallengeBloc({
    required this.lessonRepository,
    required this.submitAnswerUseCase,
  }) : super(const ChallengeInitial()) {
    on<LoadChallenges>(_onLoadChallenges);
    on<SubmitAnswer>(_onSubmitAnswer);
    on<NextChallenge>(_onNextChallenge);
  }

  Future<void> _onLoadChallenges(LoadChallenges event, Emitter<ChallengeState> emit) async {
    emit(const ChallengeLoading());
    _correctAnswers = 0;
    final result = await lessonRepository.getLessonChallenges(event.lessonId);
    result.fold(
      (failure) => emit(ChallengeError(failure.message)),
      (challenges) => emit(ChallengeLoaded(challenges: challenges)),
    );
  }

  Future<void> _onSubmitAnswer(SubmitAnswer event, Emitter<ChallengeState> emit) async {
    final currentState = state;
    if (currentState is! ChallengeLoaded) return;

    final result = await submitAnswerUseCase(event.challengeId, event.answer);
    result.fold(
      (failure) => emit(ChallengeError(failure.message)),
      (response) {
        final correct = response['correct'] as bool? ?? false;
        final xp = response['xp'] as int? ?? currentState.xp;
        final hearts = response['hearts'] as int? ?? currentState.hearts;
        if (correct) _correctAnswers++;
        emit(currentState.copyWith(
          xp: xp,
          hearts: hearts,
          lastAnswerCorrect: correct,
        ));
      },
    );
  }

  void _onNextChallenge(NextChallenge event, Emitter<ChallengeState> emit) {
    final currentState = state;
    if (currentState is! ChallengeLoaded) return;

    if (currentState.isLastChallenge) {
      emit(ChallengeCompleted(
        totalXp: currentState.xp,
        correctAnswers: _correctAnswers,
        totalChallenges: currentState.challenges.length,
      ));
    } else {
      emit(currentState.copyWith(
        currentIndex: currentState.currentIndex + 1,
        lastAnswerCorrect: null,
      ));
    }
  }
}
