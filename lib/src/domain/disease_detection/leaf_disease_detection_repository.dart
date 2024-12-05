import 'dart:ui';
import 'package:image/image.dart' as img;
import 'package:leaf_disease_app/src/domain/settings/repository/settings.dart';

class LeafDiseaseDetectionResult {
  final String label;
  final bool healthy;
  final double confidence;
  final LeafType leafType;
  final Rect region;
  final img.Image regionImage;

  LeafDiseaseDetectionResult({
    required this.label,
    required this.healthy,
    required this.confidence,
    required this.leafType,
    required this.region,
    required this.regionImage,
  });
}

abstract class LeafDiseaseDetectionRepository {
  Future<List<LeafDiseaseDetectionResult>> detectDiseases(img.Image image, LeafType leafType);
}
