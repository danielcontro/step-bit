import 'package:flutter/material.dart';
import 'package:stepbit/screens/homepage.dart';
import 'package:stepbit/screens/login.dart';
import 'package:stepbit/utils/app_interceptor.dart';
import 'package:stepbit/utils/token_manager.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  static const forceLoginForm = false;

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: FutureBuilder(
          future: showLoginPage(),
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              final showLogin = snapshot.data as bool;
              return showLogin || forceLoginForm
                  ? const Login()
                  : const HomePage();
            } else {
              return Scaffold(
                  appBar: AppBar(title: const Text("StepBit")),
                  body: const Loading());
            }
          }),
      debugShowCheckedModeBanner: false,
    );
  }

  Future<bool> showLoginPage() async {
    final isTokenExpired = await TokenManager.isTokenExpired();
    if (!isTokenExpired) {
      return false;
    }
    final credentialStillValid = await AppInterceptor().refreshToken();
    return !credentialStillValid;
  }
}

class Loading extends StatelessWidget {
  const Loading({super.key});

  @override
  Widget build(BuildContext context) {
    return const Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text("Loading",
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 20,
              )),
          SizedBox(height: 32),
          CircularProgressIndicator(),
        ],
      ),
    );
  }
}
