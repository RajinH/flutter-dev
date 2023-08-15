import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_map/plugin_api.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:latlong2/latlong.dart';
import 'package:map_app/constants.dart';
import 'package:url_launcher/url_launcher.dart';

void main() {
  runApp(const MainApp());
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    ThemeData buildTheme(brightness) {
      var baseTheme = ThemeData(brightness: brightness);
      return baseTheme.copyWith(
        textTheme: GoogleFonts.poppinsTextTheme(baseTheme.textTheme),
      );
    }

    return MaterialApp(
      theme: buildTheme(Brightness.light),
      home: Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.blueAccent,
          elevation: 0,
          title: const Text(
            'Maps Integration',
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
        ),
        body: const MapPage(),
      ),
    );
  }
}

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
        location: const LatLng(-35.265870, 149.100154)),
    Location(
        imageURL:
            'https://lh5.googleusercontent.com/p/AF1QipNIj8sNrC0cKnWsFeVkMmqiHTTCUUGdbSZcSeDv=w408-h306-k-no',
        name: 'Place 2',
        address: 'Place 2, Canberra',
        location: const LatLng(-35.271074, 149.090780)),
    Location(
        imageURL:
            'https://lh5.googleusercontent.com/p/AF1QipNfdXZWUzopbO5IRBN8PupvcC76yY7Pkp2XPs3m=w408-h306-k-no',
        name: 'Place 3',
        address: 'Place 3, Canberra',
        location: const LatLng(-35.277400, 149.101591)),
  ];

  late final MapController mapController;
  final pageController = PageController();

  int currentPage = 0;
  LatLng currentLocation = const LatLng(-35.269310, 149.097613);

  @override
  void initState() {
    super.initState();
    mapController = MapController();
  }

  static openMap(double latitude, double longitude) async {
    var uri = Uri();

    if (Platform.isAndroid) {
      uri = Uri.parse(Uri.encodeFull(
          "https://www.google.com/maps/search/?api=1&query=$latitude,$longitude"));
    } else {
      uri = Uri.parse(
          Uri.encodeFull("https://maps.apple.com/?daddr=$latitude,$longitude"));
    }

    if (await canLaunchUrl(uri)) {
      await launchUrl(uri,
          mode: Platform.isAndroid
              ? LaunchMode.externalApplication
              : LaunchMode.platformDefault);
    } else {
      throw 'Could not launch ${uri.toString()}';
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
            minZoom: 5,
            maxZoom: 18,
            zoom: 14,
            center: currentLocation,
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
                    point: locations[i].location!,
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
          height: MediaQuery.of(context).size.height * 0.25,
          child: PageView.builder(
              controller: pageController,
              onPageChanged: (value) {
                setState(() {
                  currentPage = value;
                  currentLocation = locations[value].location!;
                  _animatedMapMove(currentLocation, 14);
                });
              },
              itemCount: locations.length,
              itemBuilder: (_, index) {
                final location = locations[index];
                return Padding(
                  padding: const EdgeInsets.all(20),
                  child: Card(
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(15)),
                    elevation: 2,
                    child: Padding(
                      padding: const EdgeInsets.all(20),
                      child: IntrinsicWidth(
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.stretch,
                          children: [
                            Expanded(
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.start,
                                crossAxisAlignment: CrossAxisAlignment.stretch,
                                children: [
                                  Text(
                                    location.name ?? 'Unknown',
                                    style: const TextStyle(
                                      fontSize: 20,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  Text(
                                    location.address ?? 'Unknown',
                                    style: const TextStyle(
                                      fontSize: 13,
                                    ),
                                  ),
                                  const Expanded(
                                    child: SizedBox(
                                      height: 10,
                                    ),
                                  ),
                                  ElevatedButton.icon(
                                      style: ElevatedButton.styleFrom(
                                          elevation: 0,
                                          tapTargetSize:
                                              MaterialTapTargetSize.shrinkWrap,
                                          padding: EdgeInsets.zero,
                                          backgroundColor: Colors.blueAccent),
                                      onPressed: () {
                                        openMap(currentLocation.latitude,
                                            currentLocation.longitude);
                                      },
                                      icon: const Icon(Icons.map_outlined),
                                      label: const Text(
                                        'Direction',
                                        style: TextStyle(
                                            fontWeight: FontWeight.bold),
                                      ))
                                ],
                              ),
                            ),
                            const SizedBox(
                              width: 10,
                            ),
                            Expanded(
                              child: Container(
                                clipBehavior: Clip.hardEdge,
                                decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(8)),
                                child: Image.network(
                                  location.imageURL ?? '',
                                  fit: BoxFit.cover,
                                  errorBuilder: (context, error, stackTrace) {
                                    return Container(
                                      color: Colors.blueAccent,
                                    );
                                  },
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                );
              }),
        ),
      ],
    );
  }
}

class Location {
  final String? imageURL;
  final String? name;
  final String? address;
  final LatLng? location;

  Location({
    this.imageURL,
    this.name,
    this.address,
    this.location,
  });
}
