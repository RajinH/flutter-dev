import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
import 'package:map_app/blocs/authentication/auth_bloc.dart';
import 'package:map_app/blocs/authentication/auth_event.dart';
import 'package:map_app/blocs/authentication/auth_state.dart';
import 'package:map_app/blocs/locations/locations_cubit.dart';
import 'package:map_app/blocs/locations/locations_states.dart';
import 'package:map_app/pages/login_page.dart';
import 'package:map_app/repositories/locations_repository.dart';
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
  late final PageController pageController;

  int currentPage = 0;
  LatLng currentLocation = const LatLng(-35.269310, 149.097613);

  @override
  void initState() {
    super.initState();
    pageController = PageController();
    mapController = MapController();
  }

  @override
  void dispose() {
    pageController.dispose();
    mapController.dispose();
    super.dispose();
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
    return BlocListener<AuthBloc, AuthState>(
      listener: (context, state) {
        if (state is UnauthenticatedAuth) {
          Navigator.of(context).pushReplacement(MaterialPageRoute(
            builder: (context) => const LogInPage(),
          ));
        }
      },
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.blueAccent,
          elevation: 0,
          title: const Text(
            'Maps Integration',
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
        ),
        body: BlocProvider(
          create: (context) => LocationsCubit(LocationsRepository()),
          child: BlocBuilder<LocationsCubit, LocationsState>(
            builder: (context, state) {
              if (state is LocationsLoadingState) {
                return const Center(
                    child: CircularProgressIndicator.adaptive());
              }

              if (state is LocationsErrorState) {
                return const Center(
                  child: Text('Sorry Something Went Wrong :('),
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
                                      duration:
                                          const Duration(milliseconds: 100),
                                      scale: currentPage == i ? 1 : 0.8,
                                      child: AnimatedOpacity(
                                        duration:
                                            const Duration(milliseconds: 100),
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
                        top: 110,
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
                                  child: LocationCard(
                                    location: location,
                                    onTap: () => {
                                      showBottomSheet(
                                        context: context,
                                        builder: (context) {
                                          return InformationSheet(
                                            location: location,
                                          );
                                        },
                                      )
                                    },
                                  ),
                                );
                              }),
                        )),
                    BlocBuilder<AuthBloc, AuthState>(
                      builder: (context, state) {
                        if (state is AuthenticatedAuth) {
                          User? user = state.firebaseUser;

                          return Positioned(
                              top: 10,
                              right: 22,
                              child: SizedBox(
                                height: 100,
                                child: Card(
                                  shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(15)),
                                  elevation: 5,
                                  color: Colors.white,
                                  child: Padding(
                                    padding: const EdgeInsets.all(20),
                                    child: IntrinsicWidth(
                                      child: Column(
                                        children: [
                                          Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.spaceBetween,
                                            children: [
                                              Column(
                                                children: [
                                                  Text(
                                                    user?.email ??
                                                        'Unknown Name',
                                                    style: const TextStyle(
                                                        fontWeight:
                                                            FontWeight.bold),
                                                  ),
                                                ],
                                              ),
                                              const SizedBox(
                                                width: 20,
                                              ),
                                              Expanded(
                                                child: ElevatedButton(
                                                    onPressed: () {
                                                      context.read<AuthBloc>().add(
                                                          const SignOutRequested());
                                                      Navigator.of(context)
                                                          .pushReplacement(
                                                              MaterialPageRoute(
                                                        builder: (context) =>
                                                            const LogInPage(),
                                                      ));
                                                    },
                                                    child:
                                                        const Text('Log Out')),
                                              ),
                                            ],
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                ),
                              ));
                        } else {
                          return const SizedBox.shrink();
                        }
                      },
                    ),
                  ],
                );
              } else {
                return const Center(
                  child: Text('Sorry Something Went Wrong :()'),
                );
              }
            },
          ),
        ),
      ),
    );
  }
}
