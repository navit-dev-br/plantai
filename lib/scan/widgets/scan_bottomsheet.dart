import 'package:flutter/material.dart';
import 'package:plantai/scan/entities/plant.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ScanBottomSheet extends StatelessWidget {
  final Plant plant;
  const ScanBottomSheet({
    super.key,
    required this.plant,
  });

  @override
  Widget build(BuildContext context) {
    return BottomSheet(
      onClosing: () {},
      backgroundColor: const Color(0xFFF4F4E9),
      builder: (_) => Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(16),
              child: Image.memory(
                plant.imageBytes!,
                height: 100,
                width: double.maxFinite,
                fit: BoxFit.cover,
              ),
            ),
            const SizedBox(
              height: 24,
            ),
            Text(
              plant.name,
              style: const TextStyle(fontSize: 24, fontWeight: FontWeight.w400),
            ),
            const SizedBox(
              height: 8,
            ),
            Text(
              plant.cientificName,
              style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w500),
            ),
            const SizedBox(
              height: 24,
            ),
            Text(
              plant.description,
              style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w400),
            ),
            const SizedBox(
              height: 40,
            ),
            GestureDetector(
              onTap: () {
                Navigator.pop(context);
                Navigator.pushNamed(
                  context,
                  '/details',
                  arguments: plant,
                );
              },
              child: Container(
                height: 40,
                decoration: BoxDecoration(
                  border: Border.all(
                    color: const Color(0xFF75786C),
                  ),
                  borderRadius: BorderRadius.circular(99),
                ),
                child: const Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      Icons.chevron_right,
                      color: Color(0xFF4F6628),
                    ),
                    SizedBox(
                      width: 8,
                    ),
                    Text(
                      "Ver dicas de cuidado",
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w400,
                        color: Color(0xFF4F6628),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(
              height: 16,
            ),
            GestureDetector(
              onTap: () async {
                Navigator.pop(context);
                final instance = await SharedPreferences.getInstance();
                final plants = instance.getStringList("my_plants") ?? [];
                plants.add(plant.toJson());
                await instance.setStringList("my_plants", plants);
              },
              child: Container(
                height: 40,
                decoration: BoxDecoration(
                  border: Border.all(
                    color: const Color(0xFF75786C),
                  ),
                  borderRadius: BorderRadius.circular(99),
                ),
                child: const Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      Icons.add,
                      color: Color(0xFF4F6628),
                    ),
                    SizedBox(
                      width: 8,
                    ),
                    Text(
                      "Adicionar planta na lista",
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w400,
                        color: Color(0xFF4F6628),
                      ),
                    ),
                  ],
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
