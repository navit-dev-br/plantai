import 'package:flutter/material.dart';
import 'package:plantai/scan/entities/plant.dart';

class DetailsPage extends StatelessWidget {
  final Plant plant;
  const DetailsPage({super.key, required this.plant});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(plant.name),
        actions: [
          IconButton(onPressed: () {}, icon: const Icon(Icons.share)),
        ],
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              ClipRRect(
                borderRadius: BorderRadius.circular(16),
                child: Image.memory(
                  plant.imageBytes!,
                  height: 200,
                  width: double.maxFinite,
                  fit: BoxFit.cover,
                ),
              ),
              const SizedBox(
                height: 24,
              ),
              Text(
                plant.cientificName,
                style:
                    const TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
              ),
              const SizedBox(
                height: 24,
              ),
              Text(
                plant.description,
                style:
                    const TextStyle(fontSize: 14, fontWeight: FontWeight.w400),
              ),
              const SizedBox(
                height: 24,
              ),
              const Text(
                "Recomendações",
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
              ),
              for (var item in plant.items)
                ListTile(
                  contentPadding: EdgeInsets.zero,
                  title: Text(item.title),
                  subtitle: Text(item.description),
                ),
            ],
          ),
        ),
      ),
    );
  }
}
