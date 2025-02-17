import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LocationUtils {
  static const String _addressKey = "supplier_address";

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

      // Save address in Firestore & locally
      await updateSupplierAddress(address);
      await saveAddressToLocal(address);

      return address;
    } catch (e) {
      return "Error getting location: $e";
    }
  }

  // Update Supplier Address in Firestore
  static Future<void> updateSupplierAddress(String address) async {
    User? user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      await FirebaseFirestore.instance
          .collection('suppliers')
          .doc(user.uid)
          .set({"address": address}, SetOptions(merge: true));
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
