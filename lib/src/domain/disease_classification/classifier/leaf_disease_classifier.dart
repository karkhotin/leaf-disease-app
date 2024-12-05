import 'package:image/image.dart' as image_lib;

class LeafDiseaseClassificationResult {
  final String label;
  final bool healthy;
  final double confidence;

  LeafDiseaseClassificationResult({
    required this.label,
    required this.healthy,
    required this.confidence,
  });
}

abstract class LeafDiseaseClassifier {
  const LeafDiseaseClassifier();

  Future<LeafDiseaseClassificationResult> classifyDisease(image_lib.Image image);
}
