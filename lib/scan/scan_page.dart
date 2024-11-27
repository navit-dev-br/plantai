import 'dart:typed_data';

import 'package:camera/camera.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:google_generative_ai/google_generative_ai.dart';
import 'package:image_picker/image_picker.dart';
import 'package:plantai/env.dart';
import 'package:plantai/scan/scan_controller.dart';
import 'package:plantai/scan/widgets/action_button.dart';
import 'package:plantai/scan/widgets/take_photo_button.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'entities/plant.dart';
import 'widgets/scan_bottomsheet.dart';

class ScanPage extends StatefulWidget {
  const ScanPage({super.key});

  @override
  State<ScanPage> createState() => _ScanPageState();
}

class _ScanPageState extends State<ScanPage> {
  final controller = ScanController();
  final globalKey = GlobalKey<ScaffoldState>();

  @override
  void dispose() {
    controller.close();
    super.dispose();
  }

  void openBottomSheet({required Plant plant}) {
    globalKey.currentState!.showBottomSheet(
      (_) => ScanBottomSheet(
        plant: plant,
      ),
    );
  }

  void openLoading() {
    globalKey.currentState!.showBottomSheet(
      (_) => BottomSheet(
        onClosing: () {},
        backgroundColor: const Color(0xFFF4F4E9),
        builder: (_) => SizedBox(
          width: MediaQuery.of(context).size.width,
          child: const Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              SizedBox(
                height: 40,
              ),
              CircularProgressIndicator(),
              SizedBox(
                height: 40,
              )
            ],
          ),
        ),
      ),
    );
  }

  void closeLoading() {
    Navigator.pop(context);
  }

  Future<void> searchPlant({required Uint8List imageBytes}) async {
    openLoading();

    final generative =
        GenerativeModel(model: "gemini-1.5-pro", apiKey: ENV.geminiAPIKey);
    final response = await generative.generateContent([
      Content.multi([
        TextPart(
          '''Você é um especilista em plantas do app PlantAI. O seu objetivo é ajudar as pessoas a identificar suas plantas atraves de uma foto. Com isso, você vai processar para identificar o nome da planta, o nome cientifico e uma breve descrição dessa planta, podendo ser sua origem ou sua histórica. Com isso, você vai devolver dicas que a pessoa poderia realizar no periodo de uma semana para sua planta ficar saudavel. Nesse retorno, quero que devolva no seguinte formato json 

{
"name": "Espada de São Jorge",
"cientificName": "Dracaena trifasciata",
"description": "A Espada de São Jorge é uma planta nativa da África Ocidental, conhecida por suas folhas eretas e pontiagudas que lembram uma espada. É uma planta popular em decoração por sua beleza e por ser muito fácil de cuidar.",
"items": [
{
"title": "Iluminação:",
"description": "Mantenha sua Espada de São Jorge em um local com luz indireta brilhante a moderada. Evite o sol direto, pois pode queimar suas folhas."
},
{
"title": "Rega:",
"description": "A Espada de São Jorge é uma planta suculenta, o que significa que armazena água em suas folhas. Regue apenas quando o solo estiver seco ao toque, geralmente a cada 10-14 dias. Evite encharcar o solo, pois pode levar ao apodrecimento das raízes."
},
{
"title": "Umidade:",
"description": "A Espada de São Jorge tolera bem o ar seco, mas se beneficia de um aumento da umidade. Você pode borrifar as folhas com água uma vez por semana ou colocar o vaso em uma bandeja com seixos úmidos."
},
{
"title": "Temperatura:",
"description": "A Espada de São Jorge prefere temperaturas entre 18-24°C. Evite temperaturas abaixo de 10°C."
},
{
"title": "Fertilização:",
"description": "Fertilize sua Espada de São Jorge uma vez por mês durante a primavera e o verão com um fertilizante balanceado para plantas de interior."
}
]
}

Analise a imagem enviada.
          ''',
        ),
        DataPart(
          "image/jpeg",
          imageBytes,
        )
      ])
    ]);

    final plant =
        Plant.fromJson(response.text!).copyWith(imageBytes: imageBytes);
    final instance = await SharedPreferences.getInstance();
    final plants = instance.getStringList("plants") ?? [];
    plants.add(plant.toJson());
    await instance.setStringList("plants", plants);
    closeLoading();
    openBottomSheet(
      plant: plant,
    );
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        key: globalKey,
        body: Stack(
          children: [
            Scaffold(
                body: AnimatedBuilder(
              animation: controller,
              builder: (context, child) => controller.cameraController != null
                  ? SizedBox(
                      width: MediaQuery.of(context).size.width,
                      height: MediaQuery.of(context).size.height,
                      child: CameraPreview(controller.cameraController!))
                  : const SizedBox(),
            )),
            Align(
              alignment: Alignment.bottomCenter,
              child: Container(
                decoration: const BoxDecoration(
                  color: Color(0xFFF4F4E9),
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(32),
                    topRight: Radius.circular(32),
                  ),
                ),
                width: double.infinity,
                height: MediaQuery.of(context).size.height * 0.16,
                child: Column(
                  children: [
                    const SizedBox(
                      height: 8,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        ActionButton.gallery(onTap: () async {
                          final image = await ImagePicker()
                              .pickImage(source: ImageSource.gallery);
                          if (image != null) {
                            final bytes = await image.readAsBytes();
                            searchPlant(imageBytes: bytes);
                          }
                        }),
                        TakePhotoButton(
                          onTap: () async {
                            final image = await controller.cameraController!
                                .takePicture();
                            final bytes = await image.readAsBytes();

                            searchPlant(imageBytes: bytes);
                          },
                        ),
                        ActionButton.changeCamera(
                          onTap: () {
                            controller.changeCamera();
                          },
                        )
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
