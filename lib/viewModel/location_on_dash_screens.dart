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


  Future<String?> fetchUserLocation() async {
    _isLoading = true;
    Future.microtask(() {
      notifyListeners();
    });
    User? user = _auth.currentUser;
    if (user != null) {
      String? role = await _getUserRole(user.uid);
      if (role != null) {
        DocumentSnapshot doc = await _firestore.collection(role).doc(user.uid).get();
        _userLocation = doc.exists ? doc['location'] as String? : null;
      }
    }

    _isLoading = false;
    Future.microtask(() {
      notifyListeners();
    });
    return _userLocation;
  }

  Future<void> updateUserLocation(String newLocation) async {
    if (newLocation.isNotEmpty) {
      _userLocation = newLocation;
      Future.microtask(() {
        notifyListeners();
      });
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

          print("Placemark Details: ${placemarks.first}");

          Placemark place = placemarks.first;

          String address =
              "${place.street ?? ''}, "
              "${place.subLocality ?? ''}, "
              "${place.locality ?? ''}, "
              "${place.administrativeArea ?? ''}, "
              "${place.country ?? ''}";

          address = address.replaceAll(RegExp(r',\s+,'), ',').trim();

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


  Future<void> _requestLocationPermission(BuildContext context) async {
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
  }

  void _showPermissionDialog(BuildContext context, {bool forceLogout = false}) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => AlertDialog(
        title: const Text("Location Permission Required"),
        content: const Text("We need your location to proceed. Please enable location access."),
        actions: [
          TextButton(
            onPressed: () async {
              if (forceLogout) {
                await _auth.signOut();
                Navigator.pushNamedAndRemoveUntil(context, '/login', (route) => false);
              } else {
                Navigator.pop(context);
                _requestLocationPermission(context);
              }
            },
            child: Text(forceLogout ? "Logout" : "Try Again"),
          ),
        ],
      ),
    );
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
  Future<List<DocumentSnapshot>> fetchFilteredSuppliers() async {
    User? user = _auth.currentUser;
    if (user == null) return [];

    // Get the user's location
    String? userLocation = await fetchUserLocation();
    if (userLocation == null) return [];

    // Parse user's location into components
    List<String> userLocationParts = userLocation.split(',').map((e) => e.trim()).toList();

    QuerySnapshot snapshot = await _firestore.collection('suppliers').get();
    List<DocumentSnapshot> filteredSuppliers = [];

    for (var doc in snapshot.docs) {
      String supplierLocation = (doc['location'] is String) ? doc['location'] : '';
      List<String> supplierLocationParts = supplierLocation.split(',').map((e) => e.trim()).toList();

      // Check hierarchical matching from country to street
      bool isMatching = false;
      for (int i = 0; i < userLocationParts.length && i < supplierLocationParts.length; i++) {
        if (userLocationParts[i] == supplierLocationParts[i]) {
          isMatching = true; // If any part matches, consider this supplier
          break;
        }
      }

      if (isMatching) {
        filteredSuppliers.add(doc);
      }
    }

    return filteredSuppliers;
  }

}
