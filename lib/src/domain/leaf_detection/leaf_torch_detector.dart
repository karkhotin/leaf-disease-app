import 'dart:ui';
import 'package:leaf_disease_app/src/domain/leaf_detection/leaf_detector.dart';
import 'package:pytorch_lite/pytorch_lite.dart';
import 'package:image/image.dart' as img;

class LeafTorchDetector extends LeafDetector {
  late final Future<ModelObjectDetection> _model = _loadModel();

  @override
  Future<List<Rect>> detectLeafsFromImage(img.Image image) async {
    final model = await _model;
    final imageBytes = img.encodeJpg(image);
    List<ResultObjectDetection> predictions =
        await model.getImagePrediction(imageBytes, minimumScore: 0.5, iOUThreshold: 0.3);

    final rects = predictions.map((prediction) {
      final rect = prediction.rect;
      return Rect.fromLTWH(rect.left, rect.top, rect.width, rect.height);
    }).toList();

    return rects;
  }

  // Private

  Future<ModelObjectDetection> _loadModel() {
    return PytorchLite.loadObjectDetectionModel(
      "assets/models/detection/leaf_detection.torchscript",
      1,
      416,
      416,
      labelPath: "assets/models/detection/leaf_detection_labels.txt",
      objectDetectionModelType: ObjectDetectionModelType.yolov8,
    );
  }
}
