import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:map_app/blocs/authentication/auth_bloc.dart';
import 'package:map_app/blocs/authentication/auth_event.dart';
import 'package:map_app/blocs/authentication/auth_state.dart';
import 'package:map_app/pages/map_page.dart';

class SignUpPage extends StatefulWidget {
  const SignUpPage({super.key});

  @override
  State<SignUpPage> createState() => _SignUpPageState();
}

class _SignUpPageState extends State<SignUpPage> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _repasswordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return BlocListener<AuthBloc, AuthState>(
      listener: (context, state) {
        if (state is AuthenticatedAuth) {
          Navigator.of(context).pushReplacement(MaterialPageRoute(
            builder: (context) => const MapPage(),
          ));
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
                  Transform.flip(
                    flipY: true,
                    child: Transform.rotate(
                      angle: 3,
                      child: const Icon(
                        Icons.map,
                        size: 125,
                        color: Colors.black,
                      ),
                    ),
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  const Text(
                    'Sign Up',
                    textAlign: TextAlign.start,
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  const Text(
                    'Register an account using your email and password',
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
                      TextField(
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
                      TextField(
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
                      TextField(
                        controller: _repasswordController,
                        obscureText: true,
                        autocorrect: false,
                        decoration: const InputDecoration(
                            labelText: 'Confirm Password',
                            border: OutlineInputBorder(
                                borderRadius:
                                    BorderRadius.all(Radius.circular(10)))),
                      ),
                      const SizedBox(
                        height: 10,
                      ),
                      ElevatedButton(
                          onPressed: () {
                            context.read<AuthBloc>().add(SignUpRequested(
                                _emailController.text.trim(),
                                _passwordController.text
                                    .trim())); // TODO: fix this
                          },
                          style: ElevatedButton.styleFrom(
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(10)),
                              elevation: 0,
                              backgroundColor: Colors.black,
                              padding: const EdgeInsets.all(15)),
                          child: const Text(
                            'Sign Up',
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
                      Navigator.of(context).pop();
                    },
                    child: const Text(
                      'Already have an account? Please log in here.',
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
