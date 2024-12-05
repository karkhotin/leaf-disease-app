import 'package:leaf_disease_app/src/domain/disease_classification/classifier/leaf_disease_classifier.dart';
import 'package:leaf_disease_app/src/domain/disease_classification/classifier/leaf_disease_tflite_classifier.dart';
import 'package:leaf_disease_app/src/domain/disease_classification/classifier_factory/leaf_disease_classifier_provider.dart';
import 'package:leaf_disease_app/src/domain/settings/repository/settings.dart';

final class LeafDiseaseTfLiteClassifierProvider extends LeafDiseaseClassifierProvider {
  static final _configs = {
    LeafType.grape: _defaultConfig("classification_grape"),
  };

  static LeafDiseaseClassifierTfLiteConfig _defaultConfig(String modelName) {
    return LeafDiseaseClassifierTfLiteConfig(
      modelPath: "assets/models/classification/$modelName.tflite",
      labelPath: "assets/models/classification/${modelName}_labels.txt",
    );
  }

  @override
  LeafDiseaseClassifier provideClassifier(LeafType leafType) {
    final config = _configs[LeafType.grape];
    // final config = _configs[leafType];
    if (config == null) {
      throw AssertionError("Config for $leafType is missing!");
    }
    return LeafDiseaseClassifierTfLiteClassifier(config);
  }
}
