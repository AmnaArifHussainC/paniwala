import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LocationUtils {
  static Future<String?> getCurrentLocation() async {
    try {
      // Request permission
      LocationPermission permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        return "Location permission denied";
      }

      // Get current position
      Position position = await Geolocator.getCurrentPosition(
          desiredAccuracy: LocationAccuracy.high);

      // Reverse geocode to get address
      List<Placemark> placemarks =
      await placemarkFromCoordinates(position.latitude, position.longitude);
      Placemark place = placemarks.first;

      String address =
          "${place.street}, ${place.subLocality}, ${place.locality}, ${place.country}";

      // Store address in Firestore
      await updateSupplierAddress(address);

      return address;
    } catch (e) {
      return "Error getting location: $e";
    }
  }

  static Future<void> updateSupplierAddress(String address) async {
    User? user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      await FirebaseFirestore.instance
          .collection('suppliers')
          .doc(user.uid)
          .update({"address": address});
    }
  }

  static const String _addressKey = "supplier_address";

  // Get saved address from local storage
  static Future<String?> getSavedAddress() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getString(_addressKey);
  }

  // Save or update supplier address in local storage
  static Future<void> saveAddressToLocal(String address) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setString(_addressKey, address);
  }
}
