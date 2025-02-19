import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:google_sign_in/google_sign_in.dart';
import '../../model/rider_model.dart';
import '../../model/user_model.dart';
import '../../model/supplier_model.dart';

class AuthService {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final GoogleSignIn _googleSignIn = GoogleSignIn();

  // User Login Function
  Future<UserModel?> loginUser(String email, String password) async {
    try {
      UserCredential userCredential = await _auth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
      User? firebaseUser = userCredential.user;

      if (firebaseUser != null) {
        DocumentSnapshot userDoc =
        await _firestore.collection('Users').doc(firebaseUser.uid).get();

        if (!userDoc.exists) {
          print("Error: No user record found.");
          return null;
        }

        final data = userDoc.data() as Map<String, dynamic>;

        // Debugging output
        print("User Data from Firestore: $data");

        if (data['role'].toString().toLowerCase().trim() != 'customer') {
          print("Error: User role is not 'customer'. Found: ${data['role']}");
          return null;
        }


        return UserModel.fromFirestore(data, userDoc.id);
      }
      return null;
    } catch (e) {
      print("User Login Error: $e");
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





  Future<SupplierModel?> loginSupplier(String email, String password) async {
    try {
      // Authenticate user
      UserCredential userCredential = await _auth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
      User? firebaseUser = userCredential.user;

      if (firebaseUser != null) {
        // Fetch supplier details from the Firestore 'suppliers' collection
        DocumentSnapshot supplierDoc =
        await _firestore.collection('suppliers').doc(firebaseUser.uid).get();

        if (!supplierDoc.exists) {
          // User is not a supplier
          print("Error: No supplier record found for this user.");
          return null; // Prevent access to the supplier dashboard
        }

        // Check the role to ensure it's 'supplier'
        final data = supplierDoc.data() as Map<String, dynamic>;
        if (data['role'] != 'supplier') {
          print("Error: User role is not 'supplier'.");
          return null; // Stop further processing
        }

        // Role matches, return SupplierModel
        return SupplierModel.fromFirestore(data, supplierDoc.id);
      }

      return null;
    } catch (e) {
      print("Supplier Login Error: $e");
      return null;
    }
  }


  // Rider Registration
  Future<bool> registerRider({
    required String email,
    required String password,
    required String cnic,
    required String phone,
    required String name,
    required String? licenseUrl, // Optional field for the rider's license document
  }) async {
    try {
      // Create a new user in Firebase Authentication
      UserCredential userCredential = await _auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );
      String uid = userCredential.user!.uid;

      // Create a RiderModel instance
      RiderModel rider = RiderModel(
        uid: uid,
        email: email,
        cnic: cnic,
        phone: phone,
        name: name,
        licenseUrl: licenseUrl,
        role: 'rider',
        createdAt: DateTime.now(),
      );

      // Save rider data in Firestore under the 'riders' collection
      await _firestore.collection('riders').doc(uid).set(rider.toFirestore());

      return true; // Successfully registered rider
    } catch (e) {
      print("Rider Registration Error: $e");
      return false; // Registration failed
    }
  }


  Future<RiderModel?> loginRider(String email, String password) async {
    try {
      // Authenticate the user
      UserCredential userCredential = await _auth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
      User? firebaseUser = userCredential.user;

      if (firebaseUser != null) {
        print("Checking Firestore for rider UID: ${firebaseUser.uid}");

        DocumentSnapshot riderDoc =
        await _firestore.collection('riders').doc(firebaseUser.uid).get();

        if (!riderDoc.exists) {
          print("Error: No rider record found for this user.");
          return null;
        }

        final data = riderDoc.data() as Map<String, dynamic>;

        if (!data.containsKey('role') || data['role'] != 'rider') {
          print("Error: Role is missing or incorrect.");
          return null;
        }

        print("Rider login successful: ${data}");
        return RiderModel.fromFirestore(data, riderDoc.id);
      }

      return null;
    } catch (e) {
      print("Rider Login Error: $e");
      return null;
    }
  }


}
