import 'package:flutter/material.dart';
import '../../core/theme/app_colors.dart';
import '../../domain/entities/lesson.dart';

enum LessonStatus { completed, available, locked }

class LessonNode extends StatelessWidget {
  final Lesson lesson;
  final LessonStatus status;
  final VoidCallback? onTap;

  const LessonNode({
    super.key,
    required this.lesson,
    required this.status,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    Color bgColor;
    Color iconColor;
    IconData icon;

    switch (status) {
      case LessonStatus.completed:
        bgColor = AppColors.completed;
        iconColor = Colors.white;
        icon = Icons.check;
      case LessonStatus.available:
        bgColor = AppColors.current;
        iconColor = Colors.white;
        icon = _getTypeIcon();
      case LessonStatus.locked:
        bgColor = AppColors.locked;
        iconColor = Colors.grey;
        icon = Icons.lock;
    }

    return GestureDetector(
      onTap: status != LessonStatus.locked ? onTap : null,
      child: Column(
        children: [
          Container(
            width: 70,
            height: 70,
            decoration: BoxDecoration(
              color: bgColor,
              shape: BoxShape.circle,
              boxShadow: status == LessonStatus.available
                  ? [BoxShadow(color: bgColor.withValues(alpha: 0.5), blurRadius: 12, spreadRadius: 2)]
                  : null,
            ),
            child: Icon(icon, color: iconColor, size: 32),
          ),
          const SizedBox(height: 8),
          Text(
            lesson.title,
            style: TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.w600,
              color: status == LessonStatus.locked ? Colors.grey : AppColors.textPrimary,
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  IconData _getTypeIcon() {
    switch (lesson.type) {
      case 'speaking':
        return Icons.mic;
      case 'writing':
        return Icons.edit;
      case 'listening':
        return Icons.headphones;
      case 'reading':
        return Icons.menu_book;
      default:
        return Icons.quiz;
    }
  }
}
