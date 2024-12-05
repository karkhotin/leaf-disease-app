import 'package:leaf_disease_app/src/domain/disease_classification/classifier/leaf_disease_classifier.dart';
import 'package:leaf_disease_app/src/domain/disease_classification/classifier/leaf_disease_torch_classifier.dart';
import 'package:leaf_disease_app/src/domain/disease_classification/classifier_factory/leaf_disease_classifier_provider.dart';
import 'package:leaf_disease_app/src/domain/settings/repository/settings.dart';

final class LeafDiseaseTorchClassifierProvider extends LeafDiseaseClassifierProvider {
  static final _configs = {
    LeafType.grape: _defaultConfig("classification_grape"),
  };

  static LeafDiseaseClassifierTorchConfig _defaultConfig(String modelName) {
    return LeafDiseaseClassifierTorchConfig(
      modelPath: "assets/models/classification/$modelName.pt",
      labelPath: "assets/models/classification/${modelName}_labels.txt",
    );
  }

  @override
  LeafDiseaseClassifier provideClassifier(LeafType leafType) {
    final config = _configs[leafType];
    if (config == null) {
      throw AssertionError("Config for $leafType is missing!");
    }
    return LeafDiseaseTorchClassifier(config);
  }
}
