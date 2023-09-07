import 'package:flutter/material.dart';
import 'package:map_app/models/location.dart';
import 'package:shimmer/shimmer.dart';

class WeatherCard extends StatelessWidget {
  const WeatherCard({
    super.key,
    required this.location,
  });

  final Location location;

  @override
  Widget build(BuildContext context) {
    return Stack(children: [
      Shimmer.fromColors(
        baseColor: Colors.blueAccent,
        highlightColor: const Color.fromARGB(255, 98, 154, 249),
        direction: ShimmerDirection.rtl,
        period: const Duration(milliseconds: 1000),
        enabled: true,
        child: Container(
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
              color: Colors.blueAccent,
              borderRadius: BorderRadius.circular(15)),
        ),
      ),
      Container(
        padding: const EdgeInsets.all(20),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text(
              location.weather?.name! ?? 'Unknown',
              textAlign: TextAlign.center,
              style: const TextStyle(
                  fontSize: 20,
                  color: Colors.white,
                  height: 1,
                  fontWeight: FontWeight.bold),
            ),
            Text(
              location.weather?.description!.toUpperCase() ?? 'UNKNOWN',
              textAlign: TextAlign.center,
              style: const TextStyle(
                  color: Colors.white,
                  fontSize: 10,
                  height: 1,
                  fontWeight: FontWeight.normal),
            ),
            const SizedBox(
              height: 8,
            ),
            Text(
              '${location.weather?.temp!.toString()} °C',
              textAlign: TextAlign.center,
              style: const TextStyle(
                  color: Colors.white,
                  fontSize: 18,
                  height: 1,
                  fontWeight: FontWeight.bold),
            ),
          ],
        ),
      ),
    ]);
  }
}
