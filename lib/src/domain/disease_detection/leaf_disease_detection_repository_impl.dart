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

  LeafDiseaseDetectionRepositoryImpl(
      {required LeafDetector leafDetector, required LeafDiseaseClassifierProvider leafDiseaseClassifierProvider})
      : _leafDetector = leafDetector,
        _leafDiseaseClassifierProvider = leafDiseaseClassifierProvider;

  @override
  Future<List<LeafDiseaseResult>> detectDiseases(img.Image image, LeafType leafType) async {
    final leafs = await _leafDetector.detectLeafsFromImage(image);
    if (leafs.isEmpty) {
      return [];
    }
    final classifier = _leafDiseaseClassifierProvider.provideClassifier(leafType);
    final classificationFutures = leafs.map((rect) {
      return _classifyLeaf(classifier, image, rect);
    });
    final results = await Future.wait(classificationFutures);
    return results.whereNotNull().toList();
  }

  Future<LeafDiseaseResult?> _classifyLeaf(LeafDiseaseClassifier classifier, img.Image image, Rect relativeRect) async {
    final croppedImage = await _cropImage(image, relativeRect);
    final diseases = await classifier.classifyDisease(croppedImage);
    if (diseases.isEmpty) {
      return null;
    }
    final disease = diseases.first;
    return LeafDiseaseResult(
      disease: disease.label,
      confidence: disease.confidence,
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
