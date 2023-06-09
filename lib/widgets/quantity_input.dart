import 'package:flutter/material.dart';

import '../utils/app_colors.dart';

class QuantityInput extends StatefulWidget {
  final int initialValue;
  final int min;
  final int max;
  final int step;

  final void Function(int val) onChanged;

  const QuantityInput(
      {super.key,
      required this.initialValue,
      required this.min,
      required this.max,
      required this.step,
      required this.onChanged});

  @override
  State<QuantityInput> createState() => _QuantityInput();
}

class _QuantityInput extends State<QuantityInput> {
  int _currentValue = 0;

  @override
  void initState() {
    super.initState();
    _currentValue = widget.initialValue;
  }

  @override
  Widget build(BuildContext context) {
    return ListView(
      scrollDirection: Axis.vertical,
      shrinkWrap: true,
      padding: const EdgeInsets.all(8),
      children: <Widget>[
        const Text(
          "Set diameter in km",
          style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            IconButton(
                onPressed: () {
                  setState(() {
                    if (_currentValue > widget.min) {
                      _currentValue -= widget.step;
                    }
                    widget.onChanged(_currentValue);
                  });
                },
                icon: Icon(
                  Icons.remove_circle,
                  color: AppColors.primaryColor,
                )),
            Text(
              _currentValue.toString(),
              style: const TextStyle(fontSize: 30),
            ),
            IconButton(
                onPressed: () {
                  setState(() {
                    if (_currentValue < widget.max) {
                      _currentValue += widget.step;
                    }
                    widget.onChanged(_currentValue);
                  });
                },
                icon: Icon(
                  Icons.add_circle,
                  color: AppColors.primaryColor,
                )),
          ],
        )
      ],
    );
  }
}
