import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:spotflod/components/fab_widget.dart';

import '../components/text_widget.dart';

class PredictionPage extends StatefulWidget {
  const PredictionPage(
      {Key? key, this.file, this.controlMeasures, this.classLabelIndex})
      : super(key: key);
  static const id = '/predication_page';
  final String? file;
  final List<String>? controlMeasures;
  final int? classLabelIndex;

  @override
  State<PredictionPage> createState() => _PredictionPageState();
}

class _PredictionPageState extends State<PredictionPage> {
  static const platform = MethodChannel('classifier');

  List<String> classLabels = [
    'Aphids',
    'Army worm',
    'Bacterial Blight',
    'Curl Virus',
    'Fusarium wilt',
    'Healthy',
    'Powdery mildew',
    'Target spot'
  ];

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
          String cachePath = await platform.invokeMethod('cacheDir');
          Directory(cachePath).deleteSync(recursive: true);
          return true;
      },
      child: Scaffold(
        backgroundColor: const Color(0XFFdbe7c8),
        body: SafeArea(
            child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Expanded(
                  flex: 3,
                  child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [image(), diseaseName()])),
              if (widget.classLabelIndex! != 5)
                Expanded(flex: 8, child: remedies()),
            ],
          ),
        )),
        floatingActionButton: const FabWidget(),
      ),
    );
  }

  image() {
    return ClipRRect(
      borderRadius: BorderRadius.circular(16),
      child: Image.file(
        File(widget.file!),
        height: 150,
        width: 150,
      ),
    );
  }

  diseaseName() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Center(
          child: TextWidget(
            classLabels[widget.classLabelIndex!],
            fontSize: 22,
            onBlueBg: false,
          ),
        ),
        if (widget.classLabelIndex! != 5)
          const TextWidget('Control Measures', fontSize: 22, onBlueBg: false)
      ],
    );
  }

  remedies() {
    return Card(
      color: const Color(0XFFe1e4d5),
      child: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: List.generate(
                  widget.controlMeasures!.length,
                  (index) => Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: TextWidget(
                      '* ${widget.controlMeasures![index]}',
                      textAlign: TextAlign.left,
                      fontSize: 20,
                      onBlueBg: false,
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
