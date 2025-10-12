import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:WeGoAgain/services/leaderboard_service.dart';
import 'package:forui/forui.dart';

class LeaderboardPage extends StatelessWidget {
  const LeaderboardPage({super.key});

  @override
  Widget build(BuildContext context) {
    final leaderboardService = Provider.of<LeaderboardService>(context);

    return FScaffold(
      appBar: FAppBar(
        title: const FText('Leaderboard'),
      ),
      body: ListView.builder(
        itemCount: leaderboardService.users.length,
        itemBuilder: (context, index) {
          final user = leaderboardService.users[index];
          return ListTile(
            leading: FText('${index + 1}'),
            title: FText(user.name),
            trailing: FText(user.score.toString()),
          );
        },
      ),
    );
  }
}
