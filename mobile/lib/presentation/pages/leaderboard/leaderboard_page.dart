import 'package:flutter/material.dart';
import '../../../core/theme/app_colors.dart';

class LeaderboardPage extends StatelessWidget {
  const LeaderboardPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Leaderboard')),
      body: const Center(child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
        Icon(Icons.leaderboard, size: 64, color: AppColors.xpGold),
        SizedBox(height: 16),
        Text('Leaderboard', style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
        SizedBox(height: 8),
        Text('Coming soon!', style: TextStyle(color: Colors.grey)),
      ])),
    );
  }
}
