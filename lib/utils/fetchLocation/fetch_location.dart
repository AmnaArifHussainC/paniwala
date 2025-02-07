import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';

class DetailedAddressService {
  Future<String> getDetailedAddress(Position position) async {
    try {
      // Reverse geocoding
      List<Placemark> placemarks = await placemarkFromCoordinates(
        position.latitude,
        position.longitude,
      );

      if (placemarks.isNotEmpty) {
        Placemark place = placemarks[0];
        // Construct detailed address
        return "${place.street}, ${place.subLocality}, ${place.locality}, "
            "${place.subAdministrativeArea}, ${place.administrativeArea}, ${place.country}";
      } else {
        return "Address not found";
      }
    } catch (e) {
      print("Error fetching address: $e");
      return "Unable to fetch address";
    }
  }
}
