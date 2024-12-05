import 'dart:ui';
import 'package:image/image.dart' as image_lib;

class LeafDeaseResult {
  final String? dease;
  final double confidence;
  final Rect region;

  LeafDeaseResult({required this.dease, required this.confidence, required this.region});
}

abstract class LeafDeaseDetectionRepository {
  Future<List<LeafDeaseResult>> detectDeases(image_lib.Image image);
}

class LeafDeaseDetectionRepositoryImpl extends LeafDeaseDetectionRepository {
  @override
  Future<List<LeafDeaseResult>> detectDeases(image_lib.Image image) async {
    return [];
  }
}
