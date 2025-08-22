import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sailantro/features/auth/data/firebase_auth_repository.dart';
import 'package:sailantro/features/auth/presentation/cubits/auth_cubit.dart';
import 'package:sailantro/firebase_options.dart';
import 'package:sailantro/themes/dark_mode.dart';
import 'package:sailantro/themes/light_mode.dart';

import 'core/router/app_router.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  MyApp({super.key});

  final firebaseAuthRepo = FirebaseAuthRepository();

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider<AuthCubit>(
          create: (context) =>
          AuthCubit(authRepository: firebaseAuthRepo)..checkAuth(),
        ),
      ],
      child: Builder(
        builder: (context) {
          final authCubit = context.read<AuthCubit>();
          return MaterialApp.router(
            debugShowCheckedModeBanner: false,
            routerConfig: AppRouter.router(authCubit),
            theme: lightMode,
            darkTheme: darkMode,
            themeMode: ThemeMode.light,
          );
        },
      ),
    );
  }
}
