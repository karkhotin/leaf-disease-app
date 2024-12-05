import 'package:flutter/services.dart';
import 'package:leaf_disease_app/src/domain/disease_classification/classifier/leaf_disease_classifier.dart';
import 'package:image/image.dart' as img;
import 'package:tflite_flutter/tflite_flutter.dart';

final class LeafDiseaseClassifierTfLiteConfig {
  final String modelPath;
  final String labelPath;

  const LeafDiseaseClassifierTfLiteConfig({required this.modelPath, required this.labelPath});
}

final class _ClassificationModel {
  final IsolateInterpreter interpreter;
  final List<int> inputShape;
  final List<int> outputShape;
  final List<String> labels;

  _ClassificationModel({
    required this.interpreter,
    required this.inputShape,
    required this.outputShape,
    required this.labels,
  });
}

final class LeafDiseaseClassifierTfLiteClassifier extends LeafDiseaseClassifier {
  final LeafDiseaseClassifierTfLiteConfig config;

  late final Future<_ClassificationModel> _model = _loadModel();

  LeafDiseaseClassifierTfLiteClassifier(this.config);

  @override
  Future<LeafDiseaseClassificationResult> classifyDisease(img.Image image) async {
    final model = await _model;

    final imageMatrix = await _prepareImageMatrix(image, model.inputShape[1], model.inputShape[2]);

    final input = [imageMatrix];
    final output = [List.filled(model.outputShape[1], 0.0)];

    await model.interpreter.run(input, output);

    final predictions = output.first;
    final maxConfidenceIndex = _maxValueIndex(predictions);
    final label = model.labels[maxConfidenceIndex];

    return LeafDiseaseClassificationResult(
      label: label,
      healthy: label.toLowerCase() == healthyLabel,
      confidence: predictions[maxConfidenceIndex],
    );
  }

  // Private

  static const healthyLabel = "healthy";

  Future<_ClassificationModel> _loadModel() async {
    final interpreter = await Interpreter.fromAsset(config.modelPath);
    final isolateInterpreter = await IsolateInterpreter.create(address: interpreter.address);
    final labels = await _loadLabels(config.labelPath);
    return _ClassificationModel(
      interpreter: isolateInterpreter,
      inputShape: interpreter.getInputTensors().first.shape,
      outputShape: interpreter.getOutputTensors().first.shape,
      labels: labels,
    );
  }

  Future<List<String>> _loadLabels(String labelPath) async {
    String labelsData = await rootBundle.loadString(labelPath);
    return labelsData.split("\n");
  }

  Future<List<List<List<int>>>> _prepareImageMatrix(img.Image image, int width, int height) async {
    final command = img.Command()
      ..image(image)
      ..copyResize(width: width, height: height);

    await command.executeThread();

    final imageInput = command.outputImage!;

    final imageMatrix = List.generate(
      imageInput.height,
      (y) => List.generate(
        imageInput.width,
        (x) {
          final pixel = imageInput.getPixel(x, y);
          return [pixel.r.toInt(), pixel.g.toInt(), pixel.b.toInt()];
        },
      ),
    );

    return imageMatrix;
  }

  int _maxValueIndex(List<double> values) {
    double maxValue = double.negativeInfinity;
    int maxScoreIndex = -1;

    for (int i = 0; i < values.length; i++) {
      if (values[i] > maxValue) {
        maxValue = values[i];
        maxScoreIndex = i;
      }
    }

    return maxScoreIndex;
  }
}
