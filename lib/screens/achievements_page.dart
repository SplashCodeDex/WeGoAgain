import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:WeGoAgain/services/achievement_service.dart';
import 'package:forui/forui.dart';

class AchievementsPage extends StatelessWidget {
  const AchievementsPage({super.key});

  @override
  Widget build(BuildContext context) {
    final achievementService = Provider.of<AchievementService>(context);

    return FScaffold(
      appBar: FAppBar(
        title: const FText('Achievements'),
      ),
      body: ListView.builder(
        itemCount: achievementService.achievements.length,
        itemBuilder: (context, index) {
          final achievement = achievementService.achievements[index];
          return ListTile(
            leading: Icon(
              achievement.isUnlocked ? FIcons.lockOpen : FIcons.lock,
              color: achievement.isUnlocked ? FColors.green[500] : FColors.grey[500],
            ),
            title: FText(achievement.name),
            subtitle: FText(achievement.description),
          );
        },
      ),
    );
  }
}
