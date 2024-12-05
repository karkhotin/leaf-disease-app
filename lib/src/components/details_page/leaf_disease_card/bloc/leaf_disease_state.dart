import 'dart:typed_data';

import 'package:leaf_disease_app/src/domain/settings/repository/settings.dart';

class LeafDiseaseState {
  final LeafType leafType;
  final String label;
  final bool healthy;
  final double confidence;
  final Uint8List? imageBytes;

  LeafDiseaseState({
    required this.leafType,
    required this.label,
    required this.healthy,
    required this.confidence,
    this.imageBytes,
  });
}
