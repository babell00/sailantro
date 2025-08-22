import 'package:flutter/material.dart';

class AuthTextField extends StatelessWidget {
  final TextEditingController controller;
  final String labelText;
  final bool obscureText;
  final bool autocorrect;
  final TextInputType? keyboardType;
  final Widget? prefixIcon;
  final String? Function(String?)? validator;
  final TextInputAction? textInputAction;
  final void Function(String)? onSubmitted;

  const AuthTextField({
    super.key,
    required this.controller,
    required this.labelText,
    required this.obscureText,
    this.autocorrect = true,
    this.keyboardType,
    this.prefixIcon,
    this.validator,
    this.textInputAction,
    this.onSubmitted,
  });

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: controller,
      obscureText: obscureText,
      autocorrect: autocorrect,
      keyboardType: keyboardType,
      validator: validator,
      textInputAction: textInputAction ?? (obscureText ? TextInputAction.done : TextInputAction.next),
      onFieldSubmitted: onSubmitted,
      autofillHints: obscureText
          ? const [AutofillHints.password]
          : const [AutofillHints.email],
      decoration: InputDecoration(
        hintText: labelText,
        prefixIcon: prefixIcon,
      ),
    );
  }
}
