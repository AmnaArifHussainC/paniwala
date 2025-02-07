import 'package:cloud_firestore/cloud_firestore.dart';

class DatabaseService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  // Create or Update User Document
  Future<void> createOrUpdateUserDocument(String userId, String email) async {
    try {
      final userDocRef = _firestore.collection('users').doc(userId);

      final userDoc = await userDocRef.get();
      if (!userDoc.exists) {
        // Document doesn't exist; create a new one
        await userDocRef.set({
          'email': email,
          'createdAt': FieldValue.serverTimestamp(),
          'lastLogin': FieldValue.serverTimestamp(),
        });
      } else {
        // Update the last login timestamp if the document exists
        await userDocRef.update({
          'lastLogin': FieldValue.serverTimestamp(),
        });
      }
    } catch (e) {
      throw Exception('Error creating or updating user document: $e');
    }
  }
}
