import 'package:flutter/material.dart';

class AuthTextField extends StatelessWidget {
  final TextEditingController controller;
  final String hintText;
  final bool obscureText;
  final bool autocorrect;
  final String? Function(String?)? validator;

  const AuthTextField({super.key, required this.controller, required this.hintText,
    required this.obscureText, this.autocorrect = true, this.validator});

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: controller,
      obscureText: obscureText,
      autocorrect: autocorrect,
      validator: validator,
      textInputAction: obscureText ? TextInputAction.done : TextInputAction.next,
      decoration: InputDecoration(
        hintText: hintText,
      ),
    );
  }
}
