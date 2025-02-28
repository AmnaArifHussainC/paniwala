import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:geolocator/geolocator.dart';
import 'package:geocoding/geocoding.dart';
import 'package:flutter/material.dart';

class LocationService {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<void> requestLocationPermission(BuildContext context) async {
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

    _saveUserLocation();
  }

  Future<void> _saveUserLocation() async {
    try {
      User? user = _auth.currentUser;
      if (user != null) {
        String? role = await _getUserRole(user.uid);
        if (role != null) {
          Position position = await Geolocator.getCurrentPosition(desiredAccuracy: LocationAccuracy.high);
          List<Placemark> placemarks = await placemarkFromCoordinates(position.latitude, position.longitude);
          String address = "${placemarks.first.street}, ${placemarks.first.subLocality}, ${placemarks.first.locality}, ${placemarks.first.administrativeArea}, ${placemarks.first.country}";

          await _firestore.collection(role).doc(user.uid).set({
            'location': address,
          }, SetOptions(merge: true));
        }
      }
    } catch (e) {
      print("Error saving location: $e");
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