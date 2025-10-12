import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:WeGoAgain/services/leaderboard_service.dart';

class LeaderboardPage extends StatelessWidget {
  const LeaderboardPage({super.key});

  @override
  Widget build(BuildContext context) {
    final leaderboardService = Provider.of<LeaderboardService>(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Leaderboard'),
      ),
      body: ListView.builder(
        itemCount: leaderboardService.users.length,
        itemBuilder: (context, index) {
          final user = leaderboardService.users[index];
          return ListTile(
            leading: Text('${index + 1}'),
            title: Text(user.name),
            trailing: Text(user.score.toString()),
          );
        },
      ),
    );
  }
}
