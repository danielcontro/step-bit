import 'package:flutter/material.dart';

class Maps extends StatelessWidget {
  final int data;
  final Function callback;

  const Maps({Key? key, required this.data, required this.callback})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Text(
      'Maps $data',
      style: const TextStyle(fontSize: 30, fontWeight: FontWeight.bold),
    );
  }
}
