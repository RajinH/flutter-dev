import 'dart:convert';

import 'package:http/http.dart';
import 'package:latlong2/latlong.dart';
import 'package:map_app/shared/constants.dart';
import 'package:map_app/models/location.dart';

class LocationsRepository {
  String endpointURL = 'https://api.mapbox.com/geocoding/v5/mapbox.places/';

  Future<List<Location>> getLocations(List<LatLng> latLongs) async {
    List<Location> locations = [];

    for (LatLng latlong in latLongs) {
      final response = await get(Uri.parse(
          '$endpointURL${latlong.longitude},${latlong.latitude}.json?access_token=${AppLevelConstants.mbAccessToken}'));

      if (response.statusCode == 200) {
        Map<String, dynamic> responseJson = jsonDecode(response.body);
        Location location = Location(
          name: responseJson['features'][0]['text'],
          address: responseJson['features'][0]['place_name'],
          latlong: latlong,
          type: LocationType.permanent,
        );
        locations.add(location);
      } else {
        throw Exception(response.reasonPhrase);
      }
    }
    return locations;
  }

  Future<String> getAddress(LatLng latlong) async {
    final response = await get(Uri.parse(
        'https://api.mapbox.com/geocoding/v5/mapbox.places/${latlong.longitude},${latlong.latitude}.json?access_token=${AppLevelConstants.mbAccessToken}'));

    if (response.statusCode == 200) {
      Map<String, dynamic> responseJson = jsonDecode(response.body);
      return responseJson['features'][0]['place_name'];
    } else {
      throw Exception('Failed to load location data');
    }
  }
}
