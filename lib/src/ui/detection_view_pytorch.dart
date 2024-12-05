import 'dart:developer';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';
import 'package:pytorch_lite/pytorch_lite.dart';

class DetectionPytorchView extends StatefulWidget {
  const DetectionPytorchView({super.key});

  @override
  State<DetectionPytorchView> createState() => _DetectionPytorchViewState();
}

class _DetectionPytorchViewState extends State<DetectionPytorchView> {
  final imagePicker = ImagePicker();
  String? imagePath;
  List<Rect> _rects = [];
  Widget? _imageWithBoxes;

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
        if (_imageWithBoxes != null) Expanded(child: _imageWithBoxes!),
        // Stack(
        //   fit: StackFit.loose,
        //   alignment: AlignmentDirectional.center,
        //   children: [
        //     if (imagePath != null) Image.file(File(imagePath!)),
        //     if (imagePath != null)
        //       Positioned.fill(
        //         child: CustomPaint(
        //           // size: Size(350, 350),
        //           painter: _BoundingBoxesPainter(rects: _rects),
        //         ),
        //       ),
        //   ],
        // )
      ],
    );
  }

  Future<void> _processImage() async {
    if (imagePath == null) {
      return;
    }

    ModelObjectDetection objectModel = await PytorchLite.loadObjectDetectionModel(
        "assets/models/detection/best.torchscript", 1, 416, 416,
        labelPath: "assets/models/detection/best_labels.txt",
        objectDetectionModelType: ObjectDetectionModelType.yolov8);

    final image = File(imagePath!);
    List<ResultObjectDetection> objDetect =
        await objectModel.getImagePrediction(await image.readAsBytes(), minimumScore: 0.5, iOUThreshold: 0.3);

    _imageWithBoxes = objectModel.renderBoxesOnImage(image, objDetect);

    log(objDetect.toString());

    setState(() {});
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
