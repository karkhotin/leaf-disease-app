import 'package:image/image.dart' as image_lib;

class LeafDiseaseClassificationResult {
  final String label;
  final double confidence;

  LeafDiseaseClassificationResult({required this.label, required this.confidence});
}

abstract class LeafDiseaseClassifier {
  const LeafDiseaseClassifier();

  Future<List<LeafDiseaseClassificationResult>> classifyDisease(image_lib.Image image);
}
