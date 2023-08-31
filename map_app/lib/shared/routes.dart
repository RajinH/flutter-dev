import 'package:flutter/material.dart';
import 'package:map_app/pages/login_page.dart';
import 'package:map_app/pages/map_page.dart';
import 'package:map_app/pages/signup_page.dart';

class AppRoutes {
  static Map<String, WidgetBuilder> routes = {
    '/': (context) => const LogInPage(),
    '/login': (context) => const LogInPage(),
    '/signup': (context) => const SignUpPage(),
    '/main ': (context) => const MapPage(),
  };
}
