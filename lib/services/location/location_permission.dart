import 'package:geolocator/geolocator.dart';
import 'package:geocoding/geocoding.dart';

class LocationService {
  Future<String> requestAndSaveLocation(String userId) async {
    try {
      // Request permission
      LocationPermission permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied ||
          permission == LocationPermission.deniedForever) {
        throw Exception("Location permission denied");
      }

      // Get current position
      Position position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high,
      );

      // Reverse geocoding to get address
      List<Placemark> placemarks = await placemarkFromCoordinates(
        position.latitude,
        position.longitude,
      );

      // Extract location details
      Placemark place = placemarks[0];
      String locationName =
          "${place.locality}, ${place.subAdministrativeArea}, ${place.country}";

      // Save location to Firestore or log
      print("Location Name: $locationName");
      // Add your Firestore save logic here, if needed

      return locationName; // Return the readable location name
    } catch (e) {
      print("Error retrieving location: $e");
      rethrow;
    }
  }
}
