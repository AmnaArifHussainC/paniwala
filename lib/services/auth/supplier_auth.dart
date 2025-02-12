import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class SupplierAuthService {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  /// Register a new supplier
  Future<String?> registerSupplier({
    required String email,
    required String password,
    required String cnic,
    required String phone,
    required String companyName,
  }) async {
    try {
      // Create the user in Firebase Authentication
      UserCredential userCredential = await _auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );
      User? user = userCredential.user;

      if (user == null) {
        return "User creation failed.";
      }

      // Save supplier details in Firestore
      await _firestore.collection('suppliers').doc(user.uid).set({
        'email': email,
        'cnic': cnic,
        'phone': phone,
        'companyName': companyName,
        'createdAt': FieldValue.serverTimestamp(),
        'verified': false,
        'blocked': false,
      });

      // Add request to the admin's `request` subcollection
      await _firestore
          .collection('admin')
          .doc('admin1') // Replace with your admin document ID
          .collection('request')
          .doc(user.uid)
          .set({
        'supplierId': user.uid,
        'email': email,
        'cnic': cnic,
        'phone': phone,
        'companyName': companyName,
        'status': "Pending", // Default status is "Pending"
      });

      return null; // Success
    } catch (e) {
      return e.toString();
    }
  }

  /// Sign in a supplier
  Future<String?> signIn(String email, String password) async {
    try {
      // Step 1: Sign in user via Firebase Auth
      UserCredential userCredential = await _auth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
      User? user = userCredential.user;

      if (user == null) {
        return "User not found.";
      }

      // Step 2: Fetch user details from Firestore
      DocumentSnapshot supplierDoc =
      await _firestore.collection('suppliers').doc(user.uid).get();

      if (!supplierDoc.exists) {
        await _auth.signOut(); // Sign out if user doesn't exist in Firestore
        return "Your account is not found. Please register first.";
      }

      final data = supplierDoc.data() as Map<String, dynamic>;
      bool isVerified = data['verified'] ?? false;

      // Step 3: Check verification status
      if (!isVerified) {
        await _auth.signOut(); // Sign out if not verified
        return "Your account is pending approval. Please wait for admin approval.";
      }

      return null; // Success
    } catch (e) {
      return e.toString(); // Return error message
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

  /// Get the current user
  User? getCurrentUser() {
    return _auth.currentUser;
  }
}
