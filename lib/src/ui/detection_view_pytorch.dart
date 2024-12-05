import 'dart:developer';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:leaf_disease_app/src/domain/leaf_detection/leaf_detector_impl.dart';

class DetectionPytorchView extends StatefulWidget {
  const DetectionPytorchView({super.key});

  @override
  State<DetectionPytorchView> createState() => _DetectionPytorchViewState();
}

class _DetectionPytorchViewState extends State<DetectionPytorchView> {
  final detector = LeafDetectorImpl();
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
            _processImage();
          },
          child: Text("Push me!"),
        ),
        Flexible(
          fit: FlexFit.loose,
          child: _buildImage(),
        ),
      ],
    );
  }

  Future<void> _processImage() async {
    if (imagePath == null) {
      setState(() {});
      return;
    }

    final rects = await detector.detectLeafs(imagePath!);
    log(rects.toString());

    _rects = rects;
    setState(() {});
  }

  Widget _buildImage() {
    if (imagePath == null) {
      return Container();
    }
    return Stack(
      children: [
        Image.file(
          File(imagePath!),
        ),
        Positioned.fill(
          child: _buildRects(),
        ),
      ],
    );
  }

  Widget _buildRects() {
    return LayoutBuilder(builder: (context, constraints) {
      double factorX = constraints.maxWidth;
      double factorY = constraints.maxHeight;
      return Stack(
          children: _rects.map((rect) {
        return Positioned(
          left: rect.left * factorX,
          top: rect.top * factorY,
          child: Container(
            width: rect.width.toDouble() * factorX,
            height: rect.height.toDouble() * factorY,
            decoration: BoxDecoration(
                border: Border.all(color: Color(0xFF0099FF), width: 3),
                borderRadius: const BorderRadius.all(Radius.circular(2))),
            child: Container(),
          ),
        );
      }).toList());
    });
  }
}
