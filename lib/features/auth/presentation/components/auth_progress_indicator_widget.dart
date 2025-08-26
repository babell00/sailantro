import 'package:flutter/material.dart';

class AuthProgressIndicatorWidget extends StatelessWidget {
  const AuthProgressIndicatorWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: Center(child: CircularProgressIndicator()),
    );
  }
}
