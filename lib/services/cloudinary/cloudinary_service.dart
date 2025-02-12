import 'dart:io';
import 'package:dio/dio.dart';

class CloudinaryService {
  final String cloudName = "paniwala";
  final String apiKey = "442373146432278";
  final String apiSecret = "32j8WUPQ7T4ICbPAH05wZL7OciI";

  Future<String?> uploadFile(File file) async {
    try {
      String uploadUrl = "https://api.cloudinary.com/v1_1/$cloudName/upload";

      FormData formData = FormData.fromMap({
        "file": await MultipartFile.fromFile(file.path),
        "upload_preset": "your_upload_preset",
        "api_key": apiKey,
      });

      var response = await Dio().post(uploadUrl, data: formData);

      if (response.statusCode == 200) {
        return response.data["secure_url"]; // URL to store in Firestore
      }
    } catch (e) {
      print("Cloudinary Upload Error: $e");
    }
    return null;
  }
}
