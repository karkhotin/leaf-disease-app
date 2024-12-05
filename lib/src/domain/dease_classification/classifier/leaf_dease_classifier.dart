import 'package:image/image.dart' as image_lib;

class LeafDeaseClassificationResult {
  final String label;
  final double confidence;

  LeafDeaseClassificationResult({required this.label, required this.confidence});
}

abstract class LeafDeaseClassifier {
  const LeafDeaseClassifier();

  Future<List<LeafDeaseClassificationResult>> classifyDease(image_lib.Image image);
}
