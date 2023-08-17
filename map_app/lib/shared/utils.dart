import 'dart:io';
import 'dart:math';

import 'package:url_launcher/url_launcher.dart';

class Utils {
  static double generateRandomNumberInRangeWithDecimals(
      double min, double max, int decimalPlaces) {
    if (min >= max || decimalPlaces < 0) {
      throw ArgumentError('Invalid arguments');
    }

    Random random = Random();
    double multiplier = pow(10, decimalPlaces).toDouble();
    double randomValue = min + (random.nextDouble() * (max - min));

    randomValue = (randomValue * multiplier).floor() / multiplier;

    return randomValue;
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
}
