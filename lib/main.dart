import 'package:flutter/material.dart';
import 'package:WeGoAgain/screens/home_page.dart';

void main() {
  runApp(const WeGoAgain());
}

class WeGoAgain extends StatelessWidget {
  const WeGoAgain({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Portfolio App',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.blue,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: const MyHomePage(),
    );
  }
}
