// ignore_for_file: no_leading_underscores_for_local_identifiers

import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../scan/entities/plant.dart';

class PlantPage extends StatefulWidget {
  const PlantPage({super.key});

  @override
  State<PlantPage> createState() => _PlantPageState();
}

class _PlantPageState extends State<PlantPage> {
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
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(
                height: 16,
              ),
              const Text(
                "Últimas plantas escaneadas",
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w500,
                ),
              ),
              const SizedBox(
                height: 16,
              ),
              SizedBox(
                height: MediaQuery.of(context).size.height * 0.3,
                child: ListView.builder(
                  scrollDirection: Axis.horizontal,
                  itemCount: scannedPlants.length,
                  itemBuilder: (_, index) => GestureDetector(
                    onTap: () {
                      Navigator.pushNamed(context, "/details",
                          arguments: scannedPlants[index]);
                    },
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Container(
                        height: 120,
                        width: 150,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(8),
                          image: DecorationImage(
                            image:
                                MemoryImage(scannedPlants[index].imageBytes!),
                            fit: BoxFit.cover,
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              ),
              const SizedBox(
                height: 24,
              ),
              const Text(
                "Suas plantas",
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w500,
                ),
              ),
              const SizedBox(
                height: 16,
              ),
              for (var item in myPlants)
                ListTile(
                  contentPadding: EdgeInsets.zero,
                  onTap: () {
                    Navigator.pushNamed(context, "/details", arguments: item);
                  },
                  title: Text(item.name),
                  leading: Container(
                    width: 40,
                    height: 40,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(8),
                      image: DecorationImage(
                        image: MemoryImage(item.imageBytes!),
                      ),
                    ),
                  ),
                  trailing: const Icon(Icons.chevron_right),
                ),
            ],
          ),
        ),
      ),
    );
  }
}
