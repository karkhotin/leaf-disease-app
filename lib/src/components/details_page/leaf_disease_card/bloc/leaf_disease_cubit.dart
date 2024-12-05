import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:leaf_disease_app/src/components/details_page/leaf_disease_card/bloc/leaf_disease_state.dart';
import 'package:leaf_disease_app/src/domain/disease_detection/leaf_disease_detection_repository.dart';
import 'package:image/image.dart' as img;

class LeafDiseaseCubit extends Cubit<LeafDiseaseState> {
  LeafDiseaseCubit(LeafDiseaseResult result)
      : super(LeafDiseaseState(
          diseaseName: result.disease,
          confidence: result.confidence,
        )) {
    _loadImage(result.regionImage);
  }

  void _loadImage(img.Image image) async {
    final command = img.Command()
      ..image(image)
      ..encodeJpg();
    await command.executeThread();
    if (command.outputBytes == null) {
      return;
    }
    if (isClosed) {
      return;
    }
    emit(LeafDiseaseState(
      diseaseName: state.diseaseName,
      confidence: state.confidence,
      imageBytes: command.outputBytes,
    ));
  }
}
