import 'package:flutter/material.dart';
import 'package:flutter_map/plugin_api.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:latlong2/latlong.dart';
import 'package:map_app/constants.dart';

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
        body: Stack(
          children: [
            FlutterMap(
              options: MapOptions(
                minZoom: 5,
                maxZoom: 18,
                zoom: 12,
                center: const LatLng(-35.282053, 149.128670),
              ),
              children: [
                TileLayer(
                  urlTemplate: AppLevelConstants.mbShareURL,
                  additionalOptions: const {
                    'mapStyleId': AppLevelConstants.mbStyleID,
                    'accessToken': AppLevelConstants.mbAccessToken
                  },
                )
              ],
            )
          ],
        ),
      ),
    );
  }
}
