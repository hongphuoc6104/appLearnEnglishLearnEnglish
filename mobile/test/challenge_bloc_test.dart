import 'package:bloc_test/bloc_test.dart';
import 'package:dartz/dartz.dart' hide Unit;
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:mobile/core/errors/failures.dart';
import 'package:mobile/domain/entities/challenge.dart';
import 'package:mobile/domain/repositories/lesson_repository.dart';
import 'package:mobile/domain/usecases/submit_answer_usecase.dart';
import 'package:mobile/presentation/blocs/challenge/challenge_bloc.dart';
import 'package:mobile/presentation/blocs/challenge/challenge_event.dart';
import 'package:mobile/presentation/blocs/challenge/challenge_state.dart';

class MockLessonRepository extends Mock implements LessonRepository {}
class MockSubmitAnswerUseCase extends Mock implements SubmitAnswerUseCase {}

void main() {
  late ChallengeBloc challengeBloc;
  late MockLessonRepository mockLessonRepository;
  late MockSubmitAnswerUseCase mockSubmitAnswerUseCase;

  final testChallenges = [
    const Challenge(id: 'c1', lessonId: 'l1', type: 'SELECT', question: 'What is "hello"?', options: ['Xin chao', 'Tam biet', 'Cam on'], correctAnswer: 'Xin chao', order: 1),
    const Challenge(id: 'c2', lessonId: 'l1', type: 'SELECT', question: 'What is "goodbye"?', options: ['Xin chao', 'Tam biet', 'Cam on'], correctAnswer: 'Tam biet', order: 2),
  ];

  setUp(() {
    mockLessonRepository = MockLessonRepository();
    mockSubmitAnswerUseCase = MockSubmitAnswerUseCase();
    challengeBloc = ChallengeBloc(
      lessonRepository: mockLessonRepository,
      submitAnswerUseCase: mockSubmitAnswerUseCase,
    );
  });

  tearDown(() => challengeBloc.close());

  test('initial state is ChallengeInitial', () {
    expect(challengeBloc.state, const ChallengeInitial());
  });

  group('LoadChallenges', () {
    blocTest<ChallengeBloc, ChallengeState>(
      'emits [ChallengeLoading, ChallengeLoaded] on success',
      build: () {
        when(() => mockLessonRepository.getLessonChallenges('l1'))
            .thenAnswer((_) async => Right(testChallenges));
        return challengeBloc;
      },
      act: (bloc) => bloc.add(const LoadChallenges('l1')),
      expect: () => [
        const ChallengeLoading(),
        ChallengeLoaded(challenges: testChallenges),
      ],
    );

    blocTest<ChallengeBloc, ChallengeState>(
      'emits [ChallengeLoading, ChallengeError] on failure',
      build: () {
        when(() => mockLessonRepository.getLessonChallenges('l1'))
            .thenAnswer((_) async => const Left(ServerFailure('Failed to load')));
        return challengeBloc;
      },
      act: (bloc) => bloc.add(const LoadChallenges('l1')),
      expect: () => [
        const ChallengeLoading(),
        const ChallengeError('Failed to load'),
      ],
    );
  });

  group('SubmitAnswer', () {
    blocTest<ChallengeBloc, ChallengeState>(
      'updates state with correct answer result',
      build: () {
        when(() => mockSubmitAnswerUseCase('c1', 'Xin chao'))
            .thenAnswer((_) async => const Right({'isCorrect': true, 'xp': 10, 'hearts': 5}));
        return challengeBloc;
      },
      seed: () => ChallengeLoaded(challenges: testChallenges),
      act: (bloc) => bloc.add(const SubmitAnswer(challengeId: 'c1', answer: 'Xin chao')),
      expect: () => [
        ChallengeLoaded(challenges: testChallenges, xp: 10, hearts: 5, lastAnswerCorrect: true),
      ],
    );

    blocTest<ChallengeBloc, ChallengeState>(
      'updates state with wrong answer result',
      build: () {
        when(() => mockSubmitAnswerUseCase('c1', 'Tam biet'))
            .thenAnswer((_) async => const Right({'isCorrect': false, 'xp': 0, 'hearts': 4}));
        return challengeBloc;
      },
      seed: () => ChallengeLoaded(challenges: testChallenges),
      act: (bloc) => bloc.add(const SubmitAnswer(challengeId: 'c1', answer: 'Tam biet')),
      expect: () => [
        ChallengeLoaded(challenges: testChallenges, xp: 0, hearts: 4, lastAnswerCorrect: false),
      ],
    );
  });

  group('NextChallenge', () {
    blocTest<ChallengeBloc, ChallengeState>(
      'advances to next challenge',
      build: () => challengeBloc,
      seed: () => ChallengeLoaded(challenges: testChallenges, currentIndex: 0, lastAnswerCorrect: true),
      act: (bloc) => bloc.add(const NextChallenge()),
      expect: () => [
        ChallengeLoaded(challenges: testChallenges, currentIndex: 1),
      ],
    );

    blocTest<ChallengeBloc, ChallengeState>(
      'emits ChallengeCompleted when on last challenge',
      build: () => challengeBloc,
      seed: () => ChallengeLoaded(challenges: testChallenges, currentIndex: 1, xp: 20, lastAnswerCorrect: true),
      act: (bloc) => bloc.add(const NextChallenge()),
      expect: () => [
        const ChallengeCompleted(totalXp: 20, correctAnswers: 0, totalChallenges: 2),
      ],
    );
  });
}
