import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:map_app/blocs/authentication/auth_bloc.dart';
import 'package:map_app/blocs/authentication/auth_event.dart';
import 'package:map_app/blocs/authentication/auth_state.dart';
import 'package:map_app/pages/login_page.dart';
import 'package:map_app/pages/map_page.dart';
import 'package:map_app/pages/signup_page.dart';
import 'package:map_app/pages/splash_page.dart';
import 'package:map_app/repositories/auth_repository.dart';

void main() async {
  await dotenv.load(fileName: '.env');

  WidgetsFlutterBinding
      .ensureInitialized(); // need this for firebase initialisation (https://stackoverflow.com/questions/63873338/what-does-widgetsflutterbinding-ensureinitialized-do)

  await Firebase.initializeApp();

  runApp(const MainApp());
}

/// The route configuration.
final GoRouter _router = GoRouter(
  redirect: (context, state) {
    if (state.fullPath == '/') {
      AuthBloc authBloc = context.read<AuthBloc>();
      AuthState authState = authBloc.state;

      if (authState is AuthenticatedAuth) {
        return '/map';
      } else if (authState is UnauthenticatedAuth) {
        return '/login';
      } else {
        return null;
      }
    } else {
      return null;
    }
  },
  routes: <RouteBase>[
    GoRoute(
      path: '/',
      builder: (BuildContext context, GoRouterState state) {
        return const SplashPage();
      },
      routes: [
        GoRoute(
          path: 'map',
          builder: (BuildContext context, GoRouterState state) {
            return const MapPage();
          },
        ),
        GoRoute(
          path: 'login',
          builder: (BuildContext context, GoRouterState state) {
            return const LogInPage();
          },
        ),
        GoRoute(
          path: 'signup',
          builder: (BuildContext context, GoRouterState state) {
            return const SignUpPage();
          },
        ),
      ],
    ),
  ],
);

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

    return RepositoryProvider(
      create: (context) => AuthRepository(),
      child: BlocProvider(
        create: (context) => AuthBloc(
            authRepository: RepositoryProvider.of<AuthRepository>(context))
          ..add(const AuthenticationRequested()),
        child: BlocBuilder<AuthBloc, AuthState>(
          builder: (context, state) {
            return MaterialApp.router(
              debugShowCheckedModeBanner: false,
              theme: buildTheme(Brightness.light),
              routerDelegate: _router.routerDelegate,
              routeInformationParser: _router.routeInformationParser,
              routeInformationProvider: _router.routeInformationProvider,
            );
          },
        ),
      ),
    );
  }
}
