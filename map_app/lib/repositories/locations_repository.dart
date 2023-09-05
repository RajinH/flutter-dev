import 'dart:convert';
import 'dart:math';

import 'package:http/http.dart';
import 'package:latlong2/latlong.dart';
import 'package:map_app/models/weather.dart';
import 'package:map_app/shared/constants.dart';
import 'package:map_app/models/location.dart';

class LocationsRepository {
  String locationEndpointURL =
      'https://api.mapbox.com/geocoding/v5/mapbox.places/';
  String weatherEndpointURL = 'https://api.openweathermap.org/data/2.5/';

  Future<List<Location>> getLocations(List<LatLng> latLongs) async {
    List<Location> locations = [];
    List<double> ratings = [0, 0.5, 1, 1.5, 2, 2.5, 3, 3.5, 4, 4.5, 5];
    String description =
        'Lorem ipsum dolor sit amet, consectetur adipiscing elit. Nunc quis augue finibus, sollicitudin mauris at, fringilla dolor. Curabitur quis rutrum dolor, eget varius urna. Suspendisse vehicula commodo eros, eget euismod ex porta ac. Cras suscipit feugiat leo. Morbi sem magna, tempor eu facilisis ut, sollicitudin ut mauris. Suspendisse bibendum auctor nibh sed lobortis. Nunc interdum est vitae sem euismod, id aliquam est pharetra. Curabitur hendrerit orci dignissim tortor sodales, vel porttitor magna maximus. Proin id ligula blandit, posuere lectus quis, aliquam arcu. Etiam tincidunt rhoncus sapien sed tempor.';

    for (LatLng latlong in latLongs) {
      final locationRes = await get(Uri.parse(
          '$locationEndpointURL${latlong.longitude},${latlong.latitude}.json?access_token=${AppLevelConstants.mbAccessToken}'));
      final weatherRes = await get(Uri.parse(
          '${weatherEndpointURL}weather?lat=${latlong.latitude}&lon=${latlong.longitude}&units=metric&appid=${AppLevelConstants.owAccessToken}'));

      if (locationRes.statusCode == 200) {
        if (weatherRes.statusCode == 200) {
          Map<String, dynamic> locationJson = jsonDecode(locationRes.body);
          Map<String, dynamic> weatherJson = jsonDecode(weatherRes.body);

          Weather weather = Weather(
              name: weatherJson['weather'][0]['main'],
              description: weatherJson['weather'][0]['description'],
              temp: double.parse(weatherJson['main']['temp'].toString()),
              humidity:
                  double.parse(weatherJson['main']['humidity'].toString()));

          Location location = Location(
              name: locationJson['features'][0]['text'],
              address: locationJson['features'][0]['place_name'],
              description: description,
              latlong: latlong,
              type: LocationType.permanent,
              rating: ratings[Random().nextInt(ratings.length)],
              weather: weather);

          locations.add(location);
        } else {
          throw Exception(weatherRes.reasonPhrase);
        }
      } else {
        throw Exception(locationRes.reasonPhrase);
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
