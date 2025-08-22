import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:lottie/lottie.dart';

import '../../../../core/router/routes.dart';
import '../components/auth_button.dart';
import '../components/auth_text_field.dart';
import '../cubits/auth_cubit.dart';
import '../cubits/auth_state.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final emailController = TextEditingController();
  final passwordController = TextEditingController();

  void login() {
    final String email = emailController.text.trim().toLowerCase();
    final String password = passwordController.text.trim();

    final authCubit = context.read<AuthCubit>();

    if (email.isNotEmpty && password.isNotEmpty) {
      authCubit.login(email, password);
    } else {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text("Please complete all fields!")));
    }
  }

  @override
  void dispose() {
    emailController.dispose();
    passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<AuthCubit, AuthState>(
      builder: (BuildContext context, state) {
        final isLoading = state is AuthLoading;
        return Stack(
          children: [
            _LoginForm(
              emailController: emailController,
              passwordController: passwordController,
              onLogin: login,
            ),
            if (isLoading)
              Container(
                color: Colors.black.withValues(alpha: 0.3),
                child: const Center(child: CircularProgressIndicator()),
              ),
          ],
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

class _LoginForm extends StatelessWidget {
  final TextEditingController emailController;
  final TextEditingController passwordController;
  final VoidCallback onLogin;

  const _LoginForm({
    required this.emailController,
    required this.passwordController,
    required this.onLogin,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 25.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Semantics(
                label: 'Animated sailing boat',
                child: Lottie.asset(
                  'assets/lottie/swinging_boat.json',
                  height: 200,
                  fit: BoxFit.contain,
                  repeat: true,
                ),
              ),
              const SizedBox(height: 25),
              Text(
                "S A I L I N G O",
                style: TextStyle(
                  fontSize: 24,
                  color: Theme.of(context).colorScheme.primary,
                ),
              ),
              Text(
                "Duolingo for sailing",
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
              const SizedBox(height: 10),
              AuthTextField(
                controller: passwordController,
                labelText: "Password",
                obscureText: true,
              ),
              const SizedBox(height: 10),
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  Text(
                    "Forgot Password?",
                    style: TextStyle(
                      color: Theme.of(context).colorScheme.primary,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 15),
              AuthButton(text: "LOGIN", onTap: onLogin),
              const SizedBox(height: 25),
              Row(
                children: [
                  Text(
                    "Don't have an account?",
                    style: TextStyle(
                      color: Theme.of(context).colorScheme.primary,
                    ),
                  ),
                  GestureDetector(
                    onTap: () {
                      context.go(RoutePaths.authRegister);
                    },
                    child: Text(
                      " Register now",
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
