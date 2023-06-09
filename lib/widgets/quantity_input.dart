import 'package:flutter/material.dart';

import '../utils/app_colors.dart';

class QuantityInput extends StatefulWidget {
  final double initialValue;
  final double min;
  final double max;
  final double step;

  final void Function(double val) onChanged;

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
  double _currentValue = 0;

  @override
  void initState() {
    super.initState();
    _currentValue = widget.initialValue;
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          "How much do you want to walk?",
          textAlign: TextAlign.center,
          style: TextStyle(
            fontSize: 22,
            fontWeight: FontWeight.bold,
          ),
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            IconButton(
                iconSize: 50,
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
              '${_currentValue.round()} km',
              style: const TextStyle(fontSize: 30),
            ),
            IconButton(
                iconSize: 50,
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
