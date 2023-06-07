import 'package:flutter/material.dart';

class Favorites extends StatelessWidget {
  const Favorites({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return const Text(
      'Favorites',
      style: TextStyle(fontSize: 30, fontWeight: FontWeight.bold),
    );
  }
}
