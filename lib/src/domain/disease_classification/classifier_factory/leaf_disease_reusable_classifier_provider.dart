import 'package:leaf_disease_app/src/domain/disease_classification/classifier/leaf_disease_classifier.dart';
import 'package:leaf_disease_app/src/domain/disease_classification/classifier_factory/leaf_disease_classifier_provider.dart';
import 'package:leaf_disease_app/src/domain/settings/repository/settings.dart';

final class LeafDiseaseReusableClassifierProvider extends LeafDiseaseClassifierProvider {
  final LeafDiseaseClassifierProvider _baseProvider;
  final Map<LeafType, LeafDiseaseClassifier> _cache = {};

  LeafDiseaseReusableClassifierProvider(LeafDiseaseClassifierProvider baseProvider) : _baseProvider = baseProvider;

  @override
  LeafDiseaseClassifier provideClassifier(LeafType leafType) {
    final cachedClassifier = _cache[leafType];
    if (cachedClassifier != null) {
      return cachedClassifier;
    }
    final classifier = _baseProvider.provideClassifier(leafType);
    _cache[leafType] = classifier;
    return classifier;
  }
}
