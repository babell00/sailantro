import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:lottie/lottie.dart';

import '../../../auth/presentation/cubits/auth_cubit.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Home Page"),
        actions: [
          IconButton(
            onPressed: () {
              final authCubit = context.read<AuthCubit>();
              authCubit.logout();
            },
            icon: Icon(Icons.logout),
          ),
        ],
      ),
      body: Center(
        child: Semantics(
          label: 'Animated sailing boat',
          child: Lottie.asset(
            'assets/lottie/turtle.json',
            height: 500,
            fit: BoxFit.contain,
            repeat: true,
          ),
        ),
      ),
    );
  }
}
