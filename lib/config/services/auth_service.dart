import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:google_sign_in/google_sign_in.dart';
import '../../model/user_model.dart';
import '../../model/supplier_model.dart';

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

  // User Registration
  Future<User?> registerUser(String email, String password, String name) async {
    try {
      UserCredential userCredential =
      await _auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );
      // Save user data in Firestore
      UserModel user = UserModel(
        uid: userCredential.user!.uid,
        name: name,
        email: email,
        role: 'customer',
        createdAt: DateTime.now(),
      );
      await _firestore.collection('Users').doc(user.uid).set(user.toFirestore());
      return userCredential.user;
    } catch (e) {
      print("Register Error: $e");
      return null;
    }
  }

  // Google Sign-In
  Future<User?> signInWithGoogle() async {
    try {
      final GoogleSignInAccount? googleUser = await _googleSignIn.signIn();
      if (googleUser == null) return null;

      final GoogleSignInAuthentication googleAuth =
      await googleUser.authentication;
      final AuthCredential credential = GoogleAuthProvider.credential(
        accessToken: googleAuth.accessToken,
        idToken: googleAuth.idToken,
      );
      UserCredential userCredential =
      await _auth.signInWithCredential(credential);

      if (userCredential.additionalUserInfo!.isNewUser) {
        UserModel newUser = UserModel(
          uid: userCredential.user!.uid,
          name: googleUser.displayName ?? 'Unknown',
          email: googleUser.email,
          role: 'customer',
          createdAt: DateTime.now(),
        );
        await _firestore.collection('Users').doc(newUser.uid).set(newUser.toFirestore());
      }
      return userCredential.user;
    } catch (e) {
      print("Google Sign-In Error: $e");
      return null;
    }
  }

  // Supplier Registration
  Future<bool> registerSupplier({
    required String email,
    required String password,
    required String cnic,
    required String phone,
    required String companyName,
    required String? certificateUrl,
  }) async {
    try {
      UserCredential userCredential =
      await _auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );
      String uid = userCredential.user!.uid;

      await _firestore.collection('suppliers').doc(uid).set({
        'uid': uid,
        'email': email,
        'cnic': cnic,
        'phone': phone,
        'company_name': companyName,
        'certificateUrl': certificateUrl ?? '',
        'role': 'supplier',
        'createdAt': FieldValue.serverTimestamp(),
      });

      return true;
    } catch (e) {
      print("Supplier Registration Error: $e");
      return false;
    }
  }

  // Upload to Cloudinary
  Future<String?> uploadToCloudinary(String filePath) async {
    const cloudinaryUrl = 'https://api.cloudinary.com/v1_1/dhirdggtq/upload';
    const uploadPreset = 'paniwala_certificates';

    try {
      final file = File(filePath);
      final request = http.MultipartRequest('POST', Uri.parse(cloudinaryUrl))
        ..fields['upload_preset'] = uploadPreset
        ..files.add(await http.MultipartFile.fromPath('file', file.path));

      final response = await request.send();
      final responseBody = await response.stream.bytesToString();

      if (response.statusCode == 200) {
        final jsonResponse = json.decode(responseBody);
        return jsonResponse['secure_url'];
      } else {
        print("Cloudinary Upload Error: ${response.statusCode}");
        return null;
      }
    } catch (e) {
      print("Cloudinary Upload Error: $e");
      return null;
    }
  }

  // Forgot Password
  Future<bool> resetPassword(String email) async {
    try {
      await _auth.sendPasswordResetEmail(email: email);
      return true;
    } catch (e) {
      print("Forgot Password Error: $e");
      return false;
    }
  }

  // Sign Out
  Future<void> signOut() async {
    try {
      await _googleSignIn.signOut();
      await _auth.signOut();
    } catch (e) {
      print("Sign Out Error: $e");
    }
  }



  // Fetch user data by UID
  Future<UserModel?> getUserData(String uid) async {
    try {
      DocumentSnapshot userDoc = await _firestore.collection('Users').doc(uid).get();

      if (userDoc.exists) {
        return UserModel.fromFirestore(userDoc.data() as Map<String, dynamic>, userDoc.id);
      } else {
        print("User not found in Firestore.");
        return null;
      }
    } catch (e) {
      print("Error fetching user data: $e");
      return null;
    }
  }




  // Supplier Login
  Future<SupplierModel?> loginSupplier(String email, String password) async {
    try {
      UserCredential userCredential = await _auth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
      User? firebaseUser = userCredential.user;

      if (firebaseUser != null) {
        // Fetch supplier details from Firestore
        DocumentSnapshot supplierDoc = await _firestore.collection('suppliers').doc(firebaseUser.uid).get();
        if (supplierDoc.exists) {
          return SupplierModel.fromFirestore(supplierDoc.data() as Map<String, dynamic>, supplierDoc.id);
        }
      }
      return null;
    } catch (e) {
      print("Supplier Login Error: $e");
      return null;
    }
  }


}
