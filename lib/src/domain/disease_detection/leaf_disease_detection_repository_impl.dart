import 'dart:ui';
import 'package:image/image.dart' as img;
import 'package:leaf_disease_app/src/domain/disease_classification/classifier/leaf_disease_classifier.dart';
import 'package:leaf_disease_app/src/domain/disease_classification/classifier_factory/leaf_disease_classifier_provider.dart';
import 'package:leaf_disease_app/src/domain/disease_detection/leaf_disease_detection_repository.dart';
import 'package:leaf_disease_app/src/domain/leaf_detection/leaf_detector.dart';
import 'package:collection/collection.dart';
import 'package:leaf_disease_app/src/domain/settings/repository/settings.dart';

final class LeafDiseaseDetectionRepositoryImpl extends LeafDiseaseDetectionRepository {
  final LeafDetector _leafDetector;
  final LeafDiseaseClassifierProvider _leafDiseaseClassifierProvider;

  LeafDiseaseDetectionRepositoryImpl({
    required LeafDetector leafDetector,
    required LeafDiseaseClassifierProvider leafDiseaseClassifierProvider,
  })  : _leafDetector = leafDetector,
        _leafDiseaseClassifierProvider = leafDiseaseClassifierProvider;

  @override
  Future<List<LeafDiseaseDetectionResult>> detectDiseases(img.Image image, LeafType leafType) async {
    final leafs = await _leafDetector.detectLeafs(image);
    if (leafs.isEmpty) {
      return [];
    }
    final classifier = _leafDiseaseClassifierProvider.provideClassifier(leafType);
    final results = <LeafDiseaseDetectionResult>[];
    for (var rect in leafs) {
      final result = await _classifyLeafDisease(classifier, leafType, image, rect);
      if (result != null) {
        results.add(result);
      }
    }
    return results.whereNotNull().toList();
  }

  Future<LeafDiseaseDetectionResult?> _classifyLeafDisease(
    LeafDiseaseClassifier classifier,
    LeafType leafType,
    img.Image image,
    Rect relativeRect,
  ) async {
    final croppedImage = await _cropImage(image, relativeRect);
    final classificationResult = await classifier.classifyDisease(croppedImage);

    return LeafDiseaseDetectionResult(
      label: classificationResult.label,
      healthy: classificationResult.healthy,
      confidence: classificationResult.confidence,
      leafType: leafType,
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
