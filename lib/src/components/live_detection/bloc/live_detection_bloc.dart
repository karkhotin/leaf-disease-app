import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:leaf_disease_app/src/domain/disease_detection/leaf_disease_detection_repository.dart';
import 'package:leaf_disease_app/src/components/live_detection/bloc/live_detection_event.dart';
import 'package:leaf_disease_app/src/components/live_detection/bloc/live_detection_state.dart';
import 'package:leaf_disease_app/src/domain/settings/repository/settings_repository.dart';
import 'package:pytorch_lite/image_utils_isolate.dart';

class LiveDetectionBloc extends Bloc<LiveDetectionEvent, LiveDetectionState> {
  final LeafDiseaseDetectionRepository leafDiseaseDetectionRepository;
  final SettingsRepository settingsRepository;

  LiveDetectionBloc({required this.leafDiseaseDetectionRepository, required this.settingsRepository})
      : super(LiveDetectionState()) {
    on<LiveDetectionFrameCaptured>(_onFrameCaptured);
  }

  Future<void> _onFrameCaptured(
    LiveDetectionFrameCaptured event,
    Emitter<LiveDetectionState> emit,
  ) async {
    if (state.processingFrame) {
      return;
    }
    emit(LiveDetectionState(rects: state.rects, processingFrame: true));
    // temp: move image processing to repository
    final image = await ImageUtilsIsolate.convertCameraImage(event.frame);
    if (image == null) {
      return;
    }
    final results =
        await leafDiseaseDetectionRepository.detectDiseases(image, settingsRepository.settings.activeLeafType);
    final mappedResults = results
        .map((result) => LiveDetectionRect(
              relativeRect: result.region,
              label: result.label,
            ))
        .toList();
    if (emit.isDone) {
      return;
    }
    emit(LiveDetectionState(rects: mappedResults, processingFrame: false));
  }
}
