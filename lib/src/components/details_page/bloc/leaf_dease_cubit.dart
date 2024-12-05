import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:leaf_disease_app/src/domain/dease_detection/leaf_dease_detection_repository.dart';
import 'package:leaf_disease_app/src/components/details_page/bloc/leaf_dease_state.dart';
import 'package:image/image.dart' as img;

class LeafDeaseCubit extends Cubit<LeafDeaseState> {
  LeafDeaseCubit(LeafDeaseResult result)
      : super(LeafDeaseState(
          deaseName: result.dease,
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
    emit(LeafDeaseState(
      deaseName: state.deaseName,
      confidence: state.confidence,
      imageBytes: command.outputBytes,
    ));
  }
}
