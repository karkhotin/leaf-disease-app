import 'package:leaf_disease_app/src/domain/dease_classification/classifier/leaf_dease_classifier.dart';
import 'package:leaf_disease_app/src/domain/settings/repository/settings.dart';

abstract class LeafDeaseClassifierProvider {
  LeafDeaseClassifier provideClassifier(LeafType leafType);
}
