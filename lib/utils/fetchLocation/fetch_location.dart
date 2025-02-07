import 'package:geolocator/geolocator.dart';

class LocationHelper {
  static Future<String> fetchLocation() async {
    try {
      // Check if location services are enabled
      bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
      if (!serviceEnabled) {
        return "Location services are disabled.";
      }

      // Check location permissions
      LocationPermission permission = await Geolocator.checkPermission();
      if (permission == LocationPermission.denied) {
        permission = await Geolocator.requestPermission();
        if (permission == LocationPermission.denied) {
          return "Location permissions are denied.";
        }
      }

      if (permission == LocationPermission.deniedForever) {
        return "Location permissions are permanently denied.";
      }

      // Fetch the current position
      Position position = await Geolocator.getCurrentPosition();
      return "Lat: ${position.latitude}, Long: ${position.longitude}";
    } catch (e) {
      return "Failed to fetch location: $e";
    }
  }
}
