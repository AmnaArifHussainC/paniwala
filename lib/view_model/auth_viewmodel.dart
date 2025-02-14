import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import '../config/services/auth_service.dart';
import '../model/user_model.dart';
import '../model/supplier_model.dart';

class AuthViewModel extends ChangeNotifier {
  final AuthService _authService = AuthService();
  UserModel? _user;
  SupplierModel? _supplier;
  bool _isLoading = false;

  UserModel? get user => _user;

  SupplierModel? get supplier => _supplier;

  bool get isLoading => _isLoading;

  // User Login
  Future<bool> login(String email, String password) async {
    _isLoading = true;
    notifyListeners();
    try {
      final firebaseUser = await _authService.loginUser(email, password);
      if (firebaseUser != null) {
        _user = await _authService.getUserData(firebaseUser.uid);
        notifyListeners();
        return true;
      }
    } catch (e) {
      print("Login Error: $e");
    }
    _isLoading = false;
    notifyListeners();
    return false;
  }

  // Register User
  Future<bool> registerUser(String fullName, String email,
      String password) async {
    _isLoading = true;
    notifyListeners();
    try {
      final firebaseUser = await _authService.registerUser(
          email, password, fullName);
      if (firebaseUser != null) {
        _user = UserModel(
          uid: firebaseUser.uid,
          name: fullName,
          email: email,
          role: 'customer',
          createdAt: DateTime.now(),
        );
        notifyListeners();
        return true;
      }
    } catch (e) {
      print("Register Error: $e");
    }
    _isLoading = false;
    notifyListeners();
    return false;
  }

  // Google Sign-In
  Future<bool> signInWithGoogle() async {
    _isLoading = true;
    notifyListeners();
    try {
      final firebaseUser = await _authService.signInWithGoogle();
      if (firebaseUser != null) {
        _user = await _authService.getUserData(firebaseUser.uid);
        notifyListeners();
        return true;
      }
    } catch (e) {
      print("Google Sign-In Error: $e");
    }
    _isLoading = false;
    notifyListeners();
    return false;
  }

  // Register Supplier
  Future<bool> registerSupplier({
    required String email,
    required String password,
    required String cnic,
    required String phone,
    required String companyName,
    required String certificateUrl,
  }) async {
    _isLoading = true;
    notifyListeners();
    try {
      final success = await _authService.registerSupplier(
        email: email,
        password: password,
        cnic: cnic,
        phone: phone,
        companyName: companyName,
        certificateUrl: certificateUrl,
      );
      _isLoading = false;
      notifyListeners();
      return success;
    } catch (e) {
      print("Supplier Registration Error: $e");
      _isLoading = false;
      notifyListeners();
      return false;
    }
  }



  Future<String?> uploadToCloudinary(String filePath) async {
    final cloudinaryCloudName = 'dhirdggtq';
    final uploadPreset = 'paniwala_certificates';
    final url = Uri.parse('https://api.cloudinary.com/v1_1/$cloudinaryCloudName/auto/upload');

    try {
      final request = http.MultipartRequest('POST', url)
        ..fields['upload_preset'] = uploadPreset
        ..files.add(await http.MultipartFile.fromPath('file', filePath));

      final response = await request.send();

      if (response.statusCode == 200) {
        final responseData = await http.Response.fromStream(response);
        final responseBody = jsonDecode(responseData.body);

        // Store the public URL
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