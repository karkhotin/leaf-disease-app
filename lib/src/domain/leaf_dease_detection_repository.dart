import 'dart:ui';
import 'package:image/image.dart' as img;
import 'package:leaf_disease_app/src/domain/dease_classification/leaf_dease_classifier.dart';
import 'package:leaf_disease_app/src/domain/leaf_detection/leaf_detector.dart';
// import 'package:pytorch_lite/image_utils_isolate.dart';
// import 'package:pytorch_lite/pytorch_lite.dart';
import 'package:collection/collection.dart';

class LeafDeaseResult {
  final String dease;
  final double confidence;
  final Rect region;
  final img.Image regionImage;

  LeafDeaseResult({required this.dease, required this.confidence, required this.region, required this.regionImage});
}

abstract class LeafDeaseDetectionRepository {
  Future<List<LeafDeaseResult>> detectDeases(img.Image image);
}

class LeafDeaseDetectionRepositoryImpl extends LeafDeaseDetectionRepository {
  final LeafDetector _leafDetector;
  final LeafDeaseClassifier _leafDeaseClassifier;

  LeafDeaseDetectionRepositoryImpl(
      {required LeafDetector leafDetector, required LeafDeaseClassifier leafDeaseClassifier})
      : _leafDetector = leafDetector,
        _leafDeaseClassifier = leafDeaseClassifier;

  @override
  Future<List<LeafDeaseResult>> detectDeases(img.Image image) async {
    final leafs = await _leafDetector.detectLeafsFromImage(image);
    final classificationFutures = leafs.map((rect) {
      return _classifyLeaf(image, rect);
    });
    final results = await Future.wait(classificationFutures);
    return results.whereNotNull().toList();
  }

  Future<LeafDeaseResult?> _classifyLeaf(img.Image image, Rect relativeRect) async {
    final croppedImage = await _cropImage(image, relativeRect);
    final deases = await _leafDeaseClassifier.classifyDease(croppedImage);
    if (deases.isEmpty) {
      return null;
    }
    final dease = deases.first;
    return LeafDeaseResult(
      dease: dease.label,
      confidence: dease.confidence,
      region: relativeRect,
      regionImage: croppedImage,
    );
  }

  Future<img.Image> _cropImage(img.Image image, Rect relativeRect) async {
    final command = img.Command()
      ..image(image)
      ..copyCrop(
        x: (relativeRect.left * image.width).round(),
        y: (relativeRect.top * image.height).round(),
        width: (relativeRect.width * image.width).round(),
        height: (relativeRect.height * image.height).round(),
      );
    await command.executeThread();
    return command.outputImage!;
  }
}
