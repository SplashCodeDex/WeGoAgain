import 'package:flutter/material.dart';
import 'package:forui/forui.dart';

class FavoritesScreen extends StatelessWidget {
  final List<String> favoriteQuotes;

  const FavoritesScreen({super.key, required this.favoriteQuotes});

  @override
  Widget build(BuildContext context) {
    final theme = FTheme.of(context);

    return FScaffold(
      header: FHeader(
        title: const Text('Favorite Quotes'),
      ),
      child: favoriteQuotes.isEmpty
          ? Center(
              child: Text(
                'No favorite quotes yet!',
                style: theme.typography.base.copyWith(
                  color: theme.colors.foreground,
                ),
              ),
            )
          : ListView.builder(
              itemCount: favoriteQuotes.length,
              itemBuilder: (context, index) {
                return FCard(
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Text(
                      favoriteQuotes[index],
                      style: theme.typography.base.copyWith(
                        color: theme.colors.foreground,
                      ),
                    ),
                  ),
                );
              },
            ),
    );
  }
}
