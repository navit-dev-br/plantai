// ignore_for_file: no_leading_underscores_for_local_identifiers

import 'package:flutter/material.dart';
import 'package:plantai/historic/historic_page.dart';
import 'package:plantai/scan/entities/plant.dart';
import 'package:plantai/scan/scan_page.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../plants/plants_page.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int currentIndex = 0;
  List<Plant> myPlants = [];
  List<Plant> scannedPlants = [];

  void getPlants() async {
    final instance = await SharedPreferences.getInstance();
    final _myPlants = instance.getStringList("my_plants") ?? [];
    final _scannedPlants = instance.getStringList("plants") ?? [];
    myPlants = _myPlants.map((e) => Plant.fromJson(e)).toList();
    scannedPlants = _scannedPlants.map((e) => Plant.fromJson(e)).toList();
    setState(() {});
  }

  @override
  void initState() {
    super.initState();
    getPlants();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Image.asset("assets/images/logo_plantai.png"),
        centerTitle: true,
      ),
      body: [
        const PlantPage(),
        const ScanPage(),
        const HistoricPage(),
      ][currentIndex],
      bottomNavigationBar: Container(
          height: 110,
          color: const Color(0xFFEEEFE3),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              for (var i = 0;
                  i < [Icons.home, Icons.qr_code, Icons.nature].length;
                  i++)
                GestureDetector(
                  onTap: () {
                    setState(() {
                      currentIndex = i;
                    });
                  },
                  child: MenuItem(
                    icon: [Icons.home, Icons.qr_code, Icons.nature][i],
                    isSelected: currentIndex == i,
                  ),
                ),
            ],
          )),
    );
  }
}

class MenuItem extends StatelessWidget {
  final bool isSelected;
  final IconData icon;
  const MenuItem({
    super.key,
    required this.icon,
    required this.isSelected,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
        width: 64,
        height: 32,
        decoration: BoxDecoration(
          color: isSelected ? const Color(0xFFDDE6C6) : null,
          borderRadius: BorderRadius.circular(99),
        ),
        child: Icon(icon, color: const Color(0xFF45483D)));
  }
}
