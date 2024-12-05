import 'dart:ui';
import 'package:image/image.dart' as img;
import 'package:leaf_disease_app/src/domain/dease_classification/classifier/leaf_dease_classifier.dart';
import 'package:leaf_disease_app/src/domain/dease_classification/classifier_factory/leaf_dease_classifier_provider.dart';
import 'package:leaf_disease_app/src/domain/dease_detection/leaf_dease_detection_repository.dart';
import 'package:leaf_disease_app/src/domain/leaf_detection/leaf_detector.dart';
import 'package:collection/collection.dart';
import 'package:leaf_disease_app/src/domain/settings/repository/settings.dart';

final class LeafDeaseDetectionRepositoryImpl extends LeafDeaseDetectionRepository {
  final LeafDetector _leafDetector;
  final LeafDeaseClassifierProvider _leafDeaseClassifierProvider;

  LeafDeaseDetectionRepositoryImpl(
      {required LeafDetector leafDetector, required LeafDeaseClassifierProvider leafDeaseClassifierProvider})
      : _leafDetector = leafDetector,
        _leafDeaseClassifierProvider = leafDeaseClassifierProvider;

  @override
  Future<List<LeafDeaseResult>> detectDeases(img.Image image, LeafType leafType) async {
    final leafs = await _leafDetector.detectLeafsFromImage(image);
    if (leafs.isEmpty) {
      return [];
    }
    final classifier = _leafDeaseClassifierProvider.provideClassifier(leafType);
    final classificationFutures = leafs.map((rect) {
      return _classifyLeaf(classifier, image, rect);
    });
    final results = await Future.wait(classificationFutures);
    return results.whereNotNull().toList();
  }

  Future<LeafDeaseResult?> _classifyLeaf(LeafDeaseClassifier classifier, img.Image image, Rect relativeRect) async {
    final croppedImage = await _cropImage(image, relativeRect);
    final deases = await classifier.classifyDease(croppedImage);
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
