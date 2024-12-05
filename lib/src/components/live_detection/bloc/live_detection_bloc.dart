import 'dart:ui';

import 'package:camera/camera.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:leaf_disease_app/src/domain/disease_detection/leaf_disease_detection_repository.dart';
import 'package:leaf_disease_app/src/components/live_detection/bloc/live_detection_event.dart';
import 'package:leaf_disease_app/src/components/live_detection/bloc/live_detection_state.dart';
import 'package:leaf_disease_app/src/domain/settings/repository/settings_repository.dart';
import 'package:pytorch_lite/image_utils_isolate.dart';
import 'package:image/image.dart' as img;

class LiveDetectionBloc extends Bloc<LiveDetectionEvent, LiveDetectionState> {
  final LeafDiseaseDetectionRepository leafDiseaseDetectionRepository;
  final SettingsRepository settingsRepository;

  LiveDetectionBloc({
    required Size cameraFrameSize,
    required this.leafDiseaseDetectionRepository,
    required this.settingsRepository,
  }) : super(LiveDetectionState(cameraFrameSize: cameraFrameSize)) {
    on<LiveDetectionCameraInitTriggered>(_onCameraInitTriggered);
    on<LiveDetectionCameraInitialized>(_onCameraInitialized);
    on<LiveDetectionFrameCaptured>(_onFrameCaptured);
    on<LiveDetectionCameraVisibilityChanged>(_onCameraVisibilityChanged);
    on<LiveDetectionCameraPreviewToggled>(_onCameraPreviewToggled);
  }

  Future<void> _onFrameCaptured(
    LiveDetectionFrameCaptured event,
    Emitter<LiveDetectionState> emit,
  ) async {
    await _processFrame(event.frame, emit);
  }

  Future<void> _processFrame(CameraImage frame, Emitter<LiveDetectionState> emit) async {
    if (!settingsRepository.settings.isLiveDetectionEnabled) {
      emit(state.copyWith(
        rects: [],
        processingFrame: false,
        lastFrameImageProvider: () => _prepareFrameImage(frame),
      ));
      return;
    }

    if (state.processingFrame) {
      emit(state.copyWith(lastFrameImageProvider: () => _prepareFrameImage(frame)));
      return;
    }
    emit(state.copyWith(
      processingFrame: true,
      lastFrameImageProvider: () => _prepareFrameImage(frame),
    ));

    final image = await _prepareFrameImage(frame);
    if (image == null) {
      emit(state.copyWith(rects: [], processingFrame: false));
      return;
    }
    final detectionResults = await leafDiseaseDetectionRepository.detectDiseases(
      image,
      settingsRepository.settings.activeLeafType,
    );
    final mappedResults = detectionResults
        .map((result) => LiveDetectionRect(
              relativeRect: result.region,
              healthy: result.healthy,
            ))
        .toList();
    emit(state.copyWith(
      rects: mappedResults,
      processingFrame: false,
    ));
  }

  Future<img.Image?> _prepareFrameImage(CameraImage frame) async {
    final frameImage = await ImageUtilsIsolate.convertCameraImage(frame);
    if (frameImage == null) {
      return null;
    }
    final croppedImage = await _cropFrameImage(frameImage);
    return croppedImage;
  }

  Future<img.Image> _cropFrameImage(img.Image image) async {
    final targetWidth = image.height * state.cameraFrameSize.aspectRatio;
    final xOffset = (image.width - targetWidth) / 2.0;

    final command = img.Command()
      ..image(image)
      ..copyCrop(
        x: xOffset.round(),
        y: 0,
        width: targetWidth.round(),
        height: image.height,
      );
    await command.executeThread();
    return command.outputImage!;
  }

  Future<void> _onCameraInitTriggered(
    LiveDetectionCameraInitTriggered event,
    Emitter<LiveDetectionState> emit,
  ) async {
    emit(state.copyWith(cameraState: LiveDetectionCameraState.initialization));
  }

  Future<void> _onCameraInitialized(
    LiveDetectionCameraInitialized event,
    Emitter<LiveDetectionState> emit,
  ) async {
    emit(state.copyWith(cameraState: LiveDetectionCameraState.initialized));
  }

  Future<void> _onCameraVisibilityChanged(
    LiveDetectionCameraVisibilityChanged event,
    Emitter<LiveDetectionState> emit,
  ) async {
    emit(state.copyWith(cameraVisible: event.visible));
  }

  Future<void> _onCameraPreviewToggled(
    LiveDetectionCameraPreviewToggled event,
    Emitter<LiveDetectionState> emit,
  ) async {
    emit(state.copyWith(cameraPreviewPaused: !state.cameraPreviewPaused));
  }
}
