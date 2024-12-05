import 'package:leaf_disease_app/src/domain/disease_detection/leaf_disease_detection_repository.dart';
import 'package:image/image.dart' as img;

sealed class DetailsState {
  const DetailsState();
}

final class DetailsClassifyingImagePathState extends DetailsState {
  final String imagePath;

  const DetailsClassifyingImagePathState(this.imagePath);
}

final class DetailsClassifyingImageState extends DetailsState {
  final img.Image image;

  const DetailsClassifyingImageState(this.image);
}

final class DetailsClassifiedState extends DetailsState {
  final List<LeafDiseaseDetectionResult> results;

  const DetailsClassifiedState(this.results);
}

final class DetailsClassificationFailedState extends DetailsState {
  const DetailsClassificationFailedState();
}
