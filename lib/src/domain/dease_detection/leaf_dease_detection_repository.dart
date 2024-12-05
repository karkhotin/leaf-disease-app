import 'dart:ui';
import 'package:image/image.dart' as img;
import 'package:leaf_disease_app/src/domain/settings/repository/settings.dart';

class LeafDeaseResult {
  final String dease;
  final double confidence;
  final Rect region;
  final img.Image regionImage;

  LeafDeaseResult({required this.dease, required this.confidence, required this.region, required this.regionImage});
}

abstract class LeafDeaseDetectionRepository {
  Future<List<LeafDeaseResult>> detectDeases(img.Image image, LeafType leafType);
}
