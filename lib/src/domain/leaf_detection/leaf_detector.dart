import 'dart:ui';
import 'package:image/image.dart' as image_lib;

abstract class LeafDetector {
  Future<List<Rect>> detectLeafs(image_lib.Image image);
}
