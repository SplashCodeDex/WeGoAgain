import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

class AffiliateLink extends StatelessWidget {
  final String url;
  final String text;

  const AffiliateLink({super.key, required this.url, required this.text});

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: () async {
        if (await canLaunchUrl(Uri.parse(url))) {
          await launchUrl(Uri.parse(url));
        } else {
          throw 'Could not launch $url';
        }
      },
      child: Text(text),
    );
  }
}
