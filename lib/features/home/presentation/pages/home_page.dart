import 'package:curved_navigation_bar/curved_navigation_bar.dart';
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
          label: 'Animated turtle',
          child: Lottie.asset(
            'assets/lottie/turtle.json',
            height: 500,
            fit: BoxFit.contain,
            repeat: true,
          ),
        ),
      ),
      bottomNavigationBar: CurvedNavigationBar(
          backgroundColor: Theme.of(context).scaffoldBackgroundColor,
          color: Theme.of(context).colorScheme.secondary,
          items: [
        Icon(Icons.home),
        Icon(Icons.favorite),
        Icon(Icons.wine_bar),
        Icon(Icons.settings),
      ]),
    );
  }
}
