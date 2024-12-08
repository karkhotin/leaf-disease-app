import 'dart:ui';
import 'package:image/image.dart' as img;

abstract class LeafDetector {
  Future<List<Rect>> detectLeafs(img.Image image);
}
