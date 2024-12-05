import 'dart:developer';
import 'dart:io';

import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:leaf_disease_app/src/domain/leaf_detection/leaf_detector_impl.dart';

class LiveDetectionView extends StatefulWidget {
  const LiveDetectionView({super.key});

  @override
  State<LiveDetectionView> createState() => _LiveDetectionViewState();
}

class _LiveDetectionViewState extends State<LiveDetectionView> with WidgetsBindingObserver {
  final detector = LeafDetectorImpl();
  bool cameraReady = false;
  late CameraController _cameraController;
  List<Rect> _rects = [];
  bool _isProcessing = false;

  Future<void> _initCameraController() async {
    final cameras = await availableCameras();
    if (cameras.isEmpty) {
      return;
    }
    final controller = CameraController(cameras[0], ResolutionPreset.low, enableAudio: false);
    await controller.initialize();
    controller.startImageStream(_processImage);
    _cameraController = controller;
    cameraReady = true;
    if (mounted) {
      setState(() {});
    }
  }

  @override
  void initState() {
    WidgetsBinding.instance.addObserver(this);
    _initCameraController();
    super.initState();
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    if (cameraReady) {
      _cameraController.dispose();
    }
    super.dispose();
  }

  @override
  Future<void> didChangeAppLifecycleState(AppLifecycleState state) async {
    if (!cameraReady) {
      return;
    }
    switch (state) {
      case AppLifecycleState.paused:
        _cameraController.stopImageStream();
        break;
      case AppLifecycleState.resumed:
        if (!_cameraController.value.isStreamingImages) {
          await _cameraController.startImageStream(_processImage);
        }
        break;
      default:
    }
  }

  @override
  Widget build(BuildContext context) {
    if (!cameraReady || !_cameraController.value.isInitialized) {
      return Container(
        decoration: BoxDecoration(
          border: Border.all(color: Color(0xFF0099FF), width: 3),
          borderRadius: const BorderRadius.all(Radius.circular(2)),
        ),
        child: Center(child: Text("Camera Preview is unavailable.")),
      );
    }
    return _buildCamera(context);
    // return cameraWidget(context);
    // return CameraPreview(_cameraController);
    // return Column(
    //   children: [
    //     TextButton(
    //       onPressed: () async {
    //         final result = await imagePicker.pickImage(
    //           source: ImageSource.gallery,
    //         );
    //         _imagePath = result?.path;
    //         _rects = [];
    //         setState(() {});
    //         _processImage();
    //       },
    //       child: Text("Push me!"),
    //     ),
    //     Flexible(
    //       fit: FlexFit.loose,
    //       child: _buildImage(),
    //     ),
    //   ],
    // );
  }

  Widget _buildCamera(BuildContext context) {
    return Stack(
      children: [
        Positioned.fill(
          child: CameraPreview(_cameraController),
        ),
        Positioned.fill(
          child: _buildRects(),
        ),
      ],
    );
  }

  Widget cameraWidget(context) {
    var camera = _cameraController.value;
    // fetch screen size
    final size = MediaQuery.of(context).size;

    // calculate scale depending on screen and camera ratios
    // this is actually size.aspectRatio / (1 / camera.aspectRatio)
    // because camera preview size is received as landscape
    // but we're calculating for portrait orientation
    var scale = size.aspectRatio * camera.aspectRatio;

    // to prevent scaling down, invert the value
    if (scale < 1) scale = 1 / scale;

    return Transform.scale(
      scale: scale,
      child: Center(
        child: CameraPreview(_cameraController),
      ),
    );
  }

  Future<void> _processImage(CameraImage cameraImage) async {
    // if (_imagePath == null) {
    //   setState(() {});
    //   return;
    // }

    if (_isProcessing) {
      return;
    }
    _isProcessing = true;
    final rects = await detector.detectLeafsFromCamera(cameraImage);
    _isProcessing = false;
    log(rects.toString());

    _rects = rects;
    setState(() {});
  }

  // Widget _buildImage() {
  // if (_imagePath == null) {
  //   return Container();
  // }
  // return Stack(
  //   children: [
  //     Image.file(
  //       File(_imagePath!),
  //     ),
  //     Positioned.fill(
  //       child: _buildRects(),
  //     ),
  //   ],
  // );
  // }

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
