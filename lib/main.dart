import 'package:flutter/material.dart';
import 'package:plantai/details/details_page.dart';
import 'package:plantai/scan/scan_page.dart';

import 'home/home_page.dart';
import 'scan/entities/plant.dart';
import 'splash/splash_page.dart';

void main() {
  runApp(const AppWidget());
}

class AppWidget extends StatelessWidget {
  const AppWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'PlantAI',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      initialRoute: "/splash",
      routes: {
        "/splash": (context) => const SplashPage(),
        "/home": (context) => const HomePage(),
        "/scan": (context) => const ScanPage(),
        "/details": (context) => DetailsPage(
              plant: ModalRoute.of(context)!.settings.arguments as Plant,
            ),
      },
    );
  }
}
