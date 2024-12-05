import 'package:leaf_disease_app/src/domain/disease_classification/classifier/leaf_disease_classifier.dart';
import 'package:leaf_disease_app/src/utils/image_utils.dart';
import 'package:pytorch_lite/pytorch_lite.dart';
import 'package:image/image.dart' as img;

final class LeafDiseaseClassifierTorchConfig {
  final String modelPath;
  final String labelPath;

  const LeafDiseaseClassifierTorchConfig({required this.modelPath, required this.labelPath});
}

final class LeafDiseaseTorchClassifier extends LeafDiseaseClassifier {
  final LeafDiseaseClassifierTorchConfig config;

  late final Future<ClassificationModel> _model = _loadModel();

  LeafDiseaseTorchClassifier(this.config);

  @override
  Future<LeafDiseaseClassificationResult> classifyDisease(img.Image image) async {
    final model = await _model;

    final imageBytes = await ImageUtils.encodeJpgImage(image);
    final imagePredictions = await model.getImagePredictionList(imageBytes);
    final maxConfidenceIndex = model.softMax(imagePredictions);
    final label = model.labels[maxConfidenceIndex];

    return LeafDiseaseClassificationResult(
      label: label,
      healthy: label.toLowerCase() == healthyLabel,
      confidence: imagePredictions[maxConfidenceIndex],
    );
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

  static const healthyLabel = "healthy";
}
