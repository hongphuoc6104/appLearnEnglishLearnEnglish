import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:confetti/confetti.dart';
import '../../blocs/challenge/challenge_bloc.dart';
import '../../blocs/challenge/challenge_event.dart';
import '../../blocs/challenge/challenge_state.dart';
import '../../widgets/heart_display.dart';
import '../../../core/theme/app_colors.dart';
import '../../../domain/entities/challenge.dart';
import 'speaking_exercise.dart';
import 'writing_exercise.dart';
import 'quiz_exercise.dart';

class LessonPage extends StatefulWidget {
  final String lessonId;
  const LessonPage({super.key, required this.lessonId});
  @override
  State<LessonPage> createState() => _LessonPageState();
}

class _LessonPageState extends State<LessonPage> {
  late ConfettiController _confettiController;

  @override
  void initState() { super.initState(); _confettiController = ConfettiController(duration: const Duration(seconds: 3)); context.read<ChallengeBloc>().add(LoadChallenges(widget.lessonId)); }

  @override
  void dispose() { _confettiController.dispose(); super.dispose(); }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<ChallengeBloc, ChallengeState>(
      listener: (context, state) { if (state is ChallengeCompleted) _confettiController.play(); },
      builder: (context, state) {
        if (state is ChallengeLoading) return const Scaffold(body: Center(child: CircularProgressIndicator()));
        if (state is ChallengeError) return Scaffold(appBar: AppBar(), body: Center(child: Text(state.message)));
        if (state is ChallengeCompleted) {
          return Scaffold(body: Stack(children: [
            Center(child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
              const Icon(Icons.celebration, size: 80, color: AppColors.xpGold),
              const SizedBox(height: 24),
              const Text('Lesson Complete!', style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold)),
              const SizedBox(height: 16),
              Text('+${state.totalXp} XP', style: const TextStyle(fontSize: 24, color: AppColors.xpGold, fontWeight: FontWeight.bold)),
              const SizedBox(height: 32),
              ElevatedButton(onPressed: () => context.go('/home'), child: const Text('Continue')),
            ])),
            Align(alignment: Alignment.topCenter, child: ConfettiWidget(confettiController: _confettiController, blastDirectionality: BlastDirectionality.explosive, shouldLoop: false, colors: const [AppColors.primary, AppColors.secondary, AppColors.xpGold, AppColors.accent])),
          ]));
        }
        if (state is ChallengeLoaded) {
          final challenge = state.currentChallenge;
          return Scaffold(
            appBar: AppBar(
              leading: IconButton(icon: const Icon(Icons.close), onPressed: () => context.go('/home')),
              title: LinearProgressIndicator(value: state.progress, backgroundColor: Colors.grey[200], color: AppColors.primary, minHeight: 8, borderRadius: BorderRadius.circular(4)),
              actions: [HeartDisplay(hearts: state.hearts), const SizedBox(width: 16)],
            ),
            body: _buildExercise(challenge, state),
          );
        }
        return const SizedBox.shrink();
      },
    );
  }

  Widget _buildExercise(Challenge challenge, ChallengeLoaded state) {
    switch (challenge.type) {
      case 'SPEAK': return SpeakingExercise(challenge: challenge);
      case 'WRITE': return WritingExercise(challenge: challenge);
      default: return QuizExercise(challenge: challenge, state: state);
    }
  }
}
