import 'dart:ui';
import 'package:image/image.dart' as img;

enum LiveDetectionCameraState { uninitialized, initialization, initialized }

class LiveDetectionRect {
  final Rect relativeRect;
  final bool healthy;

  const LiveDetectionRect({
    required this.relativeRect,
    required this.healthy,
  });
}

typedef FrameImageProvider = Future<img.Image?> Function();

class LiveDetectionState {
  final Size cameraFrameSize;
  final LiveDetectionCameraState cameraState;
  final List<LiveDetectionRect> rects;
  final bool processingFrame;
  final bool cameraVisible;
  final bool cameraPreviewPaused;

  final FrameImageProvider? _lastFrameImageProvider;

  bool get cameraPreviewActive =>
      cameraState == LiveDetectionCameraState.initialized && cameraVisible && !cameraPreviewPaused;

  Future<img.Image?> get lastFrameImage async => _lastFrameImageProvider != null ? _lastFrameImageProvider() : null;

  const LiveDetectionState({
    required this.cameraFrameSize,
    this.cameraState = LiveDetectionCameraState.uninitialized,
    this.rects = const [],
    this.processingFrame = false,
    this.cameraVisible = false,
    this.cameraPreviewPaused = false,
    FrameImageProvider? lastFrameImageProvider,
  }) : _lastFrameImageProvider = lastFrameImageProvider;

  LiveDetectionState copyWith({
    LiveDetectionCameraState? cameraState,
    List<LiveDetectionRect>? rects,
    bool? processingFrame,
    bool? cameraVisible,
    bool? cameraPreviewPaused,
    FrameImageProvider? lastFrameImageProvider,
  }) {
    return LiveDetectionState(
      cameraFrameSize: cameraFrameSize,
      cameraState: cameraState ?? this.cameraState,
      rects: rects ?? this.rects,
      processingFrame: processingFrame ?? this.processingFrame,
      cameraVisible: cameraVisible ?? this.cameraVisible,
      cameraPreviewPaused: cameraPreviewPaused ?? this.cameraPreviewPaused,
      lastFrameImageProvider: lastFrameImageProvider ?? _lastFrameImageProvider,
    );
  }
}
