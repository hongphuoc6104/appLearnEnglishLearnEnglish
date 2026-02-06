import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../blocs/auth/auth_bloc.dart';
import '../../blocs/auth/auth_state.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/network/api_client.dart';
import '../../../core/constants/api_constants.dart';
import '../../../injection.dart';

class LeaderboardPage extends StatefulWidget {
  const LeaderboardPage({super.key});

  @override
  State<LeaderboardPage> createState() => _LeaderboardPageState();
}

class _LeaderboardPageState extends State<LeaderboardPage> {
  List<Map<String, dynamic>> _leaderboard = [];
  bool _loading = true;
  String? _error;

  @override
  void initState() {
    super.initState();
    _loadLeaderboard();
  }

  Future<void> _loadLeaderboard() async {
    setState(() {
      _loading = true;
      _error = null;
    });
    try {
      final apiClient = sl<ApiClient>();
      final response = await apiClient.dio.get(ApiConstants.leaderboard);
      final data = response.data['data'] as List;
      setState(() {
        _leaderboard = data.map((e) => Map<String, dynamic>.from(e)).toList();
        _loading = false;
      });
    } catch (e) {
      setState(() {
        _error = 'Failed to load leaderboard';
        _loading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final authState = context.read<AuthBloc>().state;
    final currentUserId = authState is Authenticated ? authState.user.id : null;

    return Scaffold(
      appBar: AppBar(title: const Text('Leaderboard')),
      body: _loading
          ? const Center(child: CircularProgressIndicator())
          : _error != null
              ? Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Icon(Icons.error_outline, size: 48, color: Colors.grey),
                      const SizedBox(height: 16),
                      Text(_error!, style: const TextStyle(color: Colors.grey)),
                      const SizedBox(height: 16),
                      ElevatedButton(onPressed: _loadLeaderboard, child: const Text('Retry')),
                    ],
                  ),
                )
              : _leaderboard.isEmpty
                  ? const Center(child: Text('No users yet', style: TextStyle(color: Colors.grey)))
                  : RefreshIndicator(
                      onRefresh: _loadLeaderboard,
                      child: ListView.builder(
                        padding: const EdgeInsets.all(16),
                        itemCount: _leaderboard.length,
                        itemBuilder: (context, index) {
                          final entry = _leaderboard[index];
                          final rank = entry['rank'] as int? ?? index + 1;
                          final name = entry['displayName'] as String? ?? 'Unknown';
                          final xp = entry['xp'] as int? ?? 0;
                          final level = entry['level'] as int? ?? 1;
                          final streak = entry['streak'] as int? ?? 0;
                          final userId = entry['id'] as String?;
                          final isCurrentUser = userId == currentUserId;

                          return Container(
                            margin: const EdgeInsets.only(bottom: 8),
                            decoration: BoxDecoration(
                              color: isCurrentUser ? AppColors.primary.withValues(alpha: 0.08) : Colors.white,
                              borderRadius: BorderRadius.circular(12),
                              border: Border.all(
                                color: isCurrentUser ? AppColors.primary : Colors.grey.shade200,
                                width: isCurrentUser ? 2 : 1,
                              ),
                            ),
                            child: ListTile(
                              leading: _buildRankBadge(rank),
                              title: Text(
                                name,
                                style: TextStyle(
                                  fontWeight: isCurrentUser ? FontWeight.bold : FontWeight.w500,
                                  fontSize: 16,
                                ),
                              ),
                              subtitle: Row(
                                children: [
                                  const Icon(Icons.trending_up, size: 14, color: Colors.grey),
                                  const SizedBox(width: 4),
                                  Text('Lv.$level', style: const TextStyle(fontSize: 12)),
                                  const SizedBox(width: 12),
                                  const Icon(Icons.local_fire_department, size: 14, color: AppColors.streakOrange),
                                  const SizedBox(width: 4),
                                  Text('$streak days', style: const TextStyle(fontSize: 12)),
                                ],
                              ),
                              trailing: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                crossAxisAlignment: CrossAxisAlignment.end,
                                children: [
                                  Text('$xp', style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: AppColors.xpGold)),
                                  const Text('XP', style: TextStyle(fontSize: 12, color: Colors.grey)),
                                ],
                              ),
                            ),
                          );
                        },
                      ),
                    ),
    );
  }

  Widget _buildRankBadge(int rank) {
    Color bgColor;
    Color textColor = Colors.white;
    IconData? icon;

    switch (rank) {
      case 1:
        bgColor = const Color(0xFFFFD700);
        icon = Icons.emoji_events;
        break;
      case 2:
        bgColor = const Color(0xFFC0C0C0);
        icon = Icons.emoji_events;
        break;
      case 3:
        bgColor = const Color(0xFFCD7F32);
        icon = Icons.emoji_events;
        break;
      default:
        bgColor = Colors.grey.shade200;
        textColor = Colors.grey.shade700;
    }

    return CircleAvatar(
      radius: 20,
      backgroundColor: bgColor,
      child: icon != null
          ? Icon(icon, color: textColor, size: 20)
          : Text('$rank', style: TextStyle(color: textColor, fontWeight: FontWeight.bold)),
    );
  }
}
