import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:map_app/pages/map_page.dart';

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
