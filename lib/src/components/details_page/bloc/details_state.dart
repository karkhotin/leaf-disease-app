import 'package:leaf_disease_app/src/domain/disease_detection/leaf_disease_detection_repository.dart';

sealed class DetailsState {
  const DetailsState();
}

final class DetailsClassifyingState extends DetailsState {
  final String imagePath;

  const DetailsClassifyingState({required this.imagePath});
}

final class DetailsClassifiedState extends DetailsState {
  final List<LeafDiseaseDetectionResult> results;

  const DetailsClassifiedState(this.results);
}

final class DetailsClassificationFailedState extends DetailsState {
  const DetailsClassificationFailedState();
}
