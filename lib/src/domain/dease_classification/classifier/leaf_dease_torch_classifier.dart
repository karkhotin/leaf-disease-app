import 'package:image/image.dart' as image_lib;
import 'package:leaf_disease_app/src/domain/dease_classification/classifier/leaf_dease_classifier.dart';
import 'package:pytorch_lite/pytorch_lite.dart';
import 'package:image/image.dart' as img;

final class LeafDeaseClassifierTorchConfig {
  final String modelPath;
  final String labelPath;

  const LeafDeaseClassifierTorchConfig({required this.modelPath, required this.labelPath});
}

final class LeafDeaseTorchClassifier extends LeafDeaseClassifier {
  final LeafDeaseClassifierTorchConfig config;

  late final Future<ClassificationModel> _model = _loadModel();

  LeafDeaseTorchClassifier(this.config);

  @override
  Future<List<LeafDeaseClassificationResult>> classifyDease(image_lib.Image image) async {
    final model = await _model;

    final imageBytes = img.encodeJpg(image);
    String imagePrediction = await model.getImagePrediction(imageBytes);

    return [
      LeafDeaseClassificationResult(label: imagePrediction, confidence: 1.0),
    ];
  }

  // Private

  Future<ClassificationModel> _loadModel() {
    return PytorchLite.loadClassificationModel(
      config.modelPath,
      224,
      224,
      0, // Number of classes is ignored.
      labelPath: config.labelPath,
      ensureMatchingNumberOfClasses: false,
    );
  }
}
