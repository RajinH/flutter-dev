import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:map_app/blocs/authentication/auth_bloc.dart';
import 'package:map_app/blocs/authentication/auth_event.dart';
import 'package:map_app/blocs/authentication/auth_state.dart';
import 'package:map_app/pages/map_page.dart';
import 'package:map_app/pages/signup_page.dart';

class LogInPage extends StatefulWidget {
  const LogInPage({super.key});

  @override
  State<LogInPage> createState() => _LogInPageState();
}

class _LogInPageState extends State<LogInPage> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return BlocListener<AuthBloc, AuthState>(
      listener: (context, state) {
        if (state is AuthenticatedAuth) {
          print('here lol : ${state.firebaseUser?.email}');
          Navigator.of(context).pushReplacement(
            MaterialPageRoute(
              builder: (context) => const MapPage(),
            ),
          );
        }
      },
      child: Scaffold(
          backgroundColor: Colors.white,
          body: Center(
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 30),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Transform.rotate(
                    angle: 3,
                    child: const Icon(
                      Icons.map,
                      size: 125,
                      color: Colors.blueAccent,
                    ),
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  const Text(
                    'Log In',
                    textAlign: TextAlign.start,
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  const Text(
                    'Authenticate yourself using your registered email and password',
                    textAlign: TextAlign.start,
                    style: TextStyle(fontSize: 13, height: 1),
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  Form(
                      child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      TextFormField(
                        controller: _emailController,
                        keyboardType: TextInputType.emailAddress,
                        autocorrect: false,
                        decoration: const InputDecoration(
                            labelText: 'Email',
                            border: OutlineInputBorder(
                                borderRadius:
                                    BorderRadius.all(Radius.circular(10)))),
                      ),
                      const SizedBox(
                        height: 10,
                      ),
                      TextFormField(
                        controller: _passwordController,
                        obscureText: true,
                        autocorrect: false,
                        decoration: const InputDecoration(
                            labelText: 'Password',
                            border: OutlineInputBorder(
                                borderRadius:
                                    BorderRadius.all(Radius.circular(10)))),
                      ),
                      const SizedBox(
                        height: 10,
                      ),
                      ElevatedButton(
                          onPressed: () {
                            context.read<AuthBloc>().add(SignInRequested(
                                _emailController.text.trim(),
                                _passwordController.text.trim()));
                          },
                          style: ElevatedButton.styleFrom(
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(10)),
                              elevation: 0,
                              backgroundColor: Colors.blueAccent,
                              padding: const EdgeInsets.all(15)),
                          child: const Text(
                            'Log In',
                            style: TextStyle(
                                fontSize: 15, fontWeight: FontWeight.bold),
                          )),
                    ],
                  )),
                  const SizedBox(
                    height: 20,
                  ),
                  GestureDetector(
                    onTap: () {
                      Navigator.of(context).push(MaterialPageRoute(
                        builder: (context) => const SignUpPage(),
                      ));
                    },
                    child: const Text(
                      'No account? Please register here.',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                          fontSize: 13,
                          fontWeight: FontWeight.bold,
                          height: 1,
                          decoration: TextDecoration.underline),
                    ),
                  ),
                ],
              ),
            ),
          )),
    );
  }
}
