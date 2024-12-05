import 'dart:ui';
import 'package:image/image.dart' as img;
import 'package:leaf_disease_app/src/domain/settings/repository/settings.dart';

class LeafDiseaseResult {
  final String disease;
  final double confidence;
  final Rect region;
  final img.Image regionImage;

  LeafDiseaseResult({required this.disease, required this.confidence, required this.region, required this.regionImage});
}

abstract class LeafDiseaseDetectionRepository {
  Future<List<LeafDiseaseResult>> detectDiseases(img.Image image, LeafType leafType);
}
