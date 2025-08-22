import 'package:flutter/material.dart';

class AuthProgressIndicator extends StatelessWidget {
  const AuthProgressIndicator({super.key});

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: Center(child: CircularProgressIndicator()),
    );
  }
}
