import 'package:leaf_disease_app/src/domain/dease_classification/classifier/leaf_dease_classifier.dart';
import 'package:leaf_disease_app/src/domain/dease_classification/classifier/leaf_dease_torch_classifier.dart';
import 'package:leaf_disease_app/src/domain/dease_classification/classifier_factory/leaf_dease_classifier_provider.dart';
import 'package:leaf_disease_app/src/domain/settings/repository/settings.dart';

final class LeafDeaseTorchClassifierProvider extends LeafDeaseClassifierProvider {
  static final _configs = {
    LeafType.grape: _defaultConfig("classification_grape"),
  };

  static LeafDeaseClassifierTorchConfig _defaultConfig(String modelName) {
    return LeafDeaseClassifierTorchConfig(
      modelPath: "assets/models/classification/$modelName.pt",
      labelPath: "assets/models/classification/${modelName}_labels.txt",
    );
  }

  @override
  LeafDeaseClassifier provideClassifier(LeafType leafType) {
    final config = _configs[leafType];
    if (config == null) {
      throw AssertionError("Config for $leafType is missing!");
    }
    return LeafDeaseTorchClassifier(config);
  }
}
