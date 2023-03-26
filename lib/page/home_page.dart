import 'dart:async';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:image_picker/image_picker.dart';
import 'package:spotflod/page/prediction_page.dart';

import '../data/diseases.dart';
import 'about_page.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  static const id = '/home_page';

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  static const platform = MethodChannel('classifier');

  late ImagePicker imagePicker;
  String? imageFile;
  final textController = TextEditingController();

  @override
  void initState() {
    super.initState();
    imagePicker = ImagePicker();
    lockPortrait();
  }

  @override
  void dispose() {
    textController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFdbe7c8),
      body: SafeArea(
        child: Stack(
          children: [
            spinoImage(),
            cameraAndGalleryDock(),
          ],
        ),
      ),
    );
  }

  Future<void> pickImage({bool camera = false}) async {
    try {
      await imagePicker
          .pickImage(
              source: camera == true ? ImageSource.camera : ImageSource.gallery,
              maxHeight: 180,
              maxWidth: 180,
              imageQuality: 85)
          .then((image) {
        imageFile = image!.path;
      });
    } on PlatformException catch (_) {
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Camera is not available.')));
      }
    }
  }

  Future<void> classifyImage() async {
    await platform.invokeMethod('classifyImage',{"path":imageFile!}).then((response) {

      List<String> controlMeasures =
          Diseases.getControlMeasures(response['label']!);

      Navigator.push(context, MaterialPageRoute(builder: (context) {
        return PredictionPage(
          file: imageFile!,
          controlMeasures: controlMeasures,
          classLabelIndex: response['index'],
        );
      }));
    });
  }

  void lockPortrait() {
    SystemChrome.setPreferredOrientations(
        [DeviceOrientation.portraitUp, DeviceOrientation.portraitDown]);
  }

  spinoImage() {
    return Align(
      alignment: Alignment.center,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(16),
              child: Image.asset(
                "assets/images/spinosaurus.jpg",
                filterQuality: FilterQuality.low,
              ),
            ),
          ),
          InkWell(
            onTap: () => Navigator.of(context).pushNamed(AboutPage.id),
            child: const Text(
              "-----------",
              style: TextStyle(
                fontSize: 22,
                color: Color(0XFF57624a),
              ),
            ),
          ),
        ],
      ),
    );
  }

  cameraAndGalleryDock() {
    return Align(
      alignment: Alignment.bottomCenter,
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SizedBox(
          height: 100,
          child: Card(
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(32)),
            elevation: 8,
            color: const Color(0XFFbbece8),
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Row(
                children: [
                  const Expanded(
                    child: Text(
                      '  SpotFlod',
                      style: TextStyle(fontSize: 22, color: Color(0XFF386664)),
                      maxLines: 1,
                    ),
                  ),
                  Expanded(
                    child: InkWell(
                      radius: 16,
                      borderRadius: BorderRadius.circular(32),
                      onTap: () async {
                        await pickImage(camera: true);
                        classifyImage();
                      },
                      child: const CircleAvatar(
                        radius: 32,
                        backgroundColor: Color(0XFF386664),
                        foregroundColor: Color(0XFFdbe7c8),
                        child: Icon(Icons.camera_alt_rounded, size: 48),
                      ),
                    ),
                  ),
                  Expanded(
                    child: Align(
                      alignment: Alignment.centerRight,
                      child: IconButton(
                        onPressed: () async {
                          await pickImage();
                          classifyImage();
                        },
                        icon: const Icon(
                          Icons.image_rounded,
                          color: Color(0XFF386664),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}