import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class RiderAuthService {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  // Register a new rider
  Future<String?> registerRider({
    required String name,
    required String email,
    required String password,
    required String phone,
    required String deliveryArea,
    required String commission,
  }) async {
    try {
      // Create a new user in Firebase Auth
      UserCredential userCredential = await _auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );

      // Save rider details to Firestore
      await _firestore.collection('riders').doc(userCredential.user?.uid).set({
        'name': name,
        'email': email,
        'phone': phone,
        'deliveryArea': deliveryArea,
        'commission': commission,
        'createdAt': DateTime.now(),
      });

      return "Rider registered successfully";
    } on FirebaseAuthException catch (e) {
      return e.message; // Return error message if any
    } catch (e) {
      return "An error occurred: $e";
    }
  }

  // Sign in rider
  Future<String?> signInRider({required String email, required String password}) async {
    try {
      await _auth.signInWithEmailAndPassword(email: email, password: password);
      return "Rider signed in successfully";
    } on FirebaseAuthException catch (e) {
      return e.message; // Return error message if any
    }
  }

  // Sign out rider
  Future<void> signOut() async {
    await _auth.signOut();
  }

  // Get current rider's UID
  String? getCurrentRiderUID() {
    return _auth.currentUser?.uid;
  }

  // Check if a rider is logged in
  bool isRiderLoggedIn() {
    return _auth.currentUser != null;
  }

  // Reset rider's password
  Future<String?> resetPassword(String email) async {
    try {
      await _auth.sendPasswordResetEmail(email: email);
      return "Password reset email sent";
    } on FirebaseAuthException catch (e) {
      return e.message; // Return error message if any
    }
  }
}
