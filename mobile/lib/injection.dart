import 'package:get_it/get_it.dart';
import 'core/network/api_client.dart';
import 'data/datasources/auth_remote_datasource.dart';
import 'data/datasources/course_remote_datasource.dart';
import 'data/datasources/lesson_remote_datasource.dart';
import 'data/datasources/ai_remote_datasource.dart';
import 'data/repositories/auth_repository_impl.dart';
import 'data/repositories/course_repository_impl.dart';
import 'data/repositories/lesson_repository_impl.dart';
import 'data/repositories/ai_repository_impl.dart';
import 'domain/repositories/auth_repository.dart';
import 'domain/repositories/course_repository.dart';
import 'domain/repositories/lesson_repository.dart';
import 'domain/repositories/ai_repository.dart';
import 'domain/usecases/login_usecase.dart';
import 'domain/usecases/register_usecase.dart';
import 'domain/usecases/get_courses_usecase.dart';
import 'domain/usecases/submit_answer_usecase.dart';
import 'domain/usecases/analyze_speech_usecase.dart';
import 'domain/usecases/correct_writing_usecase.dart';
import 'domain/usecases/generate_quiz_usecase.dart';
import 'presentation/blocs/auth/auth_bloc.dart';
import 'presentation/blocs/course/course_bloc.dart';
import 'presentation/blocs/challenge/challenge_bloc.dart';
import 'presentation/blocs/speech/speech_bloc.dart';
import 'presentation/blocs/writing/writing_bloc.dart';
import 'presentation/blocs/gamification/gamification_bloc.dart';

final sl = GetIt.instance;

void initDependencies() {
  // Core
  sl.registerLazySingleton<ApiClient>(() => ApiClient());

  // Datasources
  sl.registerLazySingleton(() => AuthRemoteDatasource(sl()));
  sl.registerLazySingleton(() => CourseRemoteDatasource(sl()));
  sl.registerLazySingleton(() => LessonRemoteDatasource(sl()));
  sl.registerLazySingleton(() => AiRemoteDatasource(sl()));

  // Repositories
  sl.registerLazySingleton<AuthRepository>(() => AuthRepositoryImpl(sl()));
  sl.registerLazySingleton<CourseRepository>(() => CourseRepositoryImpl(sl()));
  sl.registerLazySingleton<LessonRepository>(() => LessonRepositoryImpl(sl()));
  sl.registerLazySingleton<AiRepository>(() => AiRepositoryImpl(sl()));

  // Use Cases
  sl.registerLazySingleton(() => LoginUseCase(sl()));
  sl.registerLazySingleton(() => RegisterUseCase(sl()));
  sl.registerLazySingleton(() => GetCoursesUseCase(sl()));
  sl.registerLazySingleton(() => SubmitAnswerUseCase(sl()));
  sl.registerLazySingleton(() => AnalyzeSpeechUseCase(sl()));
  sl.registerLazySingleton(() => CorrectWritingUseCase(sl()));
  sl.registerLazySingleton(() => GenerateQuizUseCase(sl()));

  // BLoCs
  sl.registerFactory(() => AuthBloc(
    loginUseCase: sl(),
    registerUseCase: sl(),
    authRepository: sl(),
  ));
  sl.registerFactory(() => CourseBloc(
    getCoursesUseCase: sl(),
    courseRepository: sl(),
  ));
  sl.registerFactory(() => ChallengeBloc(
    lessonRepository: sl(),
    submitAnswerUseCase: sl(),
  ));
  sl.registerFactory(() => SpeechBloc(analyzeSpeechUseCase: sl()));
  sl.registerFactory(() => WritingBloc(correctWritingUseCase: sl()));
  sl.registerFactory(() => GamificationBloc(lessonRepository: sl()));
}
