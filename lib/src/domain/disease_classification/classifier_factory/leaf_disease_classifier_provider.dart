import 'package:leaf_disease_app/src/domain/disease_classification/classifier/leaf_disease_classifier.dart';
import 'package:leaf_disease_app/src/domain/settings/repository/settings.dart';

abstract class LeafDiseaseClassifierProvider {
  LeafDiseaseClassifier provideClassifier(LeafType leafType);
}
