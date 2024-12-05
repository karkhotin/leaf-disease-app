import 'dart:developer';
import 'dart:io';
import 'dart:ui' as ui;

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';
import 'package:ultralytics_yolo/ultralytics_yolo.dart';
import 'package:ultralytics_yolo/yolo_model.dart';

class DetectionView extends StatefulWidget {
  const DetectionView({super.key});

  @override
  State<DetectionView> createState() => _DetectionViewState();
}

class _DetectionViewState extends State<DetectionView> {
  late LocalYoloModel model;

  final imagePicker = ImagePicker();
  String? imagePath;
  List<Rect> _rects = [];

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        TextButton(
          onPressed: () async {
            final result = await imagePicker.pickImage(
              source: ImageSource.gallery,
            );

            imagePath = result?.path;
            setState(() {});
            _processImage();
          },
          child: Text("Push me!"),
        ),
        Stack(
          fit: StackFit.loose,
          alignment: AlignmentDirectional.center,
          children: [
            if (imagePath != null) Image.file(File(imagePath!)),
            if (imagePath != null)
              Positioned.fill(
                child: CustomPaint(
                  // size: Size(350, 350),
                  painter: _BoundingBoxesPainter(rects: _rects),
                ),
              ),
          ],
        )
      ],
    );
  }

  Future<void> _processImage() async {
    model = LocalYoloModel(
      id: "some-id",
      task: Task.detect /* or Task.classify */,
      // format: Format.tflite /* or Format.coreml*/,
      // modelPath: await _copy("assets/models/detection/best_int8.tflite"),
      // metadataPath: await _copy("assets/models/detection/best_int8.tflite.yaml"),
      format: Format.coreml /* or Format.coreml*/,
      modelPath: await _copy("assets/models/detection/best.mlmodel"),
      // metadataPath: null,
    );

    if (imagePath == null) {
      return;
    }
    final objectDetector = ObjectDetector(model: model);
    await objectDetector.loadModel();
    objectDetector.setConfidenceThreshold(0.7);
    objectDetector.setIouThreshold(0.8);

    final result = await objectDetector.detect(imagePath: imagePath!);
    log(result.toString());

    // File image = new File(imagePath!); // Or any other way to get a File instance.
    // final decodedImage = await decodeImageFromList(image.readAsBytesSync());

    final rects = result!.map((r) {
      final box = r!.boundingBox;
      return box;
      // return Rect.fromLTWH(box.left / 416, box.top / 416, box.width / 416, box.height / 416);
      // return Rect.fromLTWH(box.left / decodedImage.width, box.top / decodedImage.height, box.width / decodedImage.width,
      //     box.height / decodedImage.height);
    }).toList();
// print(decodedImage.width);
// print(decodedImage.height);
    setState(() {
      _rects = rects;
    });
  }

  Future<String> _copy(String assetPath) async {
    final path = '${(await getApplicationSupportDirectory()).path}/$assetPath';
    await Directory(dirname(path)).create(recursive: true);
    final file = File(path);
    if (!await file.exists()) {
      final byteData = await rootBundle.load(assetPath);
      await file.writeAsBytes(byteData.buffer.asUint8List(byteData.offsetInBytes, byteData.lengthInBytes));
    }
    return file.path;
  }
}

class _BoundingBoxesPainter extends CustomPainter {
  final List<Rect> rects;

  _BoundingBoxesPainter({super.repaint, required this.rects});

  @override
  void paint(Canvas canvas, Size size) {
    // canvas.drawRect(Rect., paint)
    for (var rect in rects) {
      // final transformedRect = Rect.fromLTWH(
      //     rect.left * size.width, rect.top * size.height, rect.width * size.width, rect.height * size.height);
      canvas.drawRect(
        rect,
        Paint()
          ..strokeWidth = 5
          ..style = PaintingStyle.stroke
          ..color = Color(0xFF0099FF),
      );
    }
  }

  @override
  bool shouldRepaint(_BoundingBoxesPainter oldDelegate) {
    return rects == oldDelegate.rects;
  }
}
