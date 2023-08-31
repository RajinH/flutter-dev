import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
import 'package:map_app/blocs/locations_cubit.dart';
import 'package:map_app/blocs/locations_states.dart';
import 'package:map_app/repositories/locations_repo.dart';
import 'package:map_app/shared/constants.dart';
import 'package:map_app/models/location.dart';
import 'package:map_app/widgets/information_sheet.dart';
import 'package:map_app/widgets/location_card.dart';

class MapPage extends StatefulWidget {
  const MapPage({
    super.key,
  });

  @override
  State<MapPage> createState() => _MapPageState();
}

class _MapPageState extends State<MapPage> with TickerProviderStateMixin {
  late final MapController mapController;
  final pageController = PageController();

  int currentPage = 0;
  LatLng currentLocation = const LatLng(-35.269310, 149.097613);

  @override
  void initState() {
    super.initState();
    mapController = MapController();
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

  void onShowBottomSheet(Location location) {
    showBottomSheet(
      context: context,
      builder: (context) {
        return InformationSheet(
          location: location,
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => LocationsCubit(LocationsRepository()),
      child: BlocBuilder<LocationsCubit, LocationsState>(
        builder: (context, state) {
          if (state is LocationsLoadingState) {
            return const Center(child: CircularProgressIndicator.adaptive());
          }

          if (state is LocationsErrorState) {
            return const Center(
              child: Text('Sorry Something Went Wrong :()'),
            );
          }

          if (state is LocationsLoadedState) {
            List<Location> locations = state.locations;

            return Stack(
              children: [
                FlutterMap(
                  mapController: mapController,
                  nonRotatedChildren: const [],
                  options: MapOptions(
                    minZoom: 3,
                    maxZoom: 18,
                    zoom: 13,
                    center: currentLocation,
                    onTap: (tapPosition, point) {
                      setState(() {
                        currentLocation = point;
                        // fetchLocationData(currentLocation);
                        _animatedMapMove(currentLocation, 13);
                      });
                    },
                  ),
                  children: [
                    TileLayer(
                      urlTemplate: AppLevelConstants.mbShareURL,
                      additionalOptions: {
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
                                    child: Icon(
                                      Icons.whatshot,
                                      color: locations[i].type ==
                                              LocationType.permanent
                                          ? Colors.blueAccent
                                          : Colors.amberAccent,
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
                              Navigator.of(context).maybePop();
                              _animatedMapMove(currentLocation, 13);
                            });
                          },
                          itemCount: locations.length,
                          itemBuilder: (_, index) {
                            final location = locations[index];

                            return Padding(
                              padding: const EdgeInsets.all(20),
                              child: LocationCard(
                                location: location,
                                onTap: () => {onShowBottomSheet(location)},
                              ),
                            );
                          }),
                    )),
              ],
            );
          } else {
            return const Center(
              child: Text('Sorry Something Went Wrong :()'),
            );
          }
        },
      ),
    );
  }
}
