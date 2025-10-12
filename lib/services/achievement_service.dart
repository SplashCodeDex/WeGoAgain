import 'package:flutter/material.dart';

class Achievement {
  final String name;
  final String description;
  bool isUnlocked;

  Achievement({
    required this.name,
    required this.description,
    this.isUnlocked = false,
  });
}

class AchievementService with ChangeNotifier {
  final List<Achievement> _achievements = [
    Achievement(name: 'First Quote', description: 'Read your first quote'),
    Achievement(name: 'Quote Sharer', description: 'Share a quote'),
    Achievement(name: 'Theme Changer', description: 'Change the theme'),
  ];

  List<Achievement> get achievements => _achievements;

  void unlockAchievement(String name) {
    final achievement = _achievements.firstWhere((a) => a.name == name);
    if (!achievement.isUnlocked) {
      achievement.isUnlocked = true;
      notifyListeners();
    }
  }
}
