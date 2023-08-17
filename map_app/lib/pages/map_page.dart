import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
import 'package:map_app/shared/constants.dart';
import 'package:map_app/shared/location.dart';
import 'package:map_app/shared/utils.dart';
import 'package:map_app/widgets/location_card.dart';

class MapPage extends StatefulWidget {
  const MapPage({
    super.key,
  });

  @override
  State<MapPage> createState() => _MapPageState();
}

class _MapPageState extends State<MapPage> with TickerProviderStateMixin {
  final locations = [
    Location(
        imageURL:
            'https://lh5.googleusercontent.com/p/AF1QipN9kjrOCsU5mxRRoJZV5sciGxtLePE7VYCwueKq=w408-h306-k-no',
        name: 'Place 1',
        address: 'Place 1, Canberra',
        latlong: const LatLng(-35.265870, 149.100154)),
    Location(
        imageURL:
            'https://lh5.googleusercontent.com/p/AF1QipNIj8sNrC0cKnWsFeVkMmqiHTTCUUGdbSZcSeDv=w408-h306-k-no',
        name: 'Place 2',
        address: 'Place 2, Canberra',
        latlong: const LatLng(-35.271074, 149.090780)),
    Location(
        imageURL:
            'https://lh5.googleusercontent.com/p/AF1QipNfdXZWUzopbO5IRBN8PupvcC76yY7Pkp2XPs3m=w408-h306-k-no',
        name: 'Place 3',
        address: 'Place 3, Canberra',
        latlong: const LatLng(-35.277400, 149.101591)),
  ];

  late final MapController mapController;
  final pageController = PageController();

  int currentPage = 0;
  LatLng currentLocation = const LatLng(-35.269310, 149.097613);

  @override
  void initState() {
    super.initState();
    mapController = MapController();

    for (var i = 0; i < 20; i++) {
      locations.add(Location(
          name: 'Random Place $i',
          address: 'Random Place $i, Canberra',
          latlong: LatLng(
              Utils.generateRandomNumberInRangeWithDecimals(
                  -35.515, -35.118, 6),
              Utils.generateRandomNumberInRangeWithDecimals(
                  148.921, 149.26, 6))));
    }
  }

  void _animatedMapMove(LatLng destLocation, double destZoom) {
    final latTween = Tween<double>(
        begin: mapController.center.latitude, end: destLocation.latitude);
    final lngTween = Tween<double>(
        begin: mapController.center.longitude, end: destLocation.longitude);
    final zoomTween = Tween<double>(begin: mapController.zoom, end: destZoom);
    final rotationTween = Tween<double>(begin: mapController.rotation, end: 0);

    var controller = AnimationController(
        duration: const Duration(milliseconds: 1000), vsync: this);

    Animation<double> animation =
        CurvedAnimation(parent: controller, curve: Curves.fastOutSlowIn);

    controller.addListener(() {
      mapController.moveAndRotate(
          LatLng(latTween.evaluate(animation), lngTween.evaluate(animation)),
          zoomTween.evaluate(animation),
          rotationTween.evaluate(animation));
    });

    animation.addStatusListener((status) {
      if (status == AnimationStatus.completed) {
        controller.dispose();
      } else if (status == AnimationStatus.dismissed) {
        controller.dispose();
      }
    });

    controller.forward();
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        FlutterMap(
          mapController: mapController,
          options: MapOptions(
            minZoom: 3,
            maxZoom: 18,
            zoom: 13,
            center: currentLocation,
            onTap: (tapPosition, point) {
              setState(() {
                currentLocation = point;
                _animatedMapMove(currentLocation, 13);
              });
            },
          ),
          children: [
            TileLayer(
              urlTemplate: AppLevelConstants.mbShareURL,
              additionalOptions: const {
                'mapStyleId': AppLevelConstants.mbStyleID,
                'accessToken': AppLevelConstants.mbAccessToken
              },
            ),
            MarkerLayer(
              markers: [
                for (int i = 0; i < locations.length; i++)
                  Marker(
                    height: 60,
                    width: 60,
                    point: locations[i].latlong!,
                    builder: (context) {
                      return GestureDetector(
                        onTap: () {
                          setState(() {
                            currentPage = i;
                            pageController.jumpToPage(
                              i,
                            );
                          });
                        },
                        child: AnimatedScale(
                          duration: const Duration(milliseconds: 100),
                          scale: currentPage == i ? 1 : 0.8,
                          child: AnimatedOpacity(
                            duration: const Duration(milliseconds: 100),
                            opacity: currentPage == i ? 1 : 0.3,
                            child: const Icon(
                              Icons.not_listed_location,
                              color: Colors.blueAccent,
                              size: 50,
                            ),
                          ),
                        ),
                      );
                    },
                  )
              ],
            )
          ],
        ),
        Positioned(
            left: 0,
            right: 0,
            top: 10,
            child: SizedBox(
              height: 200,
              child: PageView.builder(
                  controller: pageController,
                  onPageChanged: (value) {
                    setState(() {
                      currentPage = value;
                      currentLocation = locations[value].latlong!;
                      _animatedMapMove(currentLocation, 13);
                    });
                  },
                  itemCount: locations.length,
                  itemBuilder: (_, index) {
                    final location = locations[index];

                    return Padding(
                      padding: const EdgeInsets.all(20),
                      child: LocationCard(location: location),
                    );
                  }),
            )),
      ],
    );
  }
}
