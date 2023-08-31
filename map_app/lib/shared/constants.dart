import 'package:flutter_dotenv/flutter_dotenv.dart';

class AppLevelConstants {
  static String mbAccessToken =
      dotenv.env['MB_API_TOKEN'] ?? 'MB_API_TOKEN not found';
  static String mbStyleID = "cllbkoxl000dj01pw6xnm42kb";
  static String mbShareURL =
      "https://api.mapbox.com/styles/v1/rajinhossain/$mbStyleID/tiles/256/{z}/{x}/{y}@2x?access_token=$mbAccessToken";

  static String owAccessToken =
      dotenv.env['OW_API_TOKEN'] ?? 'OW_API_TOKEN not found';
}
