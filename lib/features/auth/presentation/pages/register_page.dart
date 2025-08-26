import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:lottie/lottie.dart';
import 'package:sailantro/features/auth/presentation/cubits/auth_cubit.dart';

import '../../../../core/router/routes.dart';
import '../../../../core/utils/validators.dart';
import '../components/auth_button_widget.dart';
import '../components/auth_text_field_widget.dart';
import '../cubits/auth_state.dart';

class RegisterPage extends StatefulWidget {
  const RegisterPage({super.key});

  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  final nameController = TextEditingController();
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  final confirmPasswordController = TextEditingController();
  bool _isButtonEnabled = false;

  @override
  void initState() {
    super.initState();
    // Add listeners to text controllers
    nameController.addListener(_updateButtonState);
    emailController.addListener(_updateButtonState);
    passwordController.addListener(_updateButtonState);
    confirmPasswordController.addListener(_updateButtonState);
  }

  void _updateButtonState() {
    final name = nameController.text.trim();
    final email = emailController.text.trim();
    final password = passwordController.text.trim();
    final confirmPassword = confirmPasswordController.text.trim();

    final isEnabled =
        name.isNotEmpty &&
        isValidEmail(email) &&
        password.isNotEmpty &&
        confirmPassword.isNotEmpty &&
        password == confirmPassword;
    if (_isButtonEnabled != isEnabled) {
      setState(() {
        _isButtonEnabled = isEnabled;
      });
    }
  }

  void register() {
    final name = nameController.text.trim();
    final email = emailController.text.trim().toLowerCase();
    final password = passwordController.text.trim();
    final confirmPassword = confirmPasswordController.text.trim();

    final authCubit = context.read<AuthCubit>();

    if (name.isEmpty ||
        email.isEmpty ||
        password.isEmpty ||
        confirmPassword.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Please complete all fields!")),
      );
      return;
    }

    if (!isValidEmail(email)) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Please enter a valid email address.")),
      );
      return;
    }

    if (password != confirmPassword) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text("Passwords do not match.")));
      return;
    }

    authCubit.register(name, email, password);
  }

  @override
  void dispose() {
    nameController.dispose();
    emailController.dispose();
    passwordController.dispose();
    confirmPasswordController.dispose();
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
              _RegistrationForm(
                nameController: nameController,
                emailController: emailController,
                passwordController: passwordController,
                confirmPasswordController: confirmPasswordController,
                onRegister: register,
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

class _RegistrationForm extends StatelessWidget {
  final TextEditingController nameController;
  final TextEditingController emailController;
  final TextEditingController passwordController;
  final TextEditingController confirmPasswordController;
  final VoidCallback onRegister;
  final bool isButtonEnabled;

  const _RegistrationForm({
    required this.nameController,
    required this.emailController,
    required this.passwordController,
    required this.confirmPasswordController,
    required this.onRegister,
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
                "Let's create an account for you",
                style: TextStyle(
                  fontSize: 16,
                  color: Theme.of(context).colorScheme.primary,
                ),
              ),
              const SizedBox(height: 25),
              AuthTextFieldWidget(
                controller: nameController,
                labelText: "Name",
                obscureText: false,
                autocorrect: false,
              ),
              const SizedBox(height: 10),
              AuthTextFieldWidget(
                controller: emailController,
                labelText: "Email",
                obscureText: false,
                autocorrect: false,
              ),
              const SizedBox(height: 10),
              AuthTextFieldWidget(
                controller: passwordController,
                labelText: "Password",
                obscureText: true,
              ),
              const SizedBox(height: 10),
              AuthTextFieldWidget(
                controller: confirmPasswordController,
                labelText: "Confirm Password",
                obscureText: true,
              ),

              const SizedBox(height: 25),
              AuthButtonWidget(
                text: "SIGN UP",
                onTap: onRegister,
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
