import 'package:flutter/material.dart';
import '../../core/theme/app_colors.dart';

class HeartDisplay extends StatelessWidget {
  final int hearts;
  const HeartDisplay({super.key, required this.hearts});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        const Icon(Icons.favorite, color: AppColors.heartRed, size: 20),
        const SizedBox(width: 4),
        Text(
          '$hearts',
          style: const TextStyle(
            color: AppColors.heartRed,
            fontWeight: FontWeight.bold,
            fontSize: 16,
          ),
        ),
      ],
    );
  }
}
