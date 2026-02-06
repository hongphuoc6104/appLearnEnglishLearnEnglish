import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../blocs/speech/speech_bloc.dart';
import '../../blocs/speech/speech_event.dart';
import '../../blocs/speech/speech_state.dart';
import '../../blocs/challenge/challenge_bloc.dart';
import '../../blocs/challenge/challenge_event.dart';
import '../../widgets/score_display.dart';
import '../../../core/theme/app_colors.dart';
import '../../../domain/entities/challenge.dart';

class SpeakingExercise extends StatelessWidget {
  final Challenge challenge;
  const SpeakingExercise({super.key, required this.challenge});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<SpeechBloc, SpeechState>(builder: (context, state) {
      return Padding(
        padding: const EdgeInsets.all(24),
        child: Column(crossAxisAlignment: CrossAxisAlignment.stretch, children: [
          const Text('Say this sentence:', style: TextStyle(fontSize: 16, color: Colors.grey)),
          const SizedBox(height: 16),
          Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(16), border: Border.all(color: Colors.grey.shade200)),
            child: Text(challenge.targetText ?? challenge.question, style: const TextStyle(fontSize: 22, fontWeight: FontWeight.w600), textAlign: TextAlign.center),
          ),
          const Spacer(),
          if (state is SpeechAnalyzed) ...[
            ScoreDisplay(score: state.result.score),
            const SizedBox(height: 16),
            if (state.result.wrongWords.isNotEmpty) ...[
              const Text('Words to practice:', style: TextStyle(fontWeight: FontWeight.bold)),
              const SizedBox(height: 8),
              Wrap(spacing: 8, children: state.result.wrongWords.map((w) => Chip(label: Text(w.expected, style: const TextStyle(color: Colors.white)), backgroundColor: AppColors.error)).toList()),
            ],
            const SizedBox(height: 24),
            ElevatedButton(onPressed: () { context.read<SpeechBloc>().add(ResetSpeech()); context.read<ChallengeBloc>().add(SubmitAnswer(challengeId: challenge.id, answer: challenge.correctAnswer)); context.read<ChallengeBloc>().add(NextChallenge()); }, child: const Text('Continue')),
          ] else ...[
            Center(
              child: GestureDetector(
                onTapDown: (_) => context.read<SpeechBloc>().add(StartRecording()),
                onTapUp: (_) => context.read<SpeechBloc>().add(const StopRecording()),
                child: Container(width: 80, height: 80, decoration: BoxDecoration(shape: BoxShape.circle, color: state is SpeechRecording ? AppColors.error : AppColors.primary), child: Icon(state is SpeechRecording ? Icons.stop : Icons.mic, color: Colors.white, size: 36)),
              ),
            ),
            const SizedBox(height: 12),
            Text(state is SpeechRecording ? 'Release to stop' : state is SpeechAnalyzing ? 'Analyzing...' : 'Hold to speak', textAlign: TextAlign.center, style: const TextStyle(color: Colors.grey)),
          ],
          const SizedBox(height: 32),
        ]),
      );
    });
  }
}
