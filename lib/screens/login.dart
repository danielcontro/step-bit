import 'package:flutter/material.dart';
import 'package:stepbit/screens/homepage.dart';

import '../utils/api_client.dart';

class Login extends StatefulWidget {
  const Login({Key? key}) : super(key: key);

  @override
  State<StatefulWidget> createState() => LoginState();
}

class LoginState extends State<Login> {
  final formKey = GlobalKey<FormState>();
  String? _username;
  String? _password;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text("StepBit"),
        ),
        body: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Form(
            key: formKey,
            child:
                Column(mainAxisAlignment: MainAxisAlignment.center, children: [
              const Text("Login",
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20)),
              TextFormField(
                decoration: const InputDecoration(
                    labelText: 'Username', icon: Icon(Icons.person)),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter your username';
                  }
                  return null;
                },
                onSaved: (value) => _username = value!,
              ),
              const SizedBox(height: 16.0),
              TextFormField(
                decoration: const InputDecoration(
                    labelText: 'Password', icon: Icon(Icons.password)),
                obscureText: true,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter your password';
                  }
                  return null;
                },
                onSaved: (value) => _password = value!,
              ),
              const SizedBox(height: 32.0),
              ElevatedButton(
                  child: const Text('Login'),
                  onPressed: () async {
                    if (formKey.currentState!.validate()) {
                      formKey.currentState!.save();
                      await login(context, _username!, _password!);
                    }
                  })
            ]),
          ),
        ));
  }

  Future<void> login(
    BuildContext context,
    String username,
    String password,
  ) async {
    if (username.isEmpty || password.isEmpty) {
      return;
    }
    final result = await ApiClient.login(username, password);
    if (result && context.mounted) {
      Navigator.pushReplacement(
          context, MaterialPageRoute(builder: (context) => const HomePage()));
    } else if (context.mounted) {
      ScaffoldMessenger.of(context)
        ..removeCurrentSnackBar()
        ..showSnackBar(
          const SnackBar(content: Text('Invalid credential')),
        );
    }
  }
}
