import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:lottie/lottie.dart';

import '../../../../core/router/routes.dart';
import '../../../../core/utils/validators.dart';
import '../components/auth_button.dart';
import '../components/auth_text_field.dart';
import '../cubits/auth_cubit.dart';
import '../cubits/auth_state.dart';

class ForgotPasswordPage extends StatefulWidget {
  const ForgotPasswordPage({super.key});

  @override
  State<ForgotPasswordPage> createState() => _ForgotPasswordPageState();
}

class _ForgotPasswordPageState extends State<ForgotPasswordPage> {
  final emailController = TextEditingController();
  bool _isButtonEnabled = false;

  @override
  void initState() {
    super.initState();
    // Add listeners to text controllers
    emailController.addListener(_updateButtonState);
  }

  void _updateButtonState() {
    final email = emailController.text.trim();
    final isEnabled = isValidEmail(email);
    if (_isButtonEnabled != isEnabled) {
      setState(() {
        _isButtonEnabled = isEnabled;
      });
    }
  }

  void rest() {
    final String email = emailController.text.trim().toLowerCase();

    final authCubit = context.read<AuthCubit>();

    if (email.isNotEmpty) {
      authCubit.forgotPassword(email);
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text("Please check your email!")));
    } else {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text("Please complete all fields!")));
    }
  }

  @override
  void dispose() {
    emailController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<AuthCubit, AuthState>(
      builder: (BuildContext context, state) {
        final isLoading = state is AuthLoading;
        return Scaffold(
          resizeToAvoidBottomInset: true,
          body: Stack(
            children: [
              _ForgotPasswordForm(
                emailController: emailController,
                onRest: rest,
                isButtonEnabled: _isButtonEnabled,
              ),
              if (isLoading)
                Container(
                  color: Colors.black.withValues(alpha: 0.3),
                  child: const Center(child: CircularProgressIndicator()),
                ),
            ],
          ),
        );
      },
      listener: (BuildContext context, state) {
        if (state is AuthError) {
          ScaffoldMessenger.of(
            context,
          ).showSnackBar(SnackBar(content: Text(state.message)));
        }
      },
    );
  }
}

class _ForgotPasswordForm extends StatelessWidget {
  final TextEditingController emailController;
  final VoidCallback onRest;
  final bool isButtonEnabled;

  const _ForgotPasswordForm({
    required this.emailController,
    required this.onRest,
    required this.isButtonEnabled,
  });

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: GestureDetector(
        onTap: () => FocusScope.of(context).unfocus(),
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 25.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              SizedBox(height: 50),
              Semantics(
                label: 'Animated sailing boat',
                child: Lottie.asset(
                  'assets/lottie/swinging_boat_2.json',
                  height: 200,
                  fit: BoxFit.contain,
                  repeat: true,
                ),
              ),
              const SizedBox(height: 15),
              Text(
                "S A I L I N G O",
                style: TextStyle(
                  fontSize: 24,
                  color: Theme.of(context).colorScheme.primary,
                ),
              ),
              Text(
                "Reset password",
                style: TextStyle(
                  fontSize: 16,
                  color: Theme.of(context).colorScheme.primary,
                ),
              ),
              const SizedBox(height: 25),
              AuthTextField(
                controller: emailController,
                labelText: "Email",
                obscureText: false,
                autocorrect: false,
              ),
              const SizedBox(height: 15),
              AuthButton(
                text: "RESET PASSWORD",
                onTap: onRest,
                isDisable: !isButtonEnabled,
              ),
              const SizedBox(height: 25),
              Row(
                children: [
                  Text(
                    "Already have an account?",
                    style: TextStyle(
                      color: Theme.of(context).colorScheme.primary,
                    ),
                  ),
                  GestureDetector(
                    onTap: () {
                      context.go(RoutePaths.authLogin);
                    },
                    child: Text(
                      " Login now",
                      style: TextStyle(
                        color: Theme.of(context).colorScheme.primary,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
