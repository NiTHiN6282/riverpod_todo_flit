import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod_todo_flit/core/providers/providers.dart';
import 'package:riverpod_todo_flit/features/auth/controller/auth_controller.dart';

class SplashScreen extends ConsumerStatefulWidget {
  const SplashScreen({super.key});

  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends ConsumerState<SplashScreen> {
  checkUser() async {
    var prefs = await ref.watch(sharedPrefsProvider.future);
    if (mounted) {
      ref.watch(authControllerProvider.notifier).keepLogin(prefs, context);
    }
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    checkUser();
  }

  @override
  void initState() {
    super.initState();
    
  }

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: Center(
        child: SizedBox(
          width: 80,
          height: 80,
          child: CircularProgressIndicator(),
        ),
      ),
    );
  }
}
