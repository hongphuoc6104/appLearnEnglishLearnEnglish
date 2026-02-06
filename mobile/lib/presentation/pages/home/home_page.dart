import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import '../../blocs/auth/auth_bloc.dart';
import '../../blocs/auth/auth_state.dart';
import '../../blocs/auth/auth_event.dart';
import '../../blocs/course/course_bloc.dart';
import '../../blocs/course/course_event.dart';
import '../../blocs/course/course_state.dart';
import '../../widgets/heart_display.dart';
import '../../widgets/xp_bar.dart';
import '../../widgets/streak_badge.dart';
import '../../../core/theme/app_colors.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});
  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  void initState() { super.initState(); context.read<CourseBloc>().add(LoadCourses()); }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('LearnEnglish'),
        actions: [
          BlocBuilder<AuthBloc, AuthState>(builder: (context, state) {
            if (state is Authenticated) return Row(children: [StreakBadge(streak: state.user.streak), const SizedBox(width: 8), HeartDisplay(hearts: state.user.hearts), const SizedBox(width: 8), XpBar(xp: state.user.xp, level: state.user.level), const SizedBox(width: 8)]);
            return const SizedBox.shrink();
          }),
        ],
      ),
      drawer: Drawer(
        child: ListView(padding: EdgeInsets.zero, children: [
          BlocBuilder<AuthBloc, AuthState>(builder: (context, state) {
            final user = state is Authenticated ? state.user : null;
            return DrawerHeader(
              decoration: const BoxDecoration(color: AppColors.primary),
              child: Column(crossAxisAlignment: CrossAxisAlignment.start, mainAxisAlignment: MainAxisAlignment.end, children: [
                const CircleAvatar(radius: 30, backgroundColor: Colors.white, child: Icon(Icons.person, size: 36, color: AppColors.primary)),
                const SizedBox(height: 12),
                Text(user?.displayName ?? 'Guest', style: const TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold)),
                Text(user?.email ?? '', style: const TextStyle(color: Colors.white70, fontSize: 14)),
              ]),
            );
          }),
          ListTile(leading: const Icon(Icons.person), title: const Text('Profile'), onTap: () => context.go('/profile')),
          ListTile(leading: const Icon(Icons.leaderboard), title: const Text('Leaderboard'), onTap: () => context.go('/leaderboard')),
          const Divider(),
          ListTile(leading: const Icon(Icons.logout, color: AppColors.error), title: const Text('Logout', style: TextStyle(color: AppColors.error)), onTap: () { context.read<AuthBloc>().add(const LogoutRequested()); context.go('/login'); }),
        ]),
      ),
      body: BlocBuilder<CourseBloc, CourseState>(builder: (context, state) {
        if (state is CourseLoading) return const Center(child: CircularProgressIndicator());
        if (state is CourseError) return Center(child: Text(state.message));
        if (state is CoursesLoaded) {
          return ListView.builder(
            padding: const EdgeInsets.all(16),
            itemCount: state.courses.length,
            itemBuilder: (context, index) {
              final course = state.courses[index];
              return Card(
                margin: const EdgeInsets.only(bottom: 16),
                child: InkWell(
                  borderRadius: BorderRadius.circular(16),
                  onTap: () => context.go('/learning-map/${course.id}'),
                  child: Padding(
                    padding: const EdgeInsets.all(20),
                    child: Row(children: [
                      Container(width: 60, height: 60, decoration: BoxDecoration(color: AppColors.primary.withValues(alpha: 0.1), borderRadius: BorderRadius.circular(16)), child: const Icon(Icons.book, color: AppColors.primary, size: 32)),
                      const SizedBox(width: 16),
                      Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                        Text(course.title, style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                        const SizedBox(height: 4),
                        Text(course.description, style: TextStyle(color: Colors.grey[600])),
                        const SizedBox(height: 8),
                        Container(padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4), decoration: BoxDecoration(color: AppColors.secondary.withValues(alpha: 0.1), borderRadius: BorderRadius.circular(8)), child: Text(course.difficulty.toUpperCase(), style: const TextStyle(fontSize: 12, color: AppColors.secondary, fontWeight: FontWeight.bold))),
                      ])),
                      const Icon(Icons.chevron_right, color: Colors.grey),
                    ]),
                  ),
                ),
              );
            },
          );
        }
        return const SizedBox.shrink();
      }),
    );
  }
}
