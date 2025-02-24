import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../model/rider_model.dart';
import '../../model/supplier_model.dart';
import '../../model/user_model.dart';

class LocationService {
  static const String _addressKey = "user_address";

  // Expose _addressKey via a getter
  static String get addressKey => _addressKey;


  // Check if location permission is granted
  static Future<bool> hasPermission() async {
    LocationPermission permission = await Geolocator.checkPermission();
    return permission == LocationPermission.always || permission == LocationPermission.whileInUse;
  }

// Request location permission
  static Future<bool> requestPermission() async {
    LocationPermission permission = await Geolocator.requestPermission();
    return permission == LocationPermission.always || permission == LocationPermission.whileInUse;
  }


  // Get Current Location & Address
  static Future<String?> getCurrentLocation() async {
    try {
      // Request location permission
      LocationPermission permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        return "Location permission denied";
      } else if (permission == LocationPermission.deniedForever) {
        return "Location permission permanently denied. Enable it in settings.";
      }

      // Get current position
      Position position = await Geolocator.getCurrentPosition(
          desiredAccuracy: LocationAccuracy.high);

      // Reverse geocode to get address
      List<Placemark> placemarks =
      await placemarkFromCoordinates(position.latitude, position.longitude);
      if (placemarks.isEmpty) return "Address not found";

      Placemark place = placemarks.first;
      String address =
      "${place.street ?? ''}, ${place.subLocality ?? ''}, ${place.locality ?? ''}, ${place.country ?? ''}".trim();

      // Save address based on role
      await saveAddressBasedOnRole(address);
      await saveAddressToLocal(address);

      return address;
    } catch (e) {
      return "Error getting location: $e";
    }
  }

  // Save address to Firestore based on user role
  static Future<void> saveAddressBasedOnRole(String address) async {
    User? user = FirebaseAuth.instance.currentUser;
    if (user == null) return;

    final String uid = user.uid;
    final _firestore = FirebaseFirestore.instance;

    // Check user's role and update the address in the corresponding collection
    dynamic userData = await getUserByUID(uid, _firestore);
    if (userData != null) {
      if (userData is UserModel) {
        print("Updating address for User.");
        await _firestore.collection('Users').doc(uid).set(
          {"address": address},
          SetOptions(merge: true),
        );
      } else if (userData is SupplierModel) {
        print("Updating address for Supplier.");
        await _firestore.collection('suppliers').doc(uid).set(
          {"address": address},
          SetOptions(merge: true),
        );
      } else if (userData is RiderModel) {
        print("Updating address for Rider.");
        await _firestore.collection('riders').doc(uid).set(
          {"address": address},
          SetOptions(merge: true),
        );
      }
    } else {
      print("User role not found.");
    }
  }

  // General method to fetch user data by UID
  static Future<dynamic> getUserByUID(String uid, FirebaseFirestore firestore) async {
    try {
      // Check in "Users" collection
      DocumentSnapshot userDoc = await firestore.collection('Users').doc(uid).get();
      if (userDoc.exists) {
        print("User found in Users collection.");
        return UserModel.fromFirestore(userDoc.data() as Map<String, dynamic>, uid);
      }

      // Check in "Suppliers" collection
      DocumentSnapshot supplierDoc = await firestore.collection('suppliers').doc(uid).get();
      if (supplierDoc.exists) {
        print("User found in Suppliers collection.");
        return SupplierModel.fromFirestore(supplierDoc.data() as Map<String, dynamic>, uid);
      }

      // Check in "Riders" collection
      DocumentSnapshot riderDoc = await firestore.collection('riders').doc(uid).get();
      if (riderDoc.exists) {
        print("User found in Riders collection.");
        return RiderModel.fromFirestore(riderDoc.data() as Map<String, dynamic>, uid);
      }

      print("User not found in any collection.");
      return null;
    } catch (e) {
      print("Error fetching user data: $e");
      return null;
    }
  }

  // Get saved address from local storage
  static Future<String?> getSavedAddress() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getString(_addressKey);
  }

  // Save address to local storage
  static Future<void> saveAddressToLocal(String address) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setString(_addressKey, address);
  }
}
