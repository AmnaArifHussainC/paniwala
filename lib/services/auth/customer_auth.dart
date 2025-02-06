import 'package:firebase_auth/firebase_auth.dart';

class AuthService {
  final FirebaseAuth _auth = FirebaseAuth.instance;

  // Sign up with email and password
  Future<String?> signUp(String email, String password) async {
    try {
      await _auth.createUserWithEmailAndPassword(email: email, password: password);
      return null;  // Return null if successful
    } catch (e) {
      return e.toString();  // Return error if any
    }
  }

  // Sign in with email and password
  Future<String?> signIn(String email, String password) async {
    try {
      await _auth.signInWithEmailAndPassword(email: email, password: password);
      return null;  // Return null if successful
    } catch (e) {
      return e.toString();  // Return error if any
    }
  }

  // Sign out
  Future<void> signOut() async {
    await _auth.signOut();
  }

  // Get current user
  User? getCurrentUser() {
    return _auth.currentUser;
  }
}
