import 'package:image/image.dart' as image_lib;
import 'package:leaf_disease_app/src/domain/dease_classification/leaf_dease_classifier.dart';

class LeafDeaseClassifierImpl extends LeafDeaseClassifier {
  @override
  Future<List<LeafDeaseClassificationResult>> classifyDease(image_lib.Image image) async {
    return [
      LeafDeaseClassificationResult(label: "healthy", confidence: 1.0),
    ];
  }
}
