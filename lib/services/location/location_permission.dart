import 'package:geolocator/geolocator.dart';

class PermissionAndPositionService {
  Future<Position> fetchUserPosition() async {
    // Request permission
    LocationPermission permission = await Geolocator.requestPermission();
    if (permission == LocationPermission.denied ||
        permission == LocationPermission.deniedForever) {
      throw Exception("Location permission denied");
    }

    // Get current position
    return await Geolocator.getCurrentPosition(
      desiredAccuracy: LocationAccuracy.bestForNavigation,
    );
  }
}
