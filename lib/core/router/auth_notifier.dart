import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:sailantro/features/auth/presentation/cubits/auth_cubit.dart';
import 'package:sailantro/features/auth/presentation/cubits/auth_state.dart';

class AuthNotifier extends ChangeNotifier {

  final AuthCubit _authCubit;
  late final StreamSubscription<AuthState> _authSubscription;

  AuthNotifier(this._authCubit) {
    _authSubscription = _authCubit.stream.listen((_) {
      notifyListeners();
    });
  }

  @override
  void dispose() {
    _authSubscription.cancel();
    super.dispose();
  }
}
