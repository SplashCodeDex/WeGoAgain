import 'package:flutter/material.dart';

class User {
  final String name;
  final int score;

  User({required this.name, required this.score});
}

class LeaderboardService with ChangeNotifier {
  final List<User> _users = [
    User(name: 'Player 1', score: 100),
    User(name: 'Player 2', score: 90),
    User(name: 'Player 3', score: 80),
    User(name: 'Player 4', score: 70),
    User(name: 'Player 5', score: 60),
  ];

  List<User> get users => _users;

  void incrementScore(String name) {
    final user = _users.firstWhere((u) => u.name == name);
    final index = _users.indexOf(user);
    _users[index] = User(name: user.name, score: user.score + 10);
    _users.sort((a, b) => b.score.compareTo(a.score));
    notifyListeners();
  }
}
