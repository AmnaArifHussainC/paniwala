import 'package:flutter/material.dart';
import '../core/services/location_permisstion.dart';

class LocationViewModel extends ChangeNotifier {
  String? _address;
  bool _isLoading = false;

  String? get address => _address; // Expose the address to the UI
  bool get isLoading => _isLoading; // Expose loading state

  // Request location permission
  Future<bool> requestLocationPermission() async {
    try {
      bool permissionGranted = await LocationService.requestPermission();
      return permissionGranted;
    } catch (e) {
      print("Error requesting location permission: $e");
      return false;
    }
  }

  // Check if location permission is granted
  Future<bool> hasLocationPermission() async {
    try {
      return await LocationService.hasPermission();
    } catch (e) {
      print("Error checking location permission: $e");
      return false;
    }
  }

  // Fetch current location
  Future<void> fetchCurrentLocation() async {
    _isLoading = true;
    notifyListeners();

    try {
      String? currentAddress = await LocationService.getCurrentLocation();
      if (currentAddress != null) {
        _address = currentAddress;
      }
    } catch (e) {
      print("Error fetching current location: $e");
    }

    _isLoading = false;
    notifyListeners();
  }

  // Get saved address
  Future<void> getSavedAddress() async {
    _isLoading = true;
    notifyListeners();

    try {
      String? savedAddress = await LocationService.getSavedAddress();
      if (savedAddress != null) {
        _address = savedAddress;
      }
    } catch (e) {
      print("Error fetching saved address: $e");
    }

    _isLoading = false;
    notifyListeners();
  }
}
