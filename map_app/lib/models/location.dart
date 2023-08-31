import 'package:latlong2/latlong.dart';
import 'package:map_app/models/weather.dart';

enum LocationType { permanent, userDefined }

class Location {
  final String? imageURL;
  String? name;
  final String? address;
  final String? description;
  final LatLng? latlong;
  final LocationType? type;
  final double? rating;
  final Weather? weather;

  Location(
      {this.imageURL,
      this.name,
      this.address,
      this.description,
      this.latlong,
      this.type,
      this.rating,
      this.weather});
}
