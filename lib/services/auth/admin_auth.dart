import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class AdminAuthService {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  /// Admin Sign In
  Future<String?> signIn(String email, String password) async {
    try {
      // Step 1: Sign in with Firebase Auth
      UserCredential userCredential = await _auth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
      User? user = userCredential.user;

      if (user == null) {
        return "Failed to authenticate user.";
      }

      // Step 2: Check if the user exists in the admin collection
      DocumentSnapshot adminDoc =
      await _firestore.collection('admin').doc("admin1").get();
      
      if (!adminDoc.exists) {
        await _auth.signOut(); // Log out if not an admin
        return "You are not authorized as an admin.";
      }

      return null; // Successful login
    } catch (e) {
      return e.toString(); // Return error message
    }
  }

  /// Sign out admin
  Future<void> signOut() async {
    try {
      await _auth.signOut();
    } catch (e) {
      print("Error during sign-out: $e");
    }
  }

  /// Get the current user
  User? getCurrentUser() {
    return _auth.currentUser;
  }
}
