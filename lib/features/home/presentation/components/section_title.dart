import 'package:flutter/material.dart';

class SectionTitle extends StatelessWidget {
  final String title;

  const SectionTitle({super.key, required this.title});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        const Expanded(child: Divider(color: Color(0xFF2D3D41))),
        const SizedBox(width: 16),
        Text(
          title,
          style: const TextStyle(
            color: Color(0xFF52656D),
            fontWeight: FontWeight.bold,
            fontSize: 18.0,
          ),
        ),
        const SizedBox(width: 16),
        const Expanded(child: Divider(color: Color(0xFF2D3D41))),
      ],
    );
  }
}
