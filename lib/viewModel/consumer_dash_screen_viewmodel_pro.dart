// import 'package:flutter/material.dart';
// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:firebase_auth/firebase_auth.dart';
// import 'package:geolocator/geolocator.dart';
// import 'package:geocoding/geocoding.dart';
//
// class DashScreenProvider with ChangeNotifier {
//   List<Map<String, dynamic>> suppliers = [];
//   bool isLoading = true;
//   String userLocation = "Fetching location...";
//   final TextEditingController locationController = TextEditingController();
//
//   DashScreenProvider() {
//     fetchSavedLocation().then((_) {
//       if (userLocation.isEmpty) {
//         fetchUserLocation();
//       }
//     });
//     fetchSuppliers();
//   }
//
//   Future<void> fetchUserLocation() async {
//     bool serviceEnabled;
//     LocationPermission permission;
//
//     serviceEnabled = await Geolocator.isLocationServiceEnabled();
//     if (!serviceEnabled) {
//       userLocation = "Location services are disabled.";
//       notifyListeners();
//       return;
//     }
//
//     permission = await Geolocator.checkPermission();
//     if (permission == LocationPermission.denied) {
//       permission = await Geolocator.requestPermission();
//       if (permission == LocationPermission.denied) {
//         userLocation = "Location permission denied.";
//         notifyListeners();
//         return;
//       }
//     }
//
//     if (permission == LocationPermission.deniedForever) {
//       userLocation = "Location permission permanently denied.";
//       notifyListeners();
//       return;
//     }
//
//     Position position = await Geolocator.getCurrentPosition(
//         desiredAccuracy: LocationAccuracy.high);
//     List<Placemark> placemarks =
//     await placemarkFromCoordinates(position.latitude, position.longitude);
//     Placemark place = placemarks[0];
//
//     String fullAddress = "${place.street ?? ''}, ${place.subLocality ?? ''}, "
//         "${place.locality ?? ''}, ${place.administrativeArea ?? ''}, ${place.country ?? ''}";
//
//     userLocation =
//     fullAddress.isNotEmpty ? fullAddress : "Address not available.";
//     locationController.text = userLocation;
//     notifyListeners();
//
//     // Re-fetch suppliers based on updated location
//     fetchSuppliers();
//   }
//
//   Future<void> fetchSavedLocation() async {
//     try {
//       final user = FirebaseAuth.instance.currentUser;
//       if (user == null) return;
//
//       final docSnapshot =
//       await FirebaseFirestore.instance.collection('Users').doc(user.uid).get();
//
//       if (docSnapshot.exists && docSnapshot.data()?['location'] != null) {
//         userLocation = docSnapshot.data()?['location'];
//         locationController.text = userLocation;
//         notifyListeners();
//
//         // Re-fetch suppliers based on saved location
//         fetchSuppliers();
//       }
//     } catch (e) {
//       print("Error fetching saved location: $e");
//     }
//   }
//
//   Future<void> saveLocationToFirestore() async {
//     try {
//       final user = FirebaseAuth.instance.currentUser;
//       if (user == null) return;
//
//       await FirebaseFirestore.instance
//           .collection('Users')
//           .doc(user.uid)
//           .set({'location': locationController.text}, SetOptions(merge: true));
//       notifyListeners();
//     } catch (e) {
//       print('Error saving location: $e');
//     }
//   }
//
//   Future<void> fetchSuppliers() async {
//     try {
//       isLoading = true;
//       notifyListeners();
//
//       final querySnapshot =
//       await FirebaseFirestore.instance.collection('suppliers').get();
//
//       suppliers = querySnapshot.docs
//           .map((doc) {
//         final data = doc.data();
//         return {
//           'id': doc.id,
//           'companyName': data['company_name'] ?? 'Unknown Company',
//           'email': data['email'] ?? 'No Email Provided',
//           'phone': data['phone'] ?? 'No Phone Number',
//           'address': data['address'] ?? 'No Address Available',
//         };
//       })
//           .where((supplier) => supplier['address']
//           .toLowerCase()
//           .contains(userLocation.toLowerCase()))
//           .toList();
//
//       isLoading = false;
//       notifyListeners();
//     } catch (e) {
//       print('Error fetching suppliers: $e');
//       isLoading = false;
//       notifyListeners();
//     }
//   }
// }
