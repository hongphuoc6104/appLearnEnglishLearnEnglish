import 'package:flutter/material.dart';
import '../../core/theme/app_colors.dart';
import '../../domain/entities/writing_result.dart';

class DiffView extends StatelessWidget {
  final String original;
  final String corrected;
  final List<Correction> corrections;

  const DiffView({
    super.key,
    required this.original,
    required this.corrected,
    required this.corrections,
  });

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          const Text('Your text:', style: TextStyle(fontWeight: FontWeight.bold)),
          const SizedBox(height: 8),
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: AppColors.wrong.withValues(alpha: 0.05),
              borderRadius: BorderRadius.circular(8),
              border: Border.all(color: AppColors.wrong.withValues(alpha: 0.2)),
            ),
            child: Text(original, style: const TextStyle(fontSize: 16)),
          ),
          const SizedBox(height: 16),
          const Text('Corrected:', style: TextStyle(fontWeight: FontWeight.bold)),
          const SizedBox(height: 8),
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: AppColors.correct.withValues(alpha: 0.05),
              borderRadius: BorderRadius.circular(8),
              border: Border.all(color: AppColors.correct.withValues(alpha: 0.2)),
            ),
            child: Text(corrected, style: const TextStyle(fontSize: 16)),
          ),
          if (corrections.isNotEmpty) ...[
            const SizedBox(height: 16),
            const Text('Corrections:', style: TextStyle(fontWeight: FontWeight.bold)),
            const SizedBox(height: 8),
            ...corrections.map((c) => Card(
              margin: const EdgeInsets.only(bottom: 8),
              child: Padding(
                padding: const EdgeInsets.all(12),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Text(c.original, style: const TextStyle(decoration: TextDecoration.lineThrough, color: AppColors.wrong)),
                        const Icon(Icons.arrow_forward, size: 16, color: Colors.grey),
                        Text(c.corrected, style: const TextStyle(color: AppColors.correct, fontWeight: FontWeight.bold)),
                      ],
                    ),
                    const SizedBox(height: 4),
                    Text(c.explanation, style: const TextStyle(fontSize: 12, color: Colors.grey)),
                  ],
                ),
              ),
            )),
          ],
        ],
      ),
    );
  }
}
