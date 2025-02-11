import 'dart:io';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';

class SupplierAuthService {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseStorage _storage = FirebaseStorage.instance;

  /// Sign up a new supplier with email and password
  Future<String?> registerSupplier({
    required String email,
    required String password,
    required String cnic,
    required String phone,
    required String companyName,
    // String? filterCertificatePath, // Path of the uploaded PDF
  }) async {
    try {
      // Step 1: Create the user in Firebase Auth
      UserCredential userCredential = await _auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );
      User? user = userCredential.user;

      if (user == null) {
        return "User creation failed.";
      }

      // Step 2: Upload Water Filter Certificate (if provided)
      // String? certificateUrl;
      // if (filterCertificatePath != null) {
      //   File certificateFile = File(filterCertificatePath);
      //   final ref = _storage
      //       .ref()
      //       .child('suppliers/${user.uid}/certificate.pdf');
      //   final uploadTask = await ref.putFile(certificateFile);
      //   certificateUrl = await uploadTask.ref.getDownloadURL();
      // }

      // Step 3: Save supplier details in Firestore
      await _firestore.collection('suppliers').doc(user.uid).set({
        'email': email,
        'cnic': cnic,
        'phone': phone,
        'companyName': companyName,
        // 'certificateUrl': certificateUrl,
        'createdAt': FieldValue.serverTimestamp(),
      });

      return null; // Return null if successful
    } catch (e) {
      return e.toString(); // Return error if any
    }
  }

  /// Sign in with email and password
  Future<String?> signIn(String email, String password) async {
    try {
      await _auth.signInWithEmailAndPassword(email: email, password: password);
      return null; // Return null if successful
    } catch (e) {
      return e.toString(); // Return error if any
    }
  }

  /// Sign out
  Future<void> signOut() async {
    try {
      await _auth.signOut();
    } catch (e) {
      print("Error during sign-out: $e");
    }
  }

  /// Get current user
  User? getCurrentUser() {
    return _auth.currentUser;
  }
}
