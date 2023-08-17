import 'package:latlong2/latlong.dart';

class Location {
  final String? imageURL;
  final String? name;
  final String? address;
  final LatLng? latlong;

  Location({
    this.imageURL,
    this.name,
    this.address,
    this.latlong,
  });
}
