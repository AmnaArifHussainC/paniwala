import 'package:cloud_firestore/cloud_firestore.dart';

class DatabaseService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  // Create or Update User Document
  Future<void> createOrUpdateUserDocument(String userId, String email, String locationName) async {
    try {
      final userDocRef = _firestore.collection('users').doc(userId);

      final userDoc = await userDocRef.get();
      if (!userDoc.exists) {
        // Document doesn't exist; create a new one
        await userDocRef.set({
          'email': email,
          'location': locationName, // Save the location name here
          'createdAt': FieldValue.serverTimestamp(),
          'lastLogin': FieldValue.serverTimestamp(),
        });
      } else {
        // Update the document if it exists
        await userDocRef.update({
          'lastLogin': FieldValue.serverTimestamp(),
          'location': locationName, // Update the location name
        });
      }
    } catch (e) {
      throw Exception('Error creating or updating user document: $e');
    }
  }
}
