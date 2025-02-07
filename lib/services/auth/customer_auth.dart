import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';

class AuthService {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final GoogleSignIn _googleSignIn = GoogleSignIn();

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

  // Sign in with Google
  Future<String?> googleLogin() async {
    try {
      // Trigger the Google Authentication flow
      final GoogleSignInAccount? googleUser = await _googleSignIn.signIn();

      if (googleUser == null) {
        return "User canceled the sign-in";  // Return if user cancels the sign-in
      }

      // Obtain the auth details from the request
      final GoogleSignInAuthentication googleAuth = await googleUser.authentication;

      // Create a new credential
      final OAuthCredential credential = GoogleAuthProvider.credential(
        accessToken: googleAuth.accessToken,
        idToken: googleAuth.idToken,
      );

      // Sign in to Firebase with the Google credentials
      await _auth.signInWithCredential(credential);
      return null;  // Return null if successful
    } catch (e) {
      return e.toString();  // Return error if any
    }
  }
}
