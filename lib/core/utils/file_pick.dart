import 'package:file_picker/file_picker.dart';

class FilePickerUtil {
  static Future<String?> pickPDF() async {
    final result = await FilePicker.platform
        .pickFiles(type: FileType.custom, allowedExtensions: ['pdf']);
    return result?.files.single.path;
  }
}
