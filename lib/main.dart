import 'package:flutter/material.dart';
import 'package:spotflod/page/about_page.dart';
import 'package:spotflod/page/home_page.dart';
import 'package:spotflod/page/prediction_page.dart';

Future<void> main() async {
  runApp(const SpotFlod());
}

class SpotFlod extends StatelessWidget {
  const SpotFlod({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        useMaterial3: true,
        colorSchemeSeed: const Color(0XFFdde6cd),
      ),
      home: const HomePage(),
      routes: {
        HomePage.id: (context) => const HomePage(),
        PredictionPage.id: (context) => const PredictionPage(),
        AboutPage.id: (context) => const AboutPage()
      },
    );
  }
}
