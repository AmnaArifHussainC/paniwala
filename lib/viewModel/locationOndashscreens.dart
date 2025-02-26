import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:geolocator/geolocator.dart';
import 'package:geocoding/geocoding.dart';
import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';

class LocationViewModel extends ChangeNotifier {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  String? _userLocation;
  bool _isLoading = false;
  bool _hasCheckedLocation = false;

  String? get userLocation => _userLocation;
  bool get isLoading => _isLoading;

  Future<void> requestLocationPermission(BuildContext context) async {
    if (_hasCheckedLocation) return; // Ensure it runs only once
    _hasCheckedLocation = true;

    LocationPermission permission = await Geolocator.checkPermission();

    if (permission == LocationPermission.denied || permission == LocationPermission.deniedForever) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        _showPermissionDialog(context);
        return;
      } else if (permission == LocationPermission.deniedForever) {
        _showPermissionDialog(context, forceLogout: true);
        return;
      }
    }

    await saveUserLocation();
  }

  Future<void> saveUserLocation() async {
    _isLoading = true;
    notifyListeners();

    try {
      User? user = _auth.currentUser;
      if (user != null) {
        String? role = await _getUserRole(user.uid);
        if (role != null) {
          DocumentSnapshot userDoc = await _firestore.collection(role).doc(user.uid).get();
          if (!userDoc.exists || userDoc['location'] == null) { // Only save if location is not already stored
            Position position = await Geolocator.getCurrentPosition(desiredAccuracy: LocationAccuracy.high);
            List<Placemark> placemarks = await placemarkFromCoordinates(position.latitude, position.longitude);
            String address = "${placemarks.first.street}, ${placemarks.first.locality}, ${placemarks.first.country}";

            await _firestore.collection(role).doc(user.uid).set({
              'location': address,
            }, SetOptions(merge: true));

            _userLocation = address;
          }
        }
      }
    } catch (e) {
      print("Error saving location: $e");
    }

    _isLoading = false;
    notifyListeners();
  }

  Future<void> fetchUserLocation() async {
    _isLoading = true;
    notifyListeners();

    User? user = _auth.currentUser;
    if (user != null) {
      String? role = await _getUserRole(user.uid);
      if (role != null) {
        DocumentSnapshot doc = await _firestore.collection(role).doc(user.uid).get();
        _userLocation = doc.exists ? doc['location'] as String? : null;
      }
    }

    _isLoading = false;
    notifyListeners();
  }

  Future<String?> _getUserRole(String uid) async {
    List<String> collections = ['Users', 'suppliers', 'riders'];
    for (String collection in collections) {
      DocumentSnapshot doc = await _firestore.collection(collection).doc(uid).get();
      if (doc.exists) {
        return collection;
      }
    }
    return null;
  }

  void _showPermissionDialog(BuildContext context, {bool forceLogout = false}) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => AlertDialog(
        title: Text("Location Permission Required"),
        content: Text("We need your location to proceed. Please enable location access."),
        actions: [
          TextButton(
            onPressed: () async {
              if (forceLogout) {
                await _auth.signOut();
                Navigator.pushNamedAndRemoveUntil(context, '/login', (route) => false);
              } else {
                Navigator.pop(context);
                requestLocationPermission(context);
              }
            },
            child: Text(forceLogout ? "Logout" : "Try Again"),
          ),
        ],
      ),
    );
  }
}
