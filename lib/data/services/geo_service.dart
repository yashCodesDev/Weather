import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';

class GeoService {
  // get current location, ask for permission if not granted
  Future<Position> getCurrentLocation() async {
    final GeolocatorPlatform geolocatorPlatform = GeolocatorPlatform.instance;
    final LocationPermission permission =
        await geolocatorPlatform.checkPermission();
    if (permission == LocationPermission.deniedForever) {
      return Future.error(
        'Location permissions are permanently denied, we cannot request permissions.',
      );
    } else if (permission == LocationPermission.denied) {
      final LocationPermission permission =
          await geolocatorPlatform.requestPermission();
      if (permission == LocationPermission.denied) {
        return Future.error('Location permissions are denied');
      }
    }
    return await geolocatorPlatform.getCurrentPosition();
  }

//CitySelection
  Future<Map<String, dynamic>> getLocationByCityName(String cityName) async {
    try {
      final GeocodingPlatform? geocodingPlatform = GeocodingPlatform.instance;
      final List<Location>? locations =
          await geocodingPlatform?.locationFromAddress(cityName);
      if (locations!.isNotEmpty) {
        final Location location = locations[0];
        return {
          'latitude': location.latitude,
          'longitude': location.longitude,
        };
      } else {
        return Future.error(
            'Could not find coordinates for the specified city');
      }
    } catch (e) {
      return Future.error('Error getting coordinates: $e');
    }
  }
}
