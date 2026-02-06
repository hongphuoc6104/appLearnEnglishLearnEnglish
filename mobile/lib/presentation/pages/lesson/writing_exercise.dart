import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../blocs/writing/writing_bloc.dart';
import '../../blocs/writing/writing_event.dart';
import '../../blocs/writing/writing_state.dart';
import '../../blocs/challenge/challenge_bloc.dart';
import '../../blocs/challenge/challenge_event.dart';
import '../../widgets/diff_view.dart';
import '../../../core/theme/app_colors.dart';
import '../../../domain/entities/challenge.dart';

class WritingExercise extends StatefulWidget {
  final Challenge challenge;
  const WritingExercise({super.key, required this.challenge});
  @override
  State<WritingExercise> createState() => _WritingExerciseState();
}

class _WritingExerciseState extends State<WritingExercise> {
  final _textController = TextEditingController();
  @override
  void dispose() { _textController.dispose(); super.dispose(); }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<WritingBloc, WritingState>(builder: (context, state) {
      return Padding(
        padding: const EdgeInsets.all(24),
        child: Column(crossAxisAlignment: CrossAxisAlignment.stretch, children: [
          Text(widget.challenge.question, style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
          const SizedBox(height: 16),
          if (state is WritingCorrected) ...[
            Expanded(child: DiffView(original: state.result.originalText, corrected: state.result.correctedText, corrections: state.result.corrections)),
            const SizedBox(height: 8),
            Text('Score: ${state.result.overallScore.toStringAsFixed(0)}%', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: state.result.overallScore >= 70 ? AppColors.correct : AppColors.wrong)),
            const SizedBox(height: 8),
            Text(state.result.feedback, style: const TextStyle(color: Colors.grey)),
            const SizedBox(height: 16),
            ElevatedButton(onPressed: () { context.read<WritingBloc>().add(ResetWriting()); context.read<ChallengeBloc>().add(SubmitAnswer(challengeId: widget.challenge.id, answer: widget.challenge.correctAnswer)); context.read<ChallengeBloc>().add(NextChallenge()); }, child: const Text('Continue')),
          ] else ...[
            Expanded(child: TextField(controller: _textController, maxLines: null, expands: true, textAlignVertical: TextAlignVertical.top, decoration: InputDecoration(hintText: 'Write your answer here...', border: OutlineInputBorder(borderRadius: BorderRadius.circular(12))))),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: state is WritingLoading ? null : () { if (_textController.text.trim().length >= 3) context.read<WritingBloc>().add(SubmitWriting(text: _textController.text)); },
              child: state is WritingLoading ? const SizedBox(height: 20, width: 20, child: CircularProgressIndicator(strokeWidth: 2)) : const Text('Check Writing'),
            ),
          ],
        ]),
      );
    });
  }
}
