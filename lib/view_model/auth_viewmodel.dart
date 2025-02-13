import 'package:flutter/material.dart';
import '../config/services/auth_service.dart';
import '../model/user_model.dart';

class AuthViewModel extends ChangeNotifier {
  final AuthService _authService = AuthService();
  UserModel? _user;
  bool _isLoading = false;

  UserModel? get user => _user; // Expose the user data to the UI
  bool get isLoading => _isLoading; // Expose loading state

  // Login function
  Future<bool> login(String email, String password) async {
    _isLoading = true;
    notifyListeners(); // Notify UI to show loading spinner
    try {
      final firebaseUser = await _authService.loginUser(email, password);
      if (firebaseUser != null) {
        _user = await _authService.getUserData(firebaseUser.uid); // Get user details
        notifyListeners(); // Notify UI of success
        return true;
      }
    } catch (e) {
      print("Login error: $e");
    }

    _isLoading = false;
    notifyListeners(); // Notify UI to stop loading
    return false;
  }



  // Register function
  Future<bool> register(String email, String password, String fullName) async {
    _isLoading = true;
    notifyListeners(); // Notify UI about loading state

    try {
      // Call AuthService's registerUser method
      final firebaseUser = await _authService.registerUser(email, password, fullName);
      if (firebaseUser != null) {
        _user = UserModel(
          uid: firebaseUser.uid,
          name: fullName,
          email: email,
          role: 'customer', // Default role is 'customer'
          createdAt: DateTime.now(),
        );

        _isLoading = false;
        notifyListeners(); // Notify UI of success
        return true;
      }
    } catch (e) {
      print("Register error: $e");
    }

    _isLoading = false;
    notifyListeners(); // Notify UI to stop loading
    return false;
  }
}
