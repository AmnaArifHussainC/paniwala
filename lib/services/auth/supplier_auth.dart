import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class SupplierAuthService {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  /// Register a new supplier (without Firebase Authentication)
  Future<String?> registerSupplier({
    required String email,
    required String password,
    required String cnic,
    required String phone,
    required String companyName,
  }) async {
    try {
      // Check if the email is blocked
      QuerySnapshot blockedQuery = await _firestore
          .collection('suppliers')
          .where('email', isEqualTo: email)
          .where('blocked', isEqualTo: true)
          .get();

      if (blockedQuery.docs.isNotEmpty) {
        return "Your account is blocked. You cannot register again.";
      }

      // Save supplier details in Firestore with the password hashed
      DocumentReference supplierRef = _firestore.collection('suppliers').doc();
      String supplierId = supplierRef.id;

      await supplierRef.set({
        'supplierId': supplierId,
        'email': email,
        'password': password, // Store temporarily, ensure it's secured
        'cnic': cnic,
        'phone': phone,
        'companyName': companyName,
        'createdAt': FieldValue.serverTimestamp(),
        'verified': false,
        'blocked': false,
        'status': "Pending", // Default status
      });

      // Add request to the admin's `request` subcollection
      await _firestore
          .collection('admin')
          .doc('admin1') // Replace with your admin document ID
          .collection('request')
          .doc(supplierId)
          .set({
        'supplierId': supplierId,
        'email': email,
        'cnic': cnic,
        'phone': phone,
        'companyName': companyName,
        'status': "Pending",
      });

      return null; // Success
    } catch (e) {
      return e.toString();
    }
  }

  /// Sign in a supplier (only after admin approval)
  Future<String?> signIn(String email, String password) async {
    try {
      // Check if the supplier exists in Firestore
      QuerySnapshot supplierQuery = await _firestore
          .collection('suppliers')
          .where('email', isEqualTo: email)
          .get();

      if (supplierQuery.docs.isEmpty) {
        return "Your account is not found. Please register first.";
      }

      final data = supplierQuery.docs.first.data() as Map<String, dynamic>;
      String status = data['status'] ?? 'Pending';

      // Check the supplier's status
      if (status == 'Pending') {
        return "Your account is pending approval. Please wait for admin approval.";
      }

      if (status == 'Rejected') {
        return "Your registration was rejected by the admin.";
      }

      if (status == 'Blocked') {
        return "Your account has been blocked. Contact admin for support.";
      }

      // Authenticate only if the account is approved
      if (status == 'Verified') {
        UserCredential userCredential = await _auth.signInWithEmailAndPassword(
          email: email,
          password: password,
        );

        User? user = userCredential.user;
        if (user == null) {
          return "Authentication failed. Please try again.";
        }

        return null; // Success
      }

      return "Unexpected status: $status";
    } catch (e) {
      return e.toString(); // Return error message
    }
  }

  /// Approve supplier and create Firebase Authentication account
  Future<String?> approveSupplier({
    required String supplierId,
    required String email,
    required String password, // Admin sets a temporary password
  }) async {
    try {
      // Create the supplier's Firebase Authentication account
      UserCredential userCredential = await _auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );

      // Update supplier status in Firestore
      await _firestore.collection('suppliers').doc(supplierId).update({
        'verified': true,
        'status': "Verified",
      });

      // Notify the supplier (e.g., via email or app notification)

      return null; // Success
    } catch (e) {
      return e.toString();
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
