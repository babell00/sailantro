import 'package:flutter/material.dart';

class AuthButton extends StatelessWidget {
  final VoidCallback? onTap;
  final String text;

  const AuthButton({super.key, this.onTap, required this.text});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      child: FilledButton(
        style: ButtonStyle(
          backgroundColor: WidgetStateProperty.all<Color?>(
            Theme.of(context).colorScheme.tertiary,
          ),
        ),
        onPressed: onTap,
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 16),
          child: Text(text),
        ),
      ),
    );
  }
}

//          color:
