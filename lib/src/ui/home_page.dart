import 'dart:developer';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:leaf_disease_app/src/domain/leaf_detection/leaf_detector_impl.dart';
import 'package:image/image.dart' as image_lib;
import 'package:leaf_disease_app/src/ui/detection_view_pytorch.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return SafeArea(child: TestStatfulWidget());
    // return TextButton(
    //   onPressed: () {
    //     print("I'm here!");
    //   },
    //   child: Text("Push me!"),
    // );
  }
}

class TestStatfulWidget extends StatefulWidget {
  const TestStatfulWidget({super.key});

  @override
  State<TestStatfulWidget> createState() => _TestStatfulWidgetState();
}

class _TestStatfulWidgetState extends State<TestStatfulWidget> {
  final detector = LeafDetectorImpl();
  final imagePicker = ImagePicker();
  String? imagePath;
  image_lib.Image? image;
  List<Rect> _rects = [];

  @override
  Widget build(BuildContext context) {
    return DetectionPytorchView();

    // return Column(
    //   children: [
    //     TextButton(
    //       onPressed: () async {
    //         final result = await imagePicker.pickImage(
    //           source: ImageSource.gallery,
    //         );

    //         imagePath = result?.path;
    //         // setState(() {});
    //         _processImage();
    //       },
    //       child: Text("Push me!"),
    //     ),
    //     Expanded(
    //       child: Stack(
    //         // fit: StackFit.expand,
    //         children: [
    //           if (imagePath != null)
    //             Image.file(
    //               File(imagePath!),
    //               fit: BoxFit.fill,
    //               width: 350,
    //               height: 350,
    //             ),
    //           CustomPaint(
    //             size: Size(350, 350),
    //             painter: BoundingBoxesPainter(rects: _rects),
    //           ),
    //         ],
    //       ),
    //     )
    //   ],
    // );
  }

  Future<void> _processImage() async {
    if (imagePath == null) {
      return;
    }

    // Read image bytes from file
    final imageData = File(imagePath!).readAsBytesSync();

    // Decode image using package:image/image.dart (https://pub.dev/image)
    image = image_lib.decodeImage(imageData);

    final rects = await detector.detectLeafs(image!);
    log(rects.toString());

    _rects = rects;
    setState(() {});
    // classification = await imageClassificationHelper?.inferenceImage(image!);
    // setState(() {});
  }
}

class BoundingBoxesPainter extends CustomPainter {
  final List<Rect> rects;

  BoundingBoxesPainter({super.repaint, required this.rects});

  @override
  void paint(Canvas canvas, Size size) {
    for (var rect in rects) {
      final transformedRect = Rect.fromLTWH(
          rect.left * size.width, rect.top * size.height, rect.width * size.width, rect.height * size.height);
      canvas.drawRect(
        transformedRect,
        Paint()
          ..style = PaintingStyle.stroke
          ..color = Color(0xFF0099FF),
      );
    }
  }

  @override
  bool shouldRepaint(BoundingBoxesPainter oldDelegate) {
    return rects == oldDelegate.rects;
  }
}
