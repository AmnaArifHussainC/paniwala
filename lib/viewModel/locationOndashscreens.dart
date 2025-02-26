import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:geolocator/geolocator.dart';
import 'package:geocoding/geocoding.dart';
import 'package:flutter/material.dart';

class LocationViewModel extends ChangeNotifier {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  String? _userLocation;
  bool _isLoading = false;

  String? get userLocation => _userLocation;
  bool get isLoading => _isLoading;

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

  Future<void> saveUserLocation() async {
    _isLoading = true;
    notifyListeners();

    try {
      User? user = _auth.currentUser;
      if (user != null) {
        String? role = await _getUserRole(user.uid);
        if (role != null) {
          Position position = await Geolocator.getCurrentPosition(desiredAccuracy: LocationAccuracy.high);
          List<Placemark> placemarks = await placemarkFromCoordinates(position.latitude, position.longitude);
          String address = "${placemarks.first.street}, ${placemarks.first.locality}, ${placemarks.first.country}";

          await _firestore.collection(role).doc(user.uid).set({
            'location': address,
          }, SetOptions(merge: true));

          _userLocation = address;
        }
      }
    } catch (e) {
      print("Error saving location: $e");
    }

    _isLoading = false;
    notifyListeners();
  }


  Future<void> updateUserLocation(String newLocation) async {
    if (newLocation.isNotEmpty) {
      _userLocation = newLocation;
      notifyListeners();

      User? user = _auth.currentUser;
      if (user != null) {
        String? role = await _getUserRole(user.uid);
        if (role != null) {
          await _firestore.collection(role).doc(user.uid).set({
            'location': newLocation,
          }, SetOptions(merge: true));
        }
      }
    }
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
}
