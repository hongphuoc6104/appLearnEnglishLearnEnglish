import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'injection.dart';
import 'core/theme/app_theme.dart';
import 'core/router/app_router.dart';
import 'presentation/blocs/auth/auth_bloc.dart';
import 'presentation/blocs/course/course_bloc.dart';
import 'presentation/blocs/challenge/challenge_bloc.dart';
import 'presentation/blocs/speech/speech_bloc.dart';
import 'presentation/blocs/writing/writing_bloc.dart';
import 'presentation/blocs/gamification/gamification_bloc.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  initDependencies();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(create: (_) => sl<AuthBloc>()),
        BlocProvider(create: (_) => sl<CourseBloc>()),
        BlocProvider(create: (_) => sl<ChallengeBloc>()),
        BlocProvider(create: (_) => sl<SpeechBloc>()),
        BlocProvider(create: (_) => sl<WritingBloc>()),
        BlocProvider(create: (_) => sl<GamificationBloc>()),
      ],
      child: MaterialApp.router(
        title: 'LearnEnglish',
        theme: AppTheme.lightTheme,
        routerConfig: AppRouter.router,
        debugShowCheckedModeBanner: false,
      ),
    );
  }
}
