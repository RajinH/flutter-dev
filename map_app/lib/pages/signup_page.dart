import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:map_app/blocs/authentication/auth_bloc.dart';
import 'package:map_app/blocs/authentication/auth_event.dart';
import 'package:map_app/blocs/authentication/auth_state.dart';
import 'package:map_app/pages/map_page.dart';
import 'package:map_app/repositories/auth_repository.dart';

class SignUpPage extends StatefulWidget {
  const SignUpPage({super.key});

  @override
  State<SignUpPage> createState() => _SignUpPageState();
}

class _SignUpPageState extends State<SignUpPage> {
  final _formField = GlobalKey<FormState>();

  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _repasswordController = TextEditingController();

  bool passwordVisible = false;

  @override
  Widget build(BuildContext context) {
    return BlocListener<AuthBloc, AuthState>(
      listener: (context, state) {
        if (state is AuthenticatedAuth) {
          Navigator.of(context).pushAndRemoveUntil(
            MaterialPageRoute(
              builder: (context) => const MapPage(),
            ),
            (route) => route.willHandlePopInternally,
          );
        }

        if (state is UnauthenticatedAuth) {
          if (state.exception is! EmailInUseException) {
            Navigator.of(context).pop();
          }
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
                  const Row(
                    children: [
                      Text(
                        'Sign Up',
                        textAlign: TextAlign.start,
                        style: TextStyle(
                            fontSize: 20, fontWeight: FontWeight.bold),
                      ),
                      SizedBox(
                        width: 5,
                      ),
                      Icon(Icons.menu_book_sharp)
                    ],
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
                      key: _formField,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          TextFormField(
                            validator: (value) {
                              String? email = value?.trim();
                              if (email == null || email.isEmpty) {
                                return 'Please enter an email address';
                              }
                              RegExp emailRegex = RegExp(
                                  r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+");
                              if (!emailRegex.hasMatch(email)) {
                                return 'Please enter a valid email address';
                              }
                              return null;
                            },
                            controller: _emailController,
                            keyboardType: TextInputType.emailAddress,
                            autocorrect: false,
                            decoration: const InputDecoration(
                                prefixIcon: Icon(Icons.email_outlined),
                                labelText: 'Email',
                                border: OutlineInputBorder(
                                    borderRadius:
                                        BorderRadius.all(Radius.circular(10)))),
                          ),
                          const SizedBox(
                            height: 10,
                          ),
                          TextFormField(
                            validator: (value) {
                              String? password = value?.trim();
                              if (password == null || password.isEmpty) {
                                return 'Please enter a password';
                              }
                              RegExp passwordRegex =
                                  RegExp(r"(?=.*[0-9a-zA-Z]).{6,}");
                              if (!passwordRegex.hasMatch(password)) {
                                return 'Please enter a minimum 6 character password';
                              }
                              return null;
                            },
                            controller: _passwordController,
                            obscureText: !passwordVisible,
                            autocorrect: false,
                            decoration: InputDecoration(
                                prefixIcon: const Icon(Icons.lock_outline),
                                suffixIcon: GestureDetector(
                                  onTap: () {
                                    setState(() {
                                      passwordVisible = !passwordVisible;
                                    });
                                  },
                                  child: Icon(passwordVisible
                                      ? Icons.visibility_outlined
                                      : Icons.visibility_off_outlined),
                                ),
                                labelText: 'Password',
                                border: const OutlineInputBorder(
                                    borderRadius:
                                        BorderRadius.all(Radius.circular(10)))),
                          ),
                          const SizedBox(
                            height: 10,
                          ),
                          TextFormField(
                            validator: (value) {
                              String? password = value?.trim();
                              if (password == null || password.isEmpty) {
                                return 'Please enter a password';
                              }

                              if (password != _passwordController.text.trim()) {
                                return 'The passwords do not match';
                              }

                              RegExp passwordRegex =
                                  RegExp(r"(?=.*[0-9a-zA-Z]).{6,}");
                              if (!passwordRegex.hasMatch(password)) {
                                return 'Please enter a minimum 6 character password';
                              }

                              return null;
                            },
                            controller: _repasswordController,
                            obscureText: !passwordVisible,
                            autocorrect: false,
                            decoration: InputDecoration(
                                prefixIcon: const Icon(Icons.lock_outline),
                                suffixIcon: GestureDetector(
                                  onTap: () {
                                    setState(() {
                                      passwordVisible = !passwordVisible;
                                    });
                                  },
                                  child: Icon(passwordVisible
                                      ? Icons.visibility_outlined
                                      : Icons.visibility_off_outlined),
                                ),
                                labelText: 'Confirm Password',
                                border: const OutlineInputBorder(
                                    borderRadius:
                                        BorderRadius.all(Radius.circular(10)))),
                          ),
                          const SizedBox(
                            height: 10,
                          ),
                          ElevatedButton(
                              onPressed: () {
                                if (_formField.currentState!.validate()) {
                                  context.read<AuthBloc>().add(SignUpRequested(
                                      _emailController.text.trim(),
                                      _passwordController.text.trim()));
                                }
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
