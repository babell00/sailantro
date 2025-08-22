import 'package:sailantro/core/router/routes.dart';
import 'package:sailantro/features/auth/presentation/pages/register_page.dart';

import '../../features/auth/presentation/cubits/auth_cubit.dart';
import '../../features/auth/presentation/cubits/auth_state.dart';
import '../../features/auth/presentation/pages/login_page.dart';
import '../../features/home/presentation/pages/home_page.dart';
import 'auth_notifier.dart';
import 'package:go_router/go_router.dart';

class AppRouter {
  static GoRouter router(AuthCubit authCubit) {
    return GoRouter(
      debugLogDiagnostics: true,
      refreshListenable: AuthNotifier(authCubit),
      initialLocation: RoutePaths.home,
      routes: [
        GoRoute(
          path: RoutePaths.home,
          builder: (context, state) => const HomePage(),
        ),
        GoRoute(path: RoutePaths.authLogin, builder: (context, state) => const LoginPage()),
        GoRoute(path: RoutePaths.authRegister, builder: (context, state) => const RegisterPage()),
      ],
      redirect: (context, state) {
        final authState = authCubit.state;

        final isAuthRoute = state.matchedLocation == RoutePaths.authLogin
            || state.matchedLocation == RoutePaths.authRegister;

        if (authState is Unauthenticated || authState is AuthError) {
          return isAuthRoute ? null : RoutePaths.authLogin;
        }

        if (authState is Authenticated && isAuthRoute) {
          return RoutePaths.home;
        }
        return null;
      },
    );
  }
}
