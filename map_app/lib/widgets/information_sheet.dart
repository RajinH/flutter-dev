import 'package:flutter/material.dart';
import 'package:map_app/widgets/ratings_widget.dart';
import 'package:map_app/widgets/weather_card.dart';

import '../models/location.dart';

class InformationSheet extends StatelessWidget {
  const InformationSheet({
    super.key,
    required this.location,
  });

  final Location location;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 0.35 * MediaQuery.of(context).size.height,
      color: Colors.white,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Container(
            padding: const EdgeInsets.symmetric(vertical: 8),
            color: Colors.blueAccent,
            child: const Icon(
              Icons.swipe_down,
              color: Colors.white,
            ),
          ),
          Expanded(
            child: SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    const SizedBox(
                      height: 20,
                    ),
                    HeaderInformation(location: location),
                    const SizedBox(
                      height: 30,
                    ),
                    Text(
                      location.description ?? 'Unknown',
                      textAlign: TextAlign.justify,
                      style: const TextStyle(
                        fontSize: 13,
                        height: 1.5,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          )
        ],
      ),
    );
  }
}

class HeaderInformation extends StatelessWidget {
  const HeaderInformation({
    super.key,
    required this.location,
  });

  final Location location;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 150,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Expanded(
            flex: 1,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  location.name ?? 'Unknown',
                  maxLines: 3,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(
                    height: 1,
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(
                  height: 8,
                ),
                Text(
                  location.address ?? 'Unknown',
                  maxLines: 3,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(fontSize: 13, height: 1),
                ),
                const SizedBox(
                  height: 8,
                ),
                RatingsWidget(rating: location.rating!),
              ],
            ),
          ),
          const SizedBox(
            width: 20,
          ),
          Expanded(
            child: WeatherCard(location: location),
          )
        ],
      ),
    );
  }
}
