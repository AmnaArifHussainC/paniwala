import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:google_sign_in/google_sign_in.dart';

import '../../model/supplier_model.dart';
import '../../model/user_model.dart';

class AuthService {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final GoogleSignIn _googleSignIn = GoogleSignIn();



  // User Login Function
  Future<User?> loginUser(String email, String password) async {
    try {
      UserCredential userCredential = await _auth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
      return userCredential.user;
    } catch (e) {
      print("Login Error: $e");
      return null;
    }
  }




  // Sign Out Function
  Future<void> signOut() async {
    try {
      await _googleSignIn.signOut(); // Sign out from Google if signed in
      await _auth.signOut(); // Sign out from Firebase
      print("User signed out successfully.");
    } catch (e) {
      print("Sign Out Error: $e");
    }
  }





  // Google Login
  Future<User?> signInWithGoogle() async {
    try {
      final GoogleSignInAccount? googleUser = await _googleSignIn.signIn();
      if (googleUser == null) {
        return null;
      }
      final GoogleSignInAuthentication googleAuth =
      await googleUser.authentication;

      final AuthCredential credential = GoogleAuthProvider.credential(
        accessToken: googleAuth.accessToken,
        idToken: googleAuth.idToken,
      );
      final UserCredential userCredential =
      await _auth.signInWithCredential(credential);
      final User? user = userCredential.user;

      if (userCredential.additionalUserInfo!.isNewUser) {
        // Create a UserModel instance for the new user
        UserModel newUser = UserModel(
          uid: user!.uid,
          name: user.displayName ?? 'Unknown',
          email: user.email ?? '',
          // profilePicture: user.photoURL,
          role: 'customer', // Default role
          createdAt: DateTime.now(),
        );

        // Save the user data to Firestore
        await _firestore
            .collection('Users')
            .doc(newUser.uid)
            .set(newUser.toFirestore());
      }
      return user;
    } catch (e) {
      print("Google Sign-In Error: $e");
      return null;
    }
  }





  // User Register Function
  Future<User?> registerUser(String email, String password, String name) async {
    try {
      UserCredential userCredential =
      await _auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );
      // Create a UserModel instance
      UserModel user = UserModel(
        uid: userCredential.user!.uid,
        name: name,
        email: email,
        role: 'customer', // Default role is 'customer'
        createdAt: DateTime.now(),
      );
      // Save user details to Firestore using the model
      await _firestore.collection('Users').doc(user.uid).set(user.toFirestore());

      return userCredential.user;
    } catch (e) {
      print("Register Error: $e");
      return null;
    }
  }




  // Forgot Password Function
  Future<bool> resetPassword(String email) async {
    try {
      await _auth.sendPasswordResetEmail(email: email);
      print("Password reset email sent to $email");
      return true; // Indicate success
    } catch (e) {
      print("Forgot Password Error: $e");
      return false; // Indicate failure
    }
  }




  // Get User Data
  Future<UserModel?> getUserData(String uid) async {
    try {
      DocumentSnapshot doc = await _firestore.collection('Users').doc(uid).get();
      if (doc.exists) {
        return UserModel.fromFirestore(doc.data() as Map<String, dynamic>, doc.id);
      }
    } catch (e) {
      print("Error fetching user data: $e");
    }
    return null;
  }




  // Supplier Register Function
  Future<User?> registerSupplier(String email, String password, String name, String cnic, String companyName) async {
    try {
      // Register the supplier in Firebase Auth
      UserCredential userCredential =
      await _auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );
      // Create a SupplierModel instance
      SupplierModel supplier = SupplierModel(
        uid: userCredential.user!.uid,
        email: email,
        cnic: cnic,
        companyName: companyName,
        role: 'Supplier', // Default role for suppliers
        createdAt: DateTime.now(),
      );

      // Save supplier details to Firestore using the model
      await _firestore
          .collection('Suppliers')
          .doc(supplier.uid)
          .set(supplier.toFirestore());
      print("Supplier registered successfully.");
      return userCredential.user;
    } catch (e) {
      print("Register Supplier Error: $e");
      return null;
    }
  }

}
