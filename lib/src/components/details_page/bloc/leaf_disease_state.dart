import 'dart:typed_data';

class LeafDiseaseState {
  final String diseaseName;
  final double confidence;
  final Uint8List? imageBytes;

  LeafDiseaseState({required this.diseaseName, required this.confidence, this.imageBytes});
}
