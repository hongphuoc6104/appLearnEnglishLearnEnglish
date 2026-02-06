import 'package:flutter/material.dart';
import '../../core/theme/app_colors.dart';

class StreakBadge extends StatelessWidget {
  final int streak;
  const StreakBadge({super.key, required this.streak});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(Icons.local_fire_department, color: streak > 0 ? AppColors.streakOrange : Colors.grey, size: 20),
        const SizedBox(width: 2),
        Text(
          '$streak',
          style: TextStyle(
            color: streak > 0 ? AppColors.streakOrange : Colors.grey,
            fontWeight: FontWeight.bold,
            fontSize: 14,
          ),
        ),
      ],
    );
  }
}
