import 'package:flutter/material.dart';
import 'package:percent_indicator/circular_percent_indicator.dart';
import '../../core/theme/app_colors.dart';

class ScoreDisplay extends StatelessWidget {
  final double score;
  const ScoreDisplay({super.key, required this.score});

  @override
  Widget build(BuildContext context) {
    final color = score >= 80
        ? AppColors.correct
        : score >= 50
            ? AppColors.accent
            : AppColors.wrong;

    return Center(
      child: CircularPercentIndicator(
        radius: 60.0,
        lineWidth: 10.0,
        percent: (score / 100).clamp(0.0, 1.0),
        center: Text(
          '${score.toStringAsFixed(0)}%',
          style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: color),
        ),
        progressColor: color,
        backgroundColor: Colors.grey.shade200,
        circularStrokeCap: CircularStrokeCap.round,
        animation: true,
        animationDuration: 1000,
      ),
    );
  }
}
