import 'package:camera/camera.dart';

sealed class LiveDetectionEvent {
  const LiveDetectionEvent();
}

final class LiveDetectionFrameCaptured extends LiveDetectionEvent {
  final CameraImage frame;

  const LiveDetectionFrameCaptured(this.frame);
}
