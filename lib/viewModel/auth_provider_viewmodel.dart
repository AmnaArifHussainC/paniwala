import 'package:flutter/material.dart';
import '../../model/user_model.dart';
import '../core/services/auth_service.dart';
import '../model/rider_model.dart';
import '../model/supplier_model.dart';

class AuthViewModel with ChangeNotifier {
  final AuthService _authService = AuthService();
  UserModel? _user;
  SupplierModel? _supplier;
  RiderModel? _rider;
  bool _isLoading = false;

  UserModel? get user => _user;
  SupplierModel? get supplier => _supplier;
  RiderModel? get rider => _rider;
  bool get isLoading => _isLoading;


  void loading(bool val){
    _isLoading = val;
    notifyListeners();
  }

  // User login
  Future<bool> loginUser(String email, String password) async {
    _isLoading = true;
    notifyListeners();
    try {
      _user = await _authService.loginUser(email, password);
      _isLoading = false;
      notifyListeners();
      if(_user== null){
          return false;
      }
      return true;
    } catch (e) {
      _isLoading = false;
      notifyListeners();
      print('Error during login: $e');
      return false;
    }
  }

  // Google Sign in
  Future<bool> signInWithGoogle() async {
    _isLoading = true;
    notifyListeners();

    try {
      final userCredential = await _authService.signInWithGoogle();
      if (userCredential != null) {
        _user = UserModel(
          uid: userCredential.uid,
          name: userCredential.displayName ?? "Google User",
          email: userCredential.email!,
          role: 'customer', // Default role for Google sign-ins
          createdAt: DateTime.now(),
        );
        _isLoading = false;
        notifyListeners();
        return true;
      }
    } catch (e) {
      print("Google Sign-In error: $e");
    }

    _isLoading = false;
    notifyListeners();
    return false;
  }


  // User registration
  Future<bool> registerUser(String name, String email, String password) async {
    _isLoading = true;
    notifyListeners();

    try {
      final newUser = await _authService.registerUser(email, password, name);
      if (newUser != null) {
        _user = UserModel(
          uid: newUser.uid,
          name: name,
          email: email,
          role: 'customer',
          createdAt: DateTime.now(),
        );
      }
      _isLoading = false;
      notifyListeners();
      return true;
    } catch (e) {
      _isLoading = false;
      notifyListeners();
      return false;
    }
  }

  // Logout
  Future<void> logout() async {
    await _authService.signOut();
    _user = null;
    notifyListeners();
  }

  // Reset password
  Future<bool> resetPassword(String email) async {
    _isLoading = true;
    notifyListeners();

    try {
      bool result = await _authService.resetPassword(email);
      _isLoading = false;
      notifyListeners();
      return result;
    } catch (e) {
      _isLoading = false;
      notifyListeners();
      return false;
    }
  }

  Future<void> signOut() async{
    _isLoading = true;
    notifyListeners();
    try{
      await _authService.signOut();
      _user = null;
      _isLoading = false;
      notifyListeners();
    }catch(e){
      _isLoading = false;
      notifyListeners();
      print("Sign Out Error: $e");
    }
  }


//   register supplier
  Future<bool> registerSupplier(
      String email,
      String password,
      String cnic,
      String phone,
      String companyName,
      String? certificateUrl) async {
    _isLoading = true;
    notifyListeners();
    try {
      final String? newSupplierUid = await _authService.registerSupplier(
          email: email,
          password: password,
          cnic: cnic,
          phone: phone,
          companyName: companyName,
          certificateUrl: certificateUrl);

      if (newSupplierUid != null) {
        _supplier = SupplierModel(
          uid: newSupplierUid, // Use newSupplierUid directly
          email: email,
          cnic: cnic,
          phone: phone,
          companyName: companyName,
          certificateUrl: certificateUrl ?? '',
          role: 'supplier',
          createdAt: DateTime.now(),
        );
      }

      _isLoading = false;
      notifyListeners();
      return true;
    } catch (e) {
      _isLoading = false;
      notifyListeners();
      print("Supplier Registration Error: $e");
      return false;
    }
  }

  // login supplier
  Future<bool> loginSupplier(String email, String password) async {
    _isLoading = true;
    notifyListeners();
    try {
      _supplier = await _authService.loginSupplier(email, password);
      _isLoading = false;
      notifyListeners();
      return _supplier != null;
    } catch (e) {
      _isLoading = false;
      notifyListeners();
      print('Supplier Login Error: $e');
      return false;
    }
  }


  Future<bool> registerRider(
      String email,
      String password,
      String cnic,
      String phone,
      String name,
      String? licenseUrl) async {
    _isLoading = true;
    notifyListeners();

    try {
      final String? uid = await _authService.registerRider(
        email: email,
        password: password,
        cnic: cnic,
        phone: phone,
        name: name,
        licenseUrl: licenseUrl,
      );

      if (uid != null) {
        _rider = RiderModel(
          uid: uid,
          email: email,
          cnic: cnic,
          phone: phone,
          name: name,
          licenseUrl: licenseUrl ?? '',
          role: 'rider',
          createdAt: DateTime.now(),
        );

        _isLoading = false;
        notifyListeners();
        return true;
      } else {
        print("Error: UID is null");
        return false;
      }
    } catch (e) {
      print("Rider Registration Error: $e");
      _isLoading = false;
      notifyListeners();
      return false;
    }
  }



// Rider Login
  Future<bool> loginRider(String email, String password) async {
    _isLoading = true;
    notifyListeners();

    try {
      _rider = await _authService.loginRider(email, password);
      _isLoading = false;
      notifyListeners();

      return _rider != null;
    } catch (e) {
      _isLoading = false;
      notifyListeners();
      print("Error during Rider login: $e");
      return false;
    }
  }
}
