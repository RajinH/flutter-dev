import 'package:flutter/material.dart';
import 'package:map_app/models/location.dart';

class WeatherCard extends StatelessWidget {
  const WeatherCard({
    super.key,
    required this.location,
  });

  final Location location;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
          color: Colors.blueAccent, borderRadius: BorderRadius.circular(15)),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Text(
            location.weather?.name! ?? 'Unknown',
            style: const TextStyle(
                fontSize: 20,
                color: Colors.white,
                height: 1,
                fontWeight: FontWeight.bold),
          ),
          Text(
            location.weather?.description!.toUpperCase() ?? 'UNKNOWN',
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
            style: const TextStyle(
                color: Colors.white,
                fontSize: 18,
                height: 1,
                fontWeight: FontWeight.bold),
          ),
        ],
      ),
    );
  }
}
