import 'package:latlong2/latlong.dart';

enum LocationType { permanent, userDefined }

class Location {
  final String? imageURL;
  String? name;
  final String? address;
  final LatLng? latlong;
  final LocationType? type;

  Location({this.imageURL, this.name, this.address, this.latlong, this.type});
}
