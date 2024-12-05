import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:leaf_disease_app/src/components/details_page/leaf_disease_card/bloc/leaf_disease_state.dart';
import 'package:leaf_disease_app/src/domain/disease_detection/leaf_disease_detection_repository.dart';
import 'package:image/image.dart' as img;
import 'package:leaf_disease_app/src/utils/image_utils.dart';

class LeafDiseaseCubit extends Cubit<LeafDiseaseState> {
  LeafDiseaseCubit(LeafDiseaseDetectionResult result)
      : super(LeafDiseaseState(
          leafType: result.leafType,
          label: result.label,
          healthy: result.healthy,
          confidence: result.confidence,
        )) {
    _loadImage(result.regionImage);
  }

  void _loadImage(img.Image image) async {
    final imageBytes = await ImageUtils.encodeJpgImage(image);
    if (isClosed) {
      return;
    }
    emit(LeafDiseaseState(
      leafType: state.leafType,
      label: state.label,
      healthy: state.healthy,
      confidence: state.confidence,
      imageBytes: imageBytes,
    ));
  }
}
