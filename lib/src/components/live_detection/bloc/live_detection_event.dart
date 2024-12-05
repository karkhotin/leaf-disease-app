import 'package:camera/camera.dart';

sealed class LiveDetectionEvent {
  const LiveDetectionEvent();
}

final class LiveDetectionCameraInitTriggered extends LiveDetectionEvent {
  const LiveDetectionCameraInitTriggered();
}

final class LiveDetectionCameraInitialized extends LiveDetectionEvent {
  const LiveDetectionCameraInitialized();
}

final class LiveDetectionCameraVisibilityChanged extends LiveDetectionEvent {
  final bool visible;
  
  const LiveDetectionCameraVisibilityChanged(this.visible);
}

final class LiveDetectionFrameCaptured extends LiveDetectionEvent {
  final CameraImage frame;

  const LiveDetectionFrameCaptured(this.frame);
}

final class LiveDetectionCameraPreviewToggled extends LiveDetectionEvent {
  const LiveDetectionCameraPreviewToggled();
}
