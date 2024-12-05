import 'dart:developer';
import 'dart:ui';
import 'package:image/image.dart' as image_lib;
import 'package:leaf_disease_app/src/domain/leaf_detection/leaf_detector.dart';
import 'package:tflite_flutter/tflite_flutter.dart';

class _ResultItem {
  final Rect rect;
  final double confidence;

  _ResultItem({required this.rect, required this.confidence});
}

class LeafDetectorImpl extends LeafDetector {
  late final Future<Interpreter> _interpreter = _loadModel();

  @override
  Future<List<Rect>> detectLeafs(image_lib.Image image) async {
    final interpreter = await _interpreter;
    final inputShape = interpreter.getInputTensors().first.shape;
    final outputShape = interpreter.getOutputTensors().first.shape;

    // resize original image to match model shape.
    image_lib.Image imageInput = image_lib.copyResize(
      image!,
      width: inputShape[1],
      height: inputShape[2],
    );

    final imageMatrix = List.generate(
      imageInput.height,
      (y) => List.generate(
        imageInput.width,
        (x) {
          final pixel = imageInput.getPixel(x, y);
          return [pixel.r, pixel.g, pixel.b];
        },
      ),
    );

    final input = [imageMatrix];
    final output = [
      List.filled(outputShape[1] * outputShape[2], 0).reshape([outputShape[1], outputShape[2]])
    ];
    // final output = [List<int>.filled(outputShape[1], 0)];

    interpreter.run(input, output);

    final results = _extractResults(output[0].cast());
    log(output.toString());

    return results.map((result) => result.rect).toList();
  }

  // Private

  Future<Interpreter> _loadModel() {
    // return Interpreter.fromAsset('assets/models/detection/best_float32.tflite');
    return Interpreter.fromAsset('assets/models/detection/leaf_detection_float16.tflite');
  }

  List<_ResultItem> _extractResults(List<List<double>> output) {
    if (output.length != 5 || output[0].isEmpty) {
      return [];
    }
    final numberOfCell = output[0].length;
    List<_ResultItem> results = [];

    for (var i = 0; i < numberOfCell; ++i) {
      final confidence = output[4][i];
      if (confidence < 0.75) {
        continue;
      }

      final centerX = output[0][i];
      final centerY = output[1][i];
      final width = output[2][i];
      final height = output[3][i];
      if (centerX <= 0 || centerX >= 1 || centerY <= 0 || centerY >= 1 || width <= 0 || height <= 0) {
        continue;
      }

      final rect = Rect.fromCenter(center: Offset(centerX, centerY), width: width, height: height);

      results.add(_ResultItem(rect: rect, confidence: confidence));
    }

    return results;
  }
}

// plt.figure(figsize=(10, 10))

// for result in img_res:
//     boxes = result.boxes  # Get the detected boxes
//     if boxes is not None:
//         for box in boxes.xyxy:  # Iterate through each detected box
//             if len(box) == 4:  # Only x1, y1, x2, y2 are returned
//                 x1, y1, x2, y2 = box  # Get coordinates
//                 conf = result.boxes.conf[0]  # Get the confidence score
//                 cls = result.boxes.cls[0]  # Get the class index
//                 x1, y1, x2, y2 = map(int, (x1, y1, x2, y2))  # Convert to int
//                 label = f"{model_final.names[int(cls)]} {conf:.2f}"  # Get class name and confidence
//                 cv2.rectangle(image, (x1, y1), (x2, y2), (255, 0, 0), 2)  # Draw rectangle
//                 cv2.putText(image, label, (x1, y1 - 10), cv2.FONT_HERSHEY_SIMPLEX, 0.5, (255, 0, 0), 2)  # Draw label

// plt.imshow(image)
// plt.axis('off')
// plt.show()
