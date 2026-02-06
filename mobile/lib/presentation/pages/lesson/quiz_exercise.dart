import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../blocs/challenge/challenge_bloc.dart';
import '../../blocs/challenge/challenge_event.dart';
import '../../blocs/challenge/challenge_state.dart';
import '../../../core/theme/app_colors.dart';
import '../../../domain/entities/challenge.dart';

class QuizExercise extends StatefulWidget {
  final Challenge challenge;
  final ChallengeLoaded state;
  const QuizExercise({super.key, required this.challenge, required this.state});
  @override
  State<QuizExercise> createState() => _QuizExerciseState();
}

class _QuizExerciseState extends State<QuizExercise> {
  String? _selectedAnswer;
  bool _submitted = false;

  @override
  void didUpdateWidget(covariant QuizExercise oldWidget) { super.didUpdateWidget(oldWidget); if (oldWidget.challenge.id != widget.challenge.id) setState(() { _selectedAnswer = null; _submitted = false; }); }

  @override
  Widget build(BuildContext context) {
    final lastCorrect = widget.state.lastAnswerCorrect;
    return Padding(
      padding: const EdgeInsets.all(24),
      child: Column(crossAxisAlignment: CrossAxisAlignment.stretch, children: [
        Text(widget.challenge.question, style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
        const SizedBox(height: 24),
        ...widget.challenge.options.map((option) {
          final isSelected = _selectedAnswer == option;
          final isCorrect = option == widget.challenge.correctAnswer;
          Color? bgColor;
          Color? borderColor;
          if (_submitted) {
            if (isCorrect) { bgColor = AppColors.correct.withValues(alpha: 0.1); borderColor = AppColors.correct; }
            else if (isSelected) { bgColor = AppColors.wrong.withValues(alpha: 0.1); borderColor = AppColors.wrong; }
          } else if (isSelected) { bgColor = AppColors.secondary.withValues(alpha: 0.1); borderColor = AppColors.secondary; }
          return Padding(
            padding: const EdgeInsets.only(bottom: 12),
            child: InkWell(
              onTap: _submitted ? null : () => setState(() => _selectedAnswer = option),
              borderRadius: BorderRadius.circular(12),
              child: Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(color: bgColor ?? Colors.white, border: Border.all(color: borderColor ?? Colors.grey.shade300, width: 2), borderRadius: BorderRadius.circular(12)),
                child: Row(children: [
                  Expanded(child: Text(option, style: const TextStyle(fontSize: 16))),
                  if (_submitted && isCorrect) const Icon(Icons.check_circle, color: AppColors.correct),
                  if (_submitted && isSelected && !isCorrect) const Icon(Icons.cancel, color: AppColors.wrong),
                ]),
              ),
            ),
          );
        }),
        const Spacer(),
        if (_submitted) Container(
          padding: const EdgeInsets.all(16), margin: const EdgeInsets.only(bottom: 16),
          decoration: BoxDecoration(color: (lastCorrect ?? false) ? AppColors.correct.withValues(alpha: 0.1) : AppColors.wrong.withValues(alpha: 0.1), borderRadius: BorderRadius.circular(12)),
          child: Text((lastCorrect ?? false) ? 'Correct!' : 'Wrong! The answer is: ${widget.challenge.correctAnswer}', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: (lastCorrect ?? false) ? AppColors.correct : AppColors.wrong)),
        ),
        ElevatedButton(
          onPressed: _selectedAnswer == null ? null : () {
            if (!_submitted) { setState(() => _submitted = true); context.read<ChallengeBloc>().add(SubmitAnswer(challengeId: widget.challenge.id, answer: _selectedAnswer!)); }
            else { context.read<ChallengeBloc>().add(NextChallenge()); }
          },
          child: Text(_submitted ? 'Continue' : 'Check'),
        ),
      ]),
    );
  }
}
