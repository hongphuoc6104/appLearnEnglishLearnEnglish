import 'package:flutter/material.dart';
import '../../core/theme/app_colors.dart';
import '../../core/constants/app_constants.dart';

class XpBar extends StatelessWidget {
  final int xp;
  final int level;
  const XpBar({super.key, required this.xp, required this.level});

  @override
  Widget build(BuildContext context) {
    final xpInLevel = xp % AppConstants.xpPerLevel;
    final progress = xpInLevel / AppConstants.xpPerLevel;

    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
          decoration: BoxDecoration(
            color: AppColors.xpGold,
            borderRadius: BorderRadius.circular(10),
          ),
          child: Text(
            'Lv$level',
            style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 12),
          ),
        ),
        const SizedBox(width: 4),
        SizedBox(
          width: 40,
          child: LinearProgressIndicator(
            value: progress,
            backgroundColor: Colors.grey[200],
            color: AppColors.xpGold,
            minHeight: 6,
            borderRadius: BorderRadius.circular(3),
          ),
        ),
      ],
    );
  }
}
