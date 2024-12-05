import 'dart:ui';
import 'package:camera/camera.dart';
import 'package:image/image.dart' as img;

abstract class LeafDetector {
  Future<List<Rect>> detectLeafs(String imagePath);

  Future<List<Rect>> detectLeafsFromCamera(CameraImage cameraImage);

  Future<List<Rect>> detectLeafsFromImage(img.Image image);
}
