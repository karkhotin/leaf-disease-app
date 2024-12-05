import 'dart:ui';

class LiveDetectionRect {
  final Rect relativeRect;
  final String label;

  const LiveDetectionRect({required this.relativeRect, required this.label});
}

class LiveDetectionState {
  final List<LiveDetectionRect> rects;
  final bool processingFrame;

  const LiveDetectionState({this.rects = const [], this.processingFrame = false});
}
