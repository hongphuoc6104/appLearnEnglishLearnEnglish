import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../blocs/auth/auth_bloc.dart';
import '../../blocs/auth/auth_state.dart';
import '../../../core/theme/app_colors.dart';

class ProfilePage extends StatelessWidget {
  const ProfilePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Profile')),
      body: BlocBuilder<AuthBloc, AuthState>(builder: (context, state) {
        if (state is! Authenticated) return const Center(child: Text('Not logged in'));
        final user = state.user;
        return SingleChildScrollView(
          padding: const EdgeInsets.all(24),
          child: Column(children: [
            const CircleAvatar(radius: 50, backgroundColor: AppColors.primary, child: Icon(Icons.person, size: 50, color: Colors.white)),
            const SizedBox(height: 16),
            Text(user.displayName, style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
            Text(user.email, style: const TextStyle(color: Colors.grey)),
            const SizedBox(height: 32),
            _buildStatCard('Level', '${user.level}', Icons.trending_up, AppColors.primary),
            _buildStatCard('Total XP', '${user.xp}', Icons.star, AppColors.xpGold),
            _buildStatCard('Streak', '${user.streak} days', Icons.local_fire_department, AppColors.streakOrange),
            _buildStatCard('Hearts', '${user.hearts}/5', Icons.favorite, AppColors.heartRed),
          ]),
        );
      }),
    );
  }

  Widget _buildStatCard(String label, String value, IconData icon, Color color) {
    return Card(margin: const EdgeInsets.only(bottom: 12), child: ListTile(
      leading: CircleAvatar(backgroundColor: color.withValues(alpha: 0.1), child: Icon(icon, color: color)),
      title: Text(label, style: const TextStyle(fontWeight: FontWeight.bold)),
      trailing: Text(value, style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: color)),
    ));
  }
}
