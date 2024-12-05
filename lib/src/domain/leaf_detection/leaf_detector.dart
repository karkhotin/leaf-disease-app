import 'dart:ui';
import 'package:image/image.dart' as img;

abstract class LeafDetector {
  Future<List<Rect>> detectLeafsFromImage(img.Image image);
}
