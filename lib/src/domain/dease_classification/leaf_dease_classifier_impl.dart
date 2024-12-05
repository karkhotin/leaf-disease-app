
import 'package:image/image.dart' as image_lib;
import 'package:leaf_disease_app/src/domain/dease_classification/leaf_dease_classifier.dart';

class LeafDeaseClassifierImpl extends LeafDeaseClassifier {
  @override
  Map<LeafDease, double> classifyDease(image_lib.Image image) {
    return {};
  }
}