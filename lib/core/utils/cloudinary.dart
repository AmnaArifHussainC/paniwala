import 'dart:convert';
import 'package:http/http.dart' as http;

class CloudinaryService{
  Future<String?> uploadToCloudinary(String filePath) async {
    const cloudinaryCloudName = 'dhirdggtq';
    const uploadPreset = 'paniwala_certificates';
    final url = Uri.parse('https://api.cloudinary.com/v1_1/$cloudinaryCloudName/auto/upload');

    try {
      final request = http.MultipartRequest('POST', url)   //send both text data (form fields) and a file.
        ..fields['upload_preset'] = uploadPreset
        ..files.add(await http.MultipartFile.fromPath('file', filePath));

      final response = await request.send();

      if (response.statusCode == 200) {
        final responseData = await http.Response.fromStream(response);
        final responseBody = jsonDecode(responseData.body);
        return responseBody['secure_url'];
      } else {
        print('Failed to upload file: ${response.statusCode}');
        return null;
      }
    } catch (e) {
      print('Error uploading file: $e');
      return null;
    }
  }
}
