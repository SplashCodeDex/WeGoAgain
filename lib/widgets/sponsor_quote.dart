import 'package:flutter/material.dart';

class SponsorQuote extends StatelessWidget {
  const SponsorQuote({super.key});

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: () {
        showDialog(
          context: context,
          builder: (context) {
            return AlertDialog(
              title: const Text('Sponsor a Quote'),
              content: const Text(
                  'Want to feature your name or a short message next to a quote? Contact us at sponsor@wegoagain.app for more information.'),
              actions: [
                TextButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                  child: const Text('Close'),
                ),
              ],
            );
          },
        );
      },
      child: const Text('Sponsor a Quote'),
    );
  }
}
