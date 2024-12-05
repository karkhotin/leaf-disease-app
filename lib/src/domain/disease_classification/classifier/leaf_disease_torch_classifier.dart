import 'package:image/image.dart' as image_lib;
import 'package:leaf_disease_app/src/domain/disease_classification/classifier/leaf_disease_classifier.dart';
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
  Future<List<LeafDiseaseClassificationResult>> classifyDisease(image_lib.Image image) async {
    final model = await _model;

    final imageBytes = img.encodeJpg(image);
    String imagePrediction = await model.getImagePrediction(imageBytes);

    return [
      LeafDiseaseClassificationResult(label: imagePrediction, confidence: 1.0),
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
