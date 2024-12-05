import 'package:leaf_disease_app/src/domain/disease_classification/classifier/leaf_disease_classifier.dart';
import 'package:leaf_disease_app/src/domain/disease_classification/classifier/leaf_disease_tflite_classifier.dart';
import 'package:leaf_disease_app/src/domain/disease_classification/classifier_factory/leaf_disease_classifier_provider.dart';
import 'package:leaf_disease_app/src/domain/settings/repository/settings.dart';

final class LeafDiseaseTfLiteClassifierProvider extends LeafDiseaseClassifierProvider {
  static final _configs = {
    LeafType.apple: _defaultConfig("classification_apple"),
    LeafType.cherry: _defaultConfig("classification_cherry"),
    LeafType.grape: _defaultConfig("classification_grape"),
    LeafType.pear: _defaultConfig("classification_pear"),
    LeafType.walnut: _defaultConfig("classification_walnut"),
  };

  static LeafDiseaseClassifierTfLiteConfig _defaultConfig(String modelName) {
    return LeafDiseaseClassifierTfLiteConfig(
      modelPath: "assets/models/classification/$modelName.tflite",
      labelPath: "assets/models/classification/${modelName}_labels.txt",
    );
  }

  @override
  LeafDiseaseClassifier provideClassifier(LeafType leafType) {
    final config = _configs[leafType];
    if (config == null) {
      throw AssertionError("Config for $leafType is missing!");
    }
    return LeafDiseaseClassifierTfLiteClassifier(config);
  }
}
