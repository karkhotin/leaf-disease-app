import 'package:leaf_disease_app/src/domain/dease_classification/classifier/leaf_dease_classifier.dart';
import 'package:leaf_disease_app/src/domain/dease_classification/classifier_factory/leaf_dease_classifier_provider.dart';
import 'package:leaf_disease_app/src/domain/settings/repository/settings.dart';

final class LeafDeaseCachedClassifierProvider extends LeafDeaseClassifierProvider {
  final LeafDeaseClassifierProvider _baseProvider;
  final Map<LeafType, LeafDeaseClassifier> _cache = {};

  LeafDeaseCachedClassifierProvider(LeafDeaseClassifierProvider baseProvider) : _baseProvider = baseProvider;

  @override
  LeafDeaseClassifier provideClassifier(LeafType leafType) {
    final cachedClassifier = _cache[leafType];
    if (cachedClassifier != null) {
      return cachedClassifier;
    }
    final classifier = _baseProvider.provideClassifier(leafType);
    _cache[leafType] = classifier;
    return classifier;
  }
}
