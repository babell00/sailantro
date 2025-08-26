import 'package:flutter/material.dart';

class Chest extends StatelessWidget {
  const Chest({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 24.0),
      child: Container(
        width: 24.0,
        height: 24.0,
        color: Colors.red, // A visual indicator
      ),
    );
  }
}
