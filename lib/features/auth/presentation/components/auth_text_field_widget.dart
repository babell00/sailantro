import 'package:flutter/material.dart';

class AuthTextFieldWidget extends StatefulWidget {
  final TextEditingController controller;
  final String labelText;
  final bool obscureText;
  final bool autocorrect;
  final TextInputType? keyboardType;
  final Widget? prefixIcon;
  final String? Function(String?)? validator;
  final TextInputAction? textInputAction;
  final void Function(String)? onSubmitted;

  const AuthTextFieldWidget({
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
  State<AuthTextFieldWidget> createState() => _AuthTextFieldWidgetState();
}

class _AuthTextFieldWidgetState extends State<AuthTextFieldWidget> {
  late bool _obscure;

  @override
  void initState() {
    super.initState();
    _obscure = widget.obscureText;
  }

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: widget.controller,
      obscureText: _obscure,
      autocorrect: widget.autocorrect,
      keyboardType: widget.keyboardType,
      validator: widget.validator,
      textInputAction: widget.textInputAction ??
          (widget.obscureText ? TextInputAction.done : TextInputAction.next),
      onFieldSubmitted: widget.onSubmitted,
      autofillHints:
      widget.obscureText ? const [AutofillHints.password] : null,
      decoration: InputDecoration(
        hintText: widget.labelText,
        prefixIcon: widget.prefixIcon,
        suffixIcon: widget.obscureText
            ? IconButton(
          icon: Icon(
            _obscure ? Icons.visibility_off : Icons.visibility,
          ),
          onPressed: () {
            setState(() {
              _obscure = !_obscure;
            });
          },
        )
            : null,
      ),
    );
  }
}
