import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:stepbit/utils/api_client.dart';

class HomePage extends StatelessWidget {
  const HomePage({Key? key}) : super(key: key);

  static const routename = 'HomePage';

  Widget userGreeting(String name) {
    return Text(
      "Ciao $name!",
      style: const TextStyle(
        fontWeight: FontWeight.bold,
        fontSize: 30,
      ),
    ).animate().fade(duration: 500.ms).slideX(curve: Curves.easeIn);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(HomePage.routename),
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          userGreeting("Luca"),
          ElevatedButton(
              onPressed: () async {
                final result = await ApiClient.getSteps(DateTime(2023, 4, 4));
                result?.forEach((element) => print(element));
                final message =
                    result == null ? 'Request failed' : 'Request successful';
                if (context.mounted) {
                  ScaffoldMessenger.of(context)
                    ..removeCurrentSnackBar()
                    ..showSnackBar(SnackBar(content: Text(message)));
                }
              },
              child: const Text('Get the data')),
        ],
      ),
    );
  }
}
