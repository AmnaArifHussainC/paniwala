import 'dart:io';
import 'package:image_picker/image_picker.dart';

class ImagePickerUtil {
  static final ImagePicker _picker = ImagePicker();


  // Pick multiple images from Gallery
  static Future<List<File>> pickMultipleImages() async {
    final pickedFiles = await _picker.pickMultiImage();
    return pickedFiles.map((pickedFile) => File(pickedFile.path)).toList();
  }
}
