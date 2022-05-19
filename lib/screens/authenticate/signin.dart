import 'package:careofbeauty/services/authentication_service.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class SignIn extends StatelessWidget {
  const SignIn({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final TextEditingController emailController = TextEditingController();
    final TextEditingController passwordController = TextEditingController();
    final GlobalKey<FormState> _key = GlobalKey<FormState>();
    return Scaffold(
      appBar: AppBar(
        actions: [
          IconButton(
            icon: const Icon(Icons.person),
            iconSize: 40.0,
            onPressed: () {
              context.read<AuthenticationService>().guestSignIn();
            },
          )
        ],
        backgroundColor: Colors.amber[400],
        elevation: 0.0,
        title: const Text('Welcome'),
      ),
      body: Stack(
        fit: StackFit.expand,
        children: [
          const Image(
            image: AssetImage('assets/image/logo.png'),
            fit: BoxFit.cover,
            color: Color(0x07070707),
            colorBlendMode: BlendMode.darken,
          ),
          Column(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              Form(
                key: _key,
                child: Theme(
                  data: ThemeData(
                    brightness: Brightness.dark,
                    primarySwatch: Colors.amber,
                    inputDecorationTheme: InputDecorationTheme(
                      labelStyle: TextStyle(
                        color: Colors.amber[400],
                        fontSize: 20.0,
                      ),
                    ),
                  ),
                  child: Container(
                    padding: const EdgeInsets.all(20.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        TextFormField(
                          validator: (val) {
                            String value = val.toString();
                            if (value.isEmpty) {
                              return "Email cannot be empty!";
                            } else if (!value.contains('@') ||
                                !value.contains('.')) {
                              return "Please input a valid email!";
                            } else {
                              return null;
                            }
                          },
                          controller: emailController,
                          keyboardType: TextInputType.emailAddress,
                          decoration: const InputDecoration(
                            labelText: 'Email',
                          ),
                        ),
                        TextFormField(
                          validator: (val) {
                            String value = val.toString();
                            if (value.isEmpty) {
                              return "Password cannot be empty!";
                            } else if (value.length < 6) {
                              return "Passowrd must be 6 characters!";
                            } else if (value.length > 15) {
                              return "Password cannot be 16 characters long!";
                            } else {
                              return null;
                            }
                          },
                          keyboardType: TextInputType.text,
                          obscureText: true,
                          controller: passwordController,
                          decoration: const InputDecoration(
                            labelText: "Password",
                          ),
                        ),
                        const SizedBox(height: 20.0),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            ElevatedButton(
                              onPressed: () {
                                if (_key.currentState!.validate()) {
                                  context
                                      .read<AuthenticationService>()
                                      .register(
                                          email: emailController.text.trim(),
                                          password:
                                              passwordController.text.trim());
                                }
                              },
                              child: const Text('Register'),
                            ),
                            const SizedBox(width: 20.0),
                            ElevatedButton(
                              onPressed: () {
                                if (_key.currentState!.validate()) {
                                  context.read<AuthenticationService>().signIn(
                                      email: emailController.text
                                          .trim()
                                          .toLowerCase(),
                                      password: passwordController.text.trim());
                                }
                              },
                              child: const Text('Sign In'),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
