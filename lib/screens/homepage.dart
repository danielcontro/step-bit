import 'package:flutter/material.dart';
import 'package:stepbit/utils/api_client.dart';

import '../models/steps.dart';

class HomePage extends StatelessWidget {
  const HomePage({Key? key}) : super(key: key);

  static const routename = 'HomePage';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(HomePage.routename),
      ),
      body: Center(
          child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Text("You are logged in"),
          const SizedBox(
            height: 10,
          ),
          ElevatedButton(
              onPressed: () async {
                final result = await ApiClient.getSteps(DateTime(2023, 4, 4));
                result?.forEach((element) => print(element));
                final message =
                    result == null ? 'Request failed' : 'Request successful';
                ScaffoldMessenger.of(context)
                  ..removeCurrentSnackBar()
                  ..showSnackBar(SnackBar(content: Text(message)));
              },
              child: const Text('Get the data')),
        ],
      )),
    );
  }
}
