import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:WeGoAgain/services/achievement_service.dart';

class AchievementsPage extends StatelessWidget {
  const AchievementsPage({super.key});

  @override
  Widget build(BuildContext context) {
    final achievementService = Provider.of<AchievementService>(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Achievements'),
      ),
      body: ListView.builder(
        itemCount: achievementService.achievements.length,
        itemBuilder: (context, index) {
          final achievement = achievementService.achievements[index];
          return ListTile(
            leading: Icon(
              achievement.isUnlocked ? Icons.lock_open : Icons.lock,
              color: achievement.isUnlocked ? Colors.green : Colors.grey,
            ),
            title: Text(achievement.name),
            subtitle: Text(achievement.description),
          );
        },
      ),
    );
  }
}
