import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:map_app/blocs/authentication/auth_bloc.dart';
import 'package:map_app/blocs/authentication/auth_event.dart';
import 'package:map_app/blocs/authentication/auth_state.dart';
import 'package:map_app/pages/map_page.dart';
import 'package:map_app/pages/signup_page.dart';
import 'package:map_app/repositories/auth_repository.dart';

class LogInPage extends StatefulWidget {
  const LogInPage({super.key});

  @override
  State<LogInPage> createState() => _LogInPageState();
}

class _LogInPageState extends State<LogInPage> {
  final _formField = GlobalKey<FormState>();

  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  bool passwordVisible = false;

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<AuthBloc, AuthState>(
      listener: (context, state) {
        if (state is AuthenticatedAuth) {
          _emailController.clear();
          _passwordController.clear();

          Navigator.of(context).pushReplacement(
            MaterialPageRoute(
              builder: (context) => const MapPage(),
            ),
          );
        }

        if (state is UnauthenticatedAuth) {
          String firebaseAuthErrorMsg = "Unexpected";

          if (state.exception is WrongPasswordException) {
            firebaseAuthErrorMsg =
                "Incorrect password for ${_emailController.text.trim()}";
          } else if (state.exception is UserNotFoundException) {
            firebaseAuthErrorMsg =
                "No account for ${_emailController.text.trim()} exists";
          } else if (state.exception is UserDisabledException) {
            firebaseAuthErrorMsg =
                "Account for ${_emailController.text.trim()} has been disabled";
          } else if (state.exception is EmailInUseException) {
            firebaseAuthErrorMsg = "Email is already in use";
          }

          if (state.exception != null) {
            ScaffoldMessenger.of(context).showSnackBar(SnackBar(
              content: Text(firebaseAuthErrorMsg),
            ));
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
                  const Row(
                    children: [
                      Text(
                        'Log In',
                        textAlign: TextAlign.start,
                        style: TextStyle(
                            fontSize: 20, fontWeight: FontWeight.bold),
                      ),
                      SizedBox(
                        width: 5,
                      ),
                      Icon(Icons.lock_open_sharp)
                    ],
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
                          ElevatedButton(
                              onPressed: () {
                                if (_formField.currentState!.validate()) {
                                  context.read<AuthBloc>().add(SignInRequested(
                                      _emailController.text.trim(),
                                      _passwordController.text.trim()));
                                }
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
