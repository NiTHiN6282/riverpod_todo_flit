import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod_todo_flit/features/auth/screens/login_screen.dart';
import 'package:riverpod_todo_flit/features/home/screens/home_screen.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../../core/providers/providers.dart';
import '../repository/auth_repository.dart';

final authControllerProvider =
    NotifierProvider<AuthController, bool>(() => AuthController());

class AuthController extends Notifier<bool> {
  @override
  bool build() {
    return false;
  }

  void signInWithGoogle(BuildContext context) async {
    state = true;
    var res = await ref.watch(authRepositoryProvider).signInWithGoogle();
    state = false;

    res.fold((l) {
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text(l.message)));
    }, (r) async {
      print(r.toMap());
      var prefs = await ref.watch(sharedPrefsProvider.future);
      prefs.setString("id", r.id);

      Navigator.pushAndRemoveUntil(
          context,
          MaterialPageRoute(
            builder: (context) => const HomeScreen(),
          ),
          (route) => false);
    });
  }

  void keepLogin(SharedPreferences prefs, BuildContext context) async {
    var res = await ref.watch(authRepositoryProvider).keepLogin(prefs);
    res.fold((l) {
      Navigator.pushAndRemoveUntil(
          context,
          MaterialPageRoute(
            builder: (context) => const LoginScreen(),
          ),
          (route) => false);
    }, (r) {
      Navigator.pushAndRemoveUntil(
          context,
          MaterialPageRoute(
            builder: (context) => const HomeScreen(),
          ),
          (route) => false);
    });
  }

  logOut(SharedPreferences prefs, BuildContext context) async {
    await ref.watch(authRepositoryProvider).logOut(prefs);

    Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(
          builder: (context) => const LoginScreen(),
        ),
        (route) => false);
  }
}
