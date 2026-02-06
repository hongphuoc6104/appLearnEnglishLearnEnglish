import 'package:go_router/go_router.dart';
import '../../presentation/pages/splash/splash_page.dart';
import '../../presentation/pages/auth/login_page.dart';
import '../../presentation/pages/auth/register_page.dart';
import '../../presentation/pages/home/home_page.dart';
import '../../presentation/pages/learning_map/learning_map_page.dart';
import '../../presentation/pages/lesson/lesson_page.dart';
import '../../presentation/pages/profile/profile_page.dart';
import '../../presentation/pages/leaderboard/leaderboard_page.dart';

class AppRouter {
  static final GoRouter router = GoRouter(
    initialLocation: '/splash',
    routes: [
      GoRoute(path: '/splash', builder: (context, state) => const SplashPage()),
      GoRoute(path: '/login', builder: (context, state) => const LoginPage()),
      GoRoute(path: '/register', builder: (context, state) => const RegisterPage()),
      GoRoute(path: '/home', builder: (context, state) => const HomePage()),
      GoRoute(
        path: '/learning-map/:courseId',
        builder: (context, state) => LearningMapPage(courseId: state.pathParameters['courseId']!),
      ),
      GoRoute(
        path: '/lesson/:lessonId',
        builder: (context, state) => LessonPage(lessonId: state.pathParameters['lessonId']!),
      ),
      GoRoute(path: '/profile', builder: (context, state) => const ProfilePage()),
      GoRoute(path: '/leaderboard', builder: (context, state) => const LeaderboardPage()),
    ],
  );
}
