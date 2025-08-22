import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sailantro/features/auth/data/firebase_auth_repository.dart';
import 'package:sailantro/features/auth/presentation/pages/auth_page.dart';
import 'package:sailantro/features/auth/presentation/cubits/auth_cubit.dart';
import 'package:sailantro/features/auth/presentation/cubits/auth_state.dart';
import 'package:sailantro/firebase_options.dart';
import 'package:sailantro/themes/dark_mode.dart';
import 'package:sailantro/themes/light_mode.dart';

import 'features/auth/presentation/components/auth_progress_indicator.dart';
import 'features/auth/presentation/pages/register_page.dart';
import 'features/home/presentation/pages/home_page.dart';

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
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        home: BlocConsumer<AuthCubit, AuthState>(
          builder: (context, state) {
            if (state is Unauthenticated) {
              return const AuthPage();
            }
            if (state is Authenticated) {
              return const HomePage();
            } else {
              return AuthProgressIndicator();
            }
          },
          listener: (context, state) {
            if (state is AuthError) {
              ScaffoldMessenger.of(context)
                  .showSnackBar(SnackBar(content: Text(state.message)));
            }
          },
        ),
        theme: lightMode,
        darkTheme: darkMode,
        themeMode: ThemeMode.light,
      ),
    );
  }
}
