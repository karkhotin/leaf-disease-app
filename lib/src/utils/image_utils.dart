import 'dart:typed_data';

import 'package:image/image.dart' as img;

sealed class ImageUtils {
  static Future<Uint8List> encodeJpgImage(img.Image image) async {
    final command = img.Command()
      ..image(image)
      ..encodeJpg();
    await command.executeThread();
    return command.outputBytes!;
  }
}
