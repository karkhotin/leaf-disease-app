
import 'package:image/image.dart' as image_lib;

enum LeafDease { dease1, dease2, dease3 }

abstract class LeafDeaseClassifier {
  Map<LeafDease, double> classifyDease(image_lib.Image image);
}