import 'dart:typed_data';

class LeafDeaseState {
  final String deaseName;
  final double confidence;
  final Uint8List? imageBytes;

  LeafDeaseState({required this.deaseName, required this.confidence, this.imageBytes});
}
